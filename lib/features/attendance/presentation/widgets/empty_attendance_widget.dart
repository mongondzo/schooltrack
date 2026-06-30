import 'package:flutter/material.dart';

/// -----------------------------------------------------------------------
/// EmptyAttendanceWidget
/// -----------------------------------------------------------------------
/// Affiché quand la liste des présences est vide (aucune présence
/// enregistrée, ou aucun résultat ne correspond à la recherche/au filtre).
/// -----------------------------------------------------------------------
class EmptyAttendanceWidget extends StatelessWidget {
  const EmptyAttendanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.fact_check_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune présence enregistrée',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Appuyez sur le bouton + pour ajouter une présence',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
