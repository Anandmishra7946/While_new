import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:com.example.while_app/view/home_screen.dart';
import 'package:com.example.while_app/view/auth/login_screen.dart';
import 'package:com.example.while_app/view/auth/register_screen.dart';
import 'package:com.example.while_app/view/onboarding_screen.dart';
import 'package:com.example.while_app/view_model/providers/auth_provider.dart';

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    final toggle = ref.watch(toggleStateProvider);

    return authState.when(
      data: (User? user) {
        if (user != null) {
          return const HomeScreen(); // User is signed in
        } else {
          switch (toggle) {
            case 0:
              return const OnBoardingScreen();
            case 1:
              return const LoginScreen();
            default:
              return SignUpScreen();
          }
        }
      },
      loading: () =>
          const CircularProgressIndicator(), // Show loading indicator while the stream is evaluating
      error: (e, stack) => Text(
          "Wrapper error  $e"), // Consider creating an error screen widget for better error handling
    );
  }
}
