import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final bool isFirstPage;
  final bool isLastPage;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final VoidCallback onCta;
  final PageController pageController;
  final int totalPages;

  const OnboardingPageWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.pageController,
    required this.totalPages,
    this.isFirstPage = false,
    this.isLastPage = false,
    required this.onSkip,
    required this.onNext,
    required this.onCta,
  });

  static const Color _wine = Color.fromARGB(255, 73, 18, 161);
  static const Color _bg = Color(0xFFFAF7F7);
  static const Color _text = Color(0xFF1A1A1A);
  static const Color _sub = Color(0xFF6B6B6B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          Expanded(
            flex: 60,
            child: Image.asset(
              imagePath,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFE8D5D8),
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 64,
                    color: _wine.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 40,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // le tiret du bordeaux
                  Container(
                    width: 50,
                    height: 3,
                    decoration: BoxDecoration(
                      color: _wine,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Titre
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _text,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Description
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: _sub,
                      height: 1.6,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 60,
                        child: !isLastPage
                            ? TextButton(
                                onPressed: onSkip,
                                style: TextButton.styleFrom(
                                  foregroundColor: _sub,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Arriere',
                                  style: TextStyle(fontSize: 15),
                                ),
                              )
                            : null,
                      ),

                      // ── SmoothPageIndicator
                      SmoothPageIndicator(
                        controller: pageController,
                        count: totalPages,
                        effect: WormEffect(
                          spacing: 8,
                          dotWidth: 8,
                          dotHeight: 8,
                          dotColor: Colors.black45,
                          activeDotColor: _wine,
                        ),
                        onDotClicked: (index) => pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn,
                        ),
                      ),

                      // Bouton à droite
                      _CtaButton(
                        label: isLastPage
                            ? 'Commencer'
                            : (isFirstPage ? "S'incrire " : 'Suivant'),
                        onTap: isLastPage
                            ? onCta
                            : (isFirstPage ? onCta : onNext),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  static const Color _wine = Color.fromARGB(255, 21, 6, 90);

  const _CtaButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 26, 5, 100),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward, size: 16),
        ],
      ),
    );
  }
}
