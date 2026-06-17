// ============================================================
// FICHIER : presentation/widgets/class_card.dart
//
// RÔLE : Widget réutilisable qui affiche une carte pour une
// classe dans la liste. Montre le nom, niveau, effectif et
// le titulaire, avec les actions modifier/supprimer.
// ============================================================

import 'package:flutter/material.dart';
import '../../domain/entities/class_entity.dart';
import 'app_colors.dart';

class ClassCard extends StatelessWidget {
  final ClassEntity classEntity;

  // Callbacks : fonctions appelées selon l'action de l'utilisateur
  final VoidCallback onTap;       // Appuyer sur la carte → détails
  final VoidCallback onEdit;      // Bouton modifier
  final VoidCallback onDelete;    // Bouton supprimer

  const ClassCard({
    super.key,
    required this.classEntity,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        // Ombre légère pour donner du relief à la carte
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        // InkWell ajoute l'effet de vague (ripple) quand on appuie
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // --- Icône colorée à gauche ---
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.class_rounded,
                  color: AppColors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),

              // --- Informations principales ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom de la classe
                    Text(
                      classEntity.nomClasse,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Niveau
                    Text(
                      'Niveau : ${classEntity.niveau}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // --- Badge effectif + menu d'actions ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Badge vert avec le nombre d'élèves
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${classEntity.effectif} élèves',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Menu avec les actions Modifier / Supprimer
                  _buildPopupMenu(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Menu déroulant avec les options Modifier et Supprimer
  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert,
        color: AppColors.textSecondary,
        size: 20,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'edit') onEdit();
        if (value == 'delete') onDelete();
      },
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_rounded, size: 18, color: AppColors.blue),
              SizedBox(width: 10),
              Text('Modifier'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_rounded, size: 18, color: Colors.red),
              SizedBox(width: 10),
              Text('Supprimer', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}
