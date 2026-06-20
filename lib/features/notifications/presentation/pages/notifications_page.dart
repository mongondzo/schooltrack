import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../widgets/notification_card.dart';
import '../widgets/empty_notifications_widget.dart';
import 'add_notification_page.dart';
import 'edit_notification_page.dart';
import 'notification_details_page.dart';

const _primaryColor = Color(0xFF2563EB);

class NotificationsPage extends StatelessWidget {
  final NotificationRepository repository;

  const NotificationsPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationBloc(repository)..add(LoadNotifications()),
      child: const _NotificationsView(),
    );
  }
}

/// Vue interne : sépare la logique d'affichage de la création du bloc.
class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  void _goToAddPage(BuildContext context) {
    final bloc = context.read<NotificationBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BlocProvider.value(value: bloc, child: const AddNotificationPage()),
      ),
    );
  }

  void _goToEditPage(BuildContext context, NotificationEntity notification) {
    final bloc = context.read<NotificationBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: EditNotificationPage(notification: notification),
        ),
      ),
    );
  }

  void _goToDetailsPage(BuildContext context, NotificationEntity notification) {
    final bloc = context.read<NotificationBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: NotificationDetailsPage(notification: notification),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, NotificationEntity notification) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer la notification'),
        content: Text(
          'Voulez-vous vraiment supprimer "${notification.title}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              context.read<NotificationBloc>().add(
                DeleteNotification(notification.id),
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryColor,
        onPressed: () => _goToAddPage(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(
              child: CircularProgressIndicator(color: _primaryColor),
            );
          }

          if (state is NotificationError) {
            return Center(child: Text(state.message));
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const EmptyNotificationsWidget();
            }

            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () => _goToDetailsPage(context, notification),
                  onEdit: () => _goToEditPage(context, notification),
                  onDelete: () => _confirmDelete(context, notification),
                );
              },
            );
          }

          // Cas de NotificationInitial : rien à afficher pour l'instant.
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
