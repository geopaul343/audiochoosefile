import 'package:audiochoosefil/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audiochoosefil/screens/choosefilescreen.dart';
import 'package:audiochoosefil/services/auth_service.dart';
import 'package:audiochoosefil/viewmodels/auth_viewmodel.dart';
import 'package:audiochoosefil/widgets/sign_in_form.dart';

class SignInScreen extends StatefulWidget {
  final String title;

  const SignInScreen({super.key, required this.title});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AuthViewModel(AuthService());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailSignIn() async {
    if (await _viewModel.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    )) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (await _viewModel.signInWithGoogle()) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo and Title
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.audio_file,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Welcome to\nAudio Analyzer',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Sign in to continue',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 40),

                      // Toggle between Email and Google Sign-in
                      Consumer<AuthViewModel>(
                        builder: (context, viewModel, _) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => viewModel.setEmailSignIn(true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: viewModel.isEmailSignIn
                                            ? Colors.white.withOpacity(0.2)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Text(
                                        'Email',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        viewModel.setEmailSignIn(false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: !viewModel.isEmailSignIn
                                            ? Colors.white.withOpacity(0.2)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Text(
                                        'Google',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),

                      // Sign In Form or Google Button
                      Consumer<AuthViewModel>(
                        builder: (context, viewModel, _) {
                          if (viewModel.isEmailSignIn) {
                            return SignInForm(
                              emailController: _emailController,
                              passwordController: _passwordController,
                              onSignIn: _handleEmailSignIn,
                            );
                          } else {
                            return Container(
                              width: double.infinity,
                              height: 60,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ElevatedButton.icon(
                                onPressed: viewModel.isLoading
                                    ? null
                                    : _handleGoogleSignIn,
                                icon: viewModel.isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Image.network(
                                        'https://www.google.com/favicon.ico',
                                        height: 24,
                                      ),
                                label: Text(
                                  viewModel.isLoading
                                      ? 'Signing in...'
                                      : 'Sign in with Google',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 5,
                                ),
                              ),
                            );
                          }
                        },
                      ),

                      // Error Message
                      Consumer<AuthViewModel>(
                        builder: (context, viewModel, _) {
                          if (viewModel.errorMessage != null) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline,
                                        color: Colors.red),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        viewModel.errorMessage!,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.red),
                                      onPressed: viewModel.clearError,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      // Additional Info
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.white70,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Your audio files will be securely processed and analyzed using our advanced AI technology.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
