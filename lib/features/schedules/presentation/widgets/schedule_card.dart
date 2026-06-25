// ============================================================
// FICHIER : presentation/widgets/schedule_card.dart
//
// RÔLE : Carte affichant un créneau d'emploi du temps.
// Affiche : matière, horaire, classe, salle, enseignant.
// Chaque matière a une couleur distincte pour mieux lire
// l'emploi du temps d'un seul coup d'œil.
// ============================================================

import 'package:flutter/material.dart';
import '../../domain/entities/schedule_entity.dart';
import 'app_colors.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleEntity schedule;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  // Couleur de l'accent selon la matière
  // On utilise le hashCode pour toujours avoir la même couleur
  // pour une même matière, sans liste exhaustive.
  Color _subjectColor(String subject) {
    final colors = [
      AppColors.blue,
      AppColors.green,
      AppColors.orange,
      AppColors.purple,
      const Color(0xFF06B6D4), // cyan
      const Color(0xFFEC4899), // rose
      const Color(0xFF14B8A6), // teal
    ];
    return colors[subject.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final color = _subjectColor(schedule.subject);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Row(
          children: [
            // Barre de couleur latérale gauche
            Container(
              width: 5,
              height: 72,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Heure encadrée
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  schedule.startTime,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 12,
                  color: AppColors.border,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                ),
                Text(
                  schedule.endTime,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),

            // Séparateur vertical
            Container(width: 1, height: 40, color: AppColors.border),
            const SizedBox(width: 14),

            // Informations principales
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Matière
                  Text(
                    schedule.subject,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  // Classe et salle
                  Row(
                    children: [
                      const Icon(Icons.class_rounded,
                          size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        schedule.className,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (schedule.room.isNotEmpty) ...[
                        const SizedBox(width: 10),
                        const Icon(Icons.meeting_room_rounded,
                            size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          schedule.room,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Enseignant
                  Row(
                    children: [
                      const Icon(Icons.person_rounded,
                          size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          schedule.teacher,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Menu d'actions
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert,
                  color: AppColors.textSecondary, size: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onSelected: (v) {
                if (v == 'details') onTap();
                if (v == 'edit') onEdit();
                if (v == 'delete') onDelete();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'details',
                  child: Row(children: [
                    Icon(Icons.visibility_rounded,
                        size: 18, color: AppColors.blue),
                    SizedBox(width: 10),
                    Text('Voir détails'),
                  ]),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(children: [
                    Icon(Icons.edit_rounded,
                        size: 18, color: AppColors.green),
                    SizedBox(width: 10),
                    Text('Modifier'),
                  ]),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    Icon(Icons.delete_rounded,
                        size: 18, color: AppColors.red),
                    SizedBox(width: 10),
                    Text('Supprimer',
                        style: TextStyle(color: AppColors.red)),
                  ]),
                ),
              ],
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
