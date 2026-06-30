// ════════════════════════════════════════════════════════════════
// WIDGET : EmptyParentsWidget (empty_parents_widget.dart)
// Rôle   : Affiché quand la liste des parents est vide.
//          Donne un retour visuel clair + bouton d'action rapide.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyParentsWidget extends StatelessWidget {
  /// Callback optionnel déclenché par le bouton "Ajouter un parent"
  final VoidCallback? onAdd;

  const EmptyParentsWidget({super.key, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône illustrative dans un cercle bleu pâle
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.family_restroom_rounded,
                size: 52,
                color: Color(0xFF93C5FD),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Aucun parent enregistré',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Ajoutez un parent et associez-le\nà un ou plusieurs élèves.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: const Color(0xFF94A3B8),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            if (onAdd != null) ...[
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded, size: 20),
                label: Text(
                  'Ajouter un parent',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
