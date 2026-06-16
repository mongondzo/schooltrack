import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title; // Label (ex: "Élèves")
  final String value; // Valeur (ex: "120")
  final IconData icon; // Icône Material
  final Color color; // Couleur principale de la carte
  final Color iconBgColor; // Couleur de fond de l'icône
  final String? subtitle; // Texte secondaire optionnel (ex: "Voir plus")
  final VoidCallback? onTap; // Action au tap (optionnel)

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.iconBgColor,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ligne du haut : icône + flèche
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Fond de l'icône
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),

                // Flèche indiquant que la carte est cliquable
                if (onTap != null)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Valeur principale (nombre)
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1,
              ),
            ),

            const SizedBox(height: 4),

            // Label
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.85),
              ),
            ),

            // Sous-titre optionnel
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.65),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
