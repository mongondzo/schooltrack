import 'package:go_router/go_router.dart';
import 'package:schooltrack/features/auth/presentation/pages/login_with_google.dart';
import 'package:schooltrack/features/auth/presentation/bloc/splash_page.dart';
import 'package:schooltrack/features/auth/presentation/pages/home_page.dart';
import 'package:schooltrack/features/auth/presentation/pages/no_internet_page.dart';
import 'package:schooltrack/features/auth/presentation/pages/onboarding_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/', // Démarre sur le SplashPage
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/loginWithGoogle',
      builder: (context, state) => const LoginWithGoogle(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/noInternetPage',
      builder: (context, state) => const NoInternetPage(),
    ),
  ],
);
