// ============================================================
// FICHIER : presentation/pages/class_details_page.dart
//
// RÔLE : Affiche toutes les informations d'une classe.
// Cette page reçoit directement la ClassEntity depuis la liste
// (pas besoin de rappeler Firestore, les données sont déjà là).
//
// Elle propose aussi un bouton "Modifier" en haut à droite
// pour naviguer directement vers EditClassPage.
// ============================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/app_colors.dart';
import '../widgets/info_row.dart';
import '../../domain/entities/class_entity.dart';
import 'edit_class_page.dart';

class ClassDetailsPage extends StatelessWidget {
  final ClassEntity classEntity;

  const ClassDetailsPage({super.key, required this.classEntity});

  @override
  Widget build(BuildContext context) {
    // Formateur de date : "lundi 26 mai 2025 à 14:30"
    final dateFormatter = DateFormat("d MMMM yyyy 'à' HH:mm", 'fr_FR');

    // Si tu n'as pas la locale française configurée, utilise :
    // final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Détails de la classe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
            fontSize: 18,
          ),
        ),
        // Bouton modifier en haut à droite
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.blue),
            tooltip: 'Modifier',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditClassPage(classEntity: classEntity),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- En-tête avec icône et nom de la classe ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.blue, Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.class_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classEntity.nomClasse,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          classEntity.niveau,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- Carte statistique : effectif mis en valeur ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.green.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.groups_rounded,
                      color: AppColors.green,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Effectif total',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${classEntity.effectif} élèves',
                        style: const TextStyle(
                          color: AppColors.green,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- Bloc d'informations détaillées ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informations',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const Divider(height: 24, color: AppColors.border),
                  InfoRow(
                    icon: Icons.class_rounded,
                    label: 'Nom de la classe',
                    value: classEntity.nomClasse,
                  ),
                  InfoRow(
                    icon: Icons.stairs_rounded,
                    label: 'Niveau',
                    value: classEntity.niveau,
                  ),
                  InfoRow(
                    icon: Icons.groups_rounded,
                    label: 'Effectif',
                    value: '${classEntity.effectif} élèves',
                    iconColor: AppColors.green,
                  ),
                  InfoRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date de création',
                    // Essaie d'abord le format français. Si la locale
                    // n'est pas configurée, commente la ligne ci-dessous
                    // et utilise le commentaire alternatif.
                    value: _formatDate(classEntity.createdAt),
                  ),
                ],
              ),
            ),

            // --- Description (visible seulement si non vide) ---
            if (classEntity.description.trim().isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.notes_rounded,
                          color: AppColors.blue,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      classEntity.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),

            // --- Bouton modifier en bas ---
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditClassPage(classEntity: classEntity),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_rounded, size: 18),
                label: const Text(
                  'Modifier cette classe',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Formate la date de création.
  // Utilise le format simple si la locale française n'est pas configurée.
  String _formatDate(DateTime date) {
    try {
      return DateFormat("d MMM yyyy 'à' HH:mm", 'fr_FR').format(date);
    } catch (_) {
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    }
  }
}
