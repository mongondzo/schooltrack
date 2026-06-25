// ============================================================
// FICHIER : presentation/widgets/empty_schedules_widget.dart
//
// RÔLE : Affiché quand aucun créneau n'est trouvé (liste vide
// ou aucun résultat pour un filtre donné).
// ============================================================

import 'package:flutter/material.dart';
import 'app_colors.dart';

class EmptySchedulesWidget extends StatelessWidget {
  // Message personnalisable selon le contexte
  final String message;
  final String? subtitle;

  const EmptySchedulesWidget({
    super.key,
    this.message = 'Aucun emploi du temps enregistré',
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône illustrative
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.blue.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                size: 38,
                color: AppColors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
