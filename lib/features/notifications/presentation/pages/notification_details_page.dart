import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notification_bloc.dart';
import 'edit_notification_page.dart';

const _primaryColor = Color(0xFF2563EB);

/// -----------------------------------------------------------------------
/// NotificationDetailsPage
/// -----------------------------------------------------------------------
/// Page affichant tous les détails d'une notification.
/// -----------------------------------------------------------------------
class NotificationDetailsPage extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationDetailsPage({super.key, required this.notification});

  /// Formate une date en "jj/mm/aaaa" sans dépendance externe (intl).
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NotificationBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la notification'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Modifier',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: bloc,
                    child: EditNotificationPage(notification: notification),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: _primaryColor.withOpacity(0.1),
              child: const Icon(
                Icons.notifications_outlined,
                size: 40,
                color: _primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              notification.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          _InfoTile(label: 'Message', value: notification.message),
          _InfoTile(label: 'Destinataire', value: notification.targetRole.label),
          _InfoTile(
            label: 'Date de création',
            value: _formatDate(notification.createdAt),
          ),
        ],
      ),
    );
  }
}

/// Petit widget privé pour afficher une ligne "label : valeur".
class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
