import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:schooltrack/features/auth/presentation/pages/home_page.dart';
import 'package:schooltrack/features/auth/presentation/widgets/onboarding_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: [
            builderpage(
              imagePath: "assets/images/one.png",
              title: "Bienvenue sur SchoolTrack",
              subtitle:
                  "La plateforme qui facilite la communication entre les élèves, les parents, les enseignants et l’administration.",
            ),
            builderpage(
              imagePath: "assets/images/two.png",
              title: "Accédez à vos informations scolaires",
              subtitle:
                  "Suivez à distance les notes, les absences, les résultats et les horaires de vos enfants en temps réel.",
            ),
            builderpage(
              imagePath: "assets/images/three.png",
              title: "Gestion complète de l’établissement",
              subtitle:
                  "Administrez les utilisateurs, les classes, les enseignants, les élèves et les paramètres de l’établissement.",
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.blue,
                minimumSize: const Size.fromHeight(80),
              ),
              onPressed: () async {
                context.go('/loginWithGoogle');
                //Navigator.of(context).pushReplacement(
                //  MaterialPageRoute(builder: (context) => HomePage()),
                //);
              },
              child: const Text("Commencer", style: TextStyle(fontSize: 24)),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => controller.jumpToPage(2),
                    child: const Text("SKIP"),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller, // PageController
                      count: 3,
                      effect: WormEffect(
                        spacing: 16,
                        dotColor: Colors.black26,
                        activeDotColor: Colors.teal.shade700,
                      ),
                      onDotClicked: (index) => controller.animateToPage(
                        index,
                        duration: Duration(microseconds: 500),
                        curve: Curves.easeIn,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => controller.nextPage(
                      duration: const Duration(microseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                    child: const Text("NEXT"),
                  ),
                ],
              ),
            ),

      // Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       context.go('/loginWithGoogle');
      //     },
      //     child: const Text("Commencer"),
      //   ),
      // ),
    );
  }
}
