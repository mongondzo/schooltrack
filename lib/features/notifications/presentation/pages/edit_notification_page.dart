import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../widgets/notification_form.dart';

const _primaryColor = Color(0xFF2563EB);

/// -----------------------------------------------------------------------
/// EditNotificationPage
/// -----------------------------------------------------------------------
/// Page permettant de modifier une notification existante.
///
/// Les champs du formulaire sont pré-remplis avec les valeurs actuelles
/// de [notification], grâce aux paramètres `initial...` de
/// NotificationForm.
/// -----------------------------------------------------------------------
class EditNotificationPage extends StatelessWidget {
  final NotificationEntity notification;

  const EditNotificationPage({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier la notification'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: NotificationForm(
          initialTitle: notification.title,
          initialMessage: notification.message,
          initialTargetRole: notification.targetRole,
          submitButtonLabel: 'Enregistrer les modifications',
          onSubmit: ({
            required title,
            required message,
            required targetRole,
          }) {
            // On conserve l'id et la date de création d'origine ; seuls
            // les autres champs sont mis à jour.
            final updatedNotification = NotificationEntity(
              id: notification.id,
              title: title,
              message: message,
              targetRole: targetRole,
              createdAt: notification.createdAt,
            );

            context
                .read<NotificationBloc>()
                .add(UpdateNotification(updatedNotification));
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
