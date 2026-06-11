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
  @override
  void initState() {
    super.initState();

    context.read<AuthBloc>().add(AuthInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0), // Fond bleu
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitialState) {
            context.go('/onboarding');
          }
          if (state is AuthAuthenticatedState) {
            context.go('/home');
          }
          if (state is AuthUnauthenticatedState) {
            context.go('/LoginWithGoogle');
          }
          if (state is AuthErrorState) {
            context.go('/onboarding');
          }
          if (state is AuthCheckConnectionState) {
            context.go('/noInternetPage');
          }
        },
        child: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 3)),
          builder: (context, snapshot) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'SchoolTrack',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Indicateur de chargement
                  const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
