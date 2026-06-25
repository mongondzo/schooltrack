import 'package:flutter/material.dart';
import '../../domain/entities/grade_entity.dart';

const _primaryColor = Color(0xFF2563EB);

/// -----------------------------------------------------------------------
/// GradeCard
/// -----------------------------------------------------------------------
/// Carte affichant le résumé d'une note dans la liste (GradesPage) :
/// nom de l'élève, matière, note, classe, + boutons modifier/supprimer.
/// -----------------------------------------------------------------------
class GradeCard extends StatelessWidget {
  final GradeEntity grade;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GradeCard({
    super.key,
    required this.grade,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  /// Couleur de la note : vert si >= 10, rouge sinon (simple repère visuel).
  Color get _noteColor => grade.note >= 10 ? Colors.green : Colors.red;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _noteColor.withOpacity(0.1),
          child: Text(
            grade.note.toStringAsFixed(1),
            style: TextStyle(
              color: _noteColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        title: Text(
          grade.studentName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${grade.matiere}  •  Classe ${grade.classe}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: _primaryColor),
              tooltip: 'Modifier',
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: 'Supprimer',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
