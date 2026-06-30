// ════════════════════════════════════════════════════════════════
// WIDGET : ParentsStatCard (parents_stat_card.dart)
// Rôle   : Carte à ajouter dans le Dashboard Admin.
//          Affiche le nombre total de parents enregistrés et
//          sert d'accès rapide vers ParentsPage.
//          Se connecte directement à Firestore pour compter
//          les documents (méthode simple pour débutant).
// ════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schooltrack/features/parents/presentation/pages/parents_page.dart';

class ParentsStatCard extends StatelessWidget {
  const ParentsStatCard({super.key, required Null Function() onTap});

  // Récupère le nombre total de documents dans la collection 'parents'
  // .count() est une requête légère qui ne télécharge pas les documents
  Future<int> _getParentsCount() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('parents')
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ParentsPage()),
        );
      },

      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF7C3AED), // Violet pour distinguer la carte
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6D28D9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.family_restroom_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
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

            // Valeur dynamique récupérée depuis Firestore
            FutureBuilder<int>(
              future: _getParentsCount(),
              builder: (context, snapshot) {
                final value = snapshot.hasData ? '${snapshot.data}' : '...';
                return Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1,
                  ),
                );
              },
            ),

            const SizedBox(height: 4),
            Text(
              'Parents',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.85),
              ),
            ),
            Text(
              'Voir tous',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.white.withOpacity(0.65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
