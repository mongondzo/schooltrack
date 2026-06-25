import 'package:flutter/material.dart';
import '../../domain/entities/attendance_entity.dart';

/// -----------------------------------------------------------------------
/// AttendanceCard
/// -----------------------------------------------------------------------
/// Carte affichant le résumé d'une présence dans la liste (AttendancePage) :
/// nom de l'élève, classe, statut (couleur + icône) et date.
///
/// Le bouton "⋮" ouvre un menu regroupant toutes les actions possibles :
/// marquer présent / absent / retard, modifier, supprimer.
/// -----------------------------------------------------------------------
class AttendanceCard extends StatelessWidget {
  final AttendanceEntity attendance;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final void Function(AttendanceStatus newStatus) onMarkStatus;

  const AttendanceCard({
    super.key,
    required this.attendance,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onMarkStatus,
  });

  /// Couleur associée au statut actuel (repère visuel rapide).
  Color get _statusColor {
    switch (attendance.status) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.absent:
        return Colors.red;
      case AttendanceStatus.lateStatus:
        return Colors.orange;
    }
  }

  /// Icône associée au statut actuel.
  IconData get _statusIcon {
    switch (attendance.status) {
      case AttendanceStatus.present:
        return Icons.check_circle;
      case AttendanceStatus.absent:
        return Icons.cancel;
      case AttendanceStatus.lateStatus:
        return Icons.watch_later;
    }
  }

  /// Formate une date en "jj/mm/aaaa" sans dépendance externe (intl).
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

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
          backgroundColor: _statusColor.withOpacity(0.1),
          child: Icon(_statusIcon, color: _statusColor),
        ),
        title: Text(
          attendance.studentName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${attendance.classe}  •  ${_formatDate(attendance.date)}  •  ${attendance.status.label}',
        ),
        trailing: PopupMenuButton<String>(
          tooltip: 'Actions',
          onSelected: (value) {
            switch (value) {
              case 'present':
                onMarkStatus(AttendanceStatus.present);
                break;
              case 'absent':
                onMarkStatus(AttendanceStatus.absent);
                break;
              case 'late':
                onMarkStatus(AttendanceStatus.lateStatus);
                break;
              case 'edit':
                onEdit();
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'present',
              child: ListTile(
                leading: Icon(Icons.check_circle_outline, color: Colors.green),
                title: Text('Marquer présent'),
              ),
            ),
            PopupMenuItem(
              value: 'absent',
              child: ListTile(
                leading: Icon(Icons.cancel_outlined, color: Colors.red),
                title: Text('Marquer absent'),
              ),
            ),
            PopupMenuItem(
              value: 'late',
              child: ListTile(
                leading: Icon(Icons.watch_later_outlined, color: Colors.orange),
                title: Text('Marquer retard'),
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit_outlined),
                title: Text('Modifier'),
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.red),
                title: Text('Supprimer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
