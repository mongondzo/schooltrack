import 'package:flutter/material.dart';

// ignore: camel_case_types
class builderpage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const builderpage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Image arrondie
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              imagePath,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEEF5),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.image_rounded,
                    size: 80,
                    color: Color(0xFFB0BEC5),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 36),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E), // Presque noir
              height: 1.3,
            ),
          ),

          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF7A8FA6), // Gris bleuté
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
