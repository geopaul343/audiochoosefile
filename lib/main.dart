import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:audiochoosefil/firebase_options.dart';
import 'package:audiochoosefil/screens/signin_screen.dart';
import 'package:audiochoosefil/services/auth_service.dart';
import 'package:audiochoosefil/viewmodels/auth_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProxyProvider<AuthService, AuthViewModel>(
          create: (context) => AuthViewModel(context.read<AuthService>()),
          update: (context, authService, previous) =>
              previous ?? AuthViewModel(authService),
        ),
      ],
      child: MaterialApp(
        title: 'Audio Analyzer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SignInScreen(title: 'Audio Analyzer'),
      ),
    );
  }
}
