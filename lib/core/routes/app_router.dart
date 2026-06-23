import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:schooltrack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:schooltrack/features/auth/presentation/bloc/auth_state.dart';
import 'package:schooltrack/features/auth/presentation/pages/login_page.dart';
import 'package:schooltrack/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:schooltrack/features/splash/presentation/pages/splash_page.dart';

// Classe qui centralise toutes les routes de l'application
class AppRouter {
  // Noms des routes
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';

  // Clé de navigation globale (utile pour naviguer hors d'un widget)
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Configuration du router GoRouter
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: splash, // On démarre toujours par le splash screen
    // redirect évalue à chaque changement d'état si on doit rediriger
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;

      final isSplash = state.matchedLocation == splash;
      final isLogin = state.matchedLocation == login;

      // Si on est sur le splash, on laisse passer (il gère lui-même la redirection)
      if (isSplash) return null;

      // Si l'utilisateur est connecté et essaie d'aller sur login → dashboard
      if (authState is AuthAuthenticated && isLogin) {
        return dashboard;
      }

      // Si l'utilisateur n'est pas connecté et essaie d'aller ailleurs → login
      if (authState is AuthUnauthenticated && !isLogin) {
        return login;
      }

      return null; // Pas de redirection
    },

    routes: [
      // 1. Splash Screen
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // 2. Page de connexion Google
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // 3. Dashboard Administrateur
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
    ],

    // Page d'erreur si route introuvable
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Page introuvable : ${state.uri}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    ),
  );
}
