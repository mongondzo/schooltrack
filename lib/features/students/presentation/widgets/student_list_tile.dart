// WIDGET : Carte d'un élève dans la liste
// Représente une ligne dans la liste des élèves.
// Affiche l'avatar, le nom, la classe, et les boutons d'action.
// On sépare ce widget de la page pour garder le code lisible.

import 'package:flutter/material.dart';
import '../../domain/entities/student.dart';
import 'student_avatar.dart';

class StudentListTile extends StatelessWidget {
  final Student student;
  final VoidCallback onTap; // Ouvre la page de détails
  final VoidCallback onEdit; // Ouvre la page de modification
  final VoidCallback onDelete; // Déclenche la suppression

  const StudentListTile({
    super.key,
    required this.student,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Material 3 : carte avec coins arrondis et légère élévation
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar avec initiales colorées
              StudentAvatar(student: student),
              const SizedBox(width: 12),

              // Nom et classe (prend tout l'espace disponible)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.nomComplet,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        // Chip de classe avec couleur bleue légère
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            student.classe,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Boutons d'action (modifier + supprimer)
              _ActionButtons(onEdit: onEdit, onDelete: onDelete),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget privé pour les boutons d'action (encapsulation)
class _ActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ActionButtons({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bouton modifier
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          color: const Color(0xFF2563EB),
          iconSize: 20,
          tooltip: 'Modifier',
          onPressed: onEdit,
        ),
        // Bouton supprimer
        IconButton(
          icon: const Icon(Icons.delete_outline),
          color: const Color(0xFFEF4444),
          iconSize: 20,
          tooltip: 'Supprimer',
          onPressed: onDelete,
        ),
      ],
    );
  }
}
