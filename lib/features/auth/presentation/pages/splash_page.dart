import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _minDelayDone = false;
  AuthState? _pendingState;

  @override
  void initState() {
    super.initState();

    context.read<AuthBloc>().add(AuthInitialEvent());

    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted) return;
      setState(() => _minDelayDone = true);
      if (_pendingState != null) {
        _navigate(_pendingState!);
      }
    });
  }

  // ── Navigation selon l'état BLoC ────────────────────────────────────────
  void _navigate(AuthState state) {
    if (state is AuthAuthenticatedState) {
      context.go('/home');
    } else if (state is AuthUnauthenticatedState) {
      context.go('/loginWithGoogle');
    } else if (state is AuthCheckConnectionState) {
      context.go('/noInternetPage');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1565C0),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (_minDelayDone) {
            _navigate(state);
          } else {
            _pendingState = state;
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'SchoolTrack',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gérez votre école intelligemment',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
