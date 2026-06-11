import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'auth_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

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
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticatedState) {
            context.go('/home');
          }

          if (state is AuthUnauthenticatedState) {
            context.go('/onboarding');
          }
        },
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
