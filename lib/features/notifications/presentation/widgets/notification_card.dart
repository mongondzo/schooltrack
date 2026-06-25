import 'package:flutter/material.dart';
import '../../domain/entities/notification_entity.dart';

const _primaryColor = Color(0xFF2563EB);

/// -----------------------------------------------------------------------
/// NotificationCard
/// -----------------------------------------------------------------------
/// Carte affichant le résumé d'une notification dans la liste
/// (NotificationsPage) : titre, message (tronqué), destinataire et date.
/// -----------------------------------------------------------------------
class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

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
          backgroundColor: _primaryColor.withOpacity(0.1),
          child: const Icon(Icons.notifications_outlined, color: _primaryColor),
        ),
        title: Text(
          notification.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${notification.message}\n${_formatDate(notification.createdAt)}  •  ${notification.targetRole.label}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: true,
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
