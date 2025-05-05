import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final Dio _dio = Dio();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled by the user');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }

  Future<String?> getuserIdToken() async {
    if (currentUser != null) {
      final idToken = await currentUser!.getIdToken();
      print('ID Token: $idToken');
      return idToken;
    } else {
      print('No user is currently signed in.');
      return null;
    }
  }

// Call protected API with ID token
  Future<void> callProtectedApi(String idToken) async {
    final response = await _dio.post(
      'https://app-audio-analyzer-887192895309.us-central1.run.app/authentication',
      options: Options(
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json'
        },
      ),
    );

    if (response.statusCode == 200) {
      print('Success!');
    } else {
      print('Error: ${response.data}');
    }
  }

  // Handle Firebase Auth exceptions
  Exception _handleAuthException(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'No user found with this email';
        break;
      case 'wrong-password':
        message = 'Wrong password provided';
        break;
      case 'invalid-email':
        message = 'The email address is invalid';
        break;
      case 'user-disabled':
        message = 'This user has been disabled';
        break;
      case 'too-many-requests':
        message = 'Too many attempts. Please try again later';
        break;
      case 'account-exists-with-different-credential':
        message = 'An account already exists with the same email address';
        break;
      case 'invalid-credential':
        message = 'The credential is invalid or has expired';
        break;
      case 'operation-not-allowed':
        message = 'Google Sign In is not enabled';
        break;
      case 'network-request-failed':
        message = 'Network error occurred. Please check your connection';
        break;
      default:
        message = 'An error occurred during authentication';
    }
    return Exception(message);
  }
}
