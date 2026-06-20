import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../widgets/notification_form.dart';

const _primaryColor = Color(0xFF2563EB);

/// -----------------------------------------------------------------------
/// AddNotificationPage
/// -----------------------------------------------------------------------
/// Page permettant de créer une nouvelle notification.
///
/// Réutilise le widget NotificationForm, puis envoie un événement
/// AddNotification au NotificationBloc déjà fourni par la page parente
/// (NotificationsPage).
/// -----------------------------------------------------------------------
class AddNotificationPage extends StatelessWidget {
  const AddNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle notification'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: NotificationForm(
          submitButtonLabel: 'Envoyer',
          onSubmit: ({
            required title,
            required message,
            required targetRole,
          }) {
            final newNotification = NotificationEntity(
              id: '',
              title: title,
              message: message,
              targetRole: targetRole,
              createdAt: DateTime.now(),
            );

            context.read<NotificationBloc>().add(AddNotification(newNotification));
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
