import 'package:go_router/go_router.dart';
import 'package:schooltrack/features/auth/presentation/pages/login_with_google.dart';

import '../../features/auth/presentation/bloc/splash_page.dart';
import '../../features/auth/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/no_internet_page.dart';
import '../../features/auth/presentation/pages/onboarding.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
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
