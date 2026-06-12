import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:schooltrack/features/auth/presentation/widgets/onboarding_page_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();

  void _skip() => controller.jumpToPage(2);
  void _next() => controller.nextPage(
    duration: const Duration(milliseconds: 400),
    curve: Curves.easeInOut,
  );
  void _navigateAway() => context.go('/loginWithGoogle');

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      physics: const BouncingScrollPhysics(),
      children: [
        OnboardingPageWidget(
          imagePath: 'assets/images/first.jfif',
          title: 'Bienvenu chez SchoolTrack',
          description:
              'Gérez votre école, vos élèves et vos classes intelligemment depuis un seul endroit.',
          pageController: controller,
          totalPages: 3,
          isFirstPage: true,
          onSkip: _skip,
          onNext: _next,
          onCta: _navigateAway,
        ),

        OnboardingPageWidget(
          imagePath: 'assets/images/second.jfif',
          title: 'Suivez les Performances',
          description:
              'Accédez aux notes, absences et bulletins en temps réel pour chaque élève.',
          pageController: controller,
          totalPages: 3,
          onSkip: _skip,
          onNext: _next,
          onCta: _next,
        ),

        OnboardingPageWidget(
          imagePath: 'assets/images/3.jfif',
          title: 'Restez Connecté',
          description:
              'Communiquez facilement avec les parents, les enseignants et l\'administration.',
          pageController: controller,
          totalPages: 3,
          isLastPage: true,
          onSkip: _skip,
          onNext: _next,
          onCta: _navigateAway,
        ),
      ],
    );
  }
}
