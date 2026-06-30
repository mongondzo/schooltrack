import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooltrack/core/router/app_repositories.dart';
import '../bloc/notification_bloc.dart';
import '../pages/add_notification_page.dart';
import '../pages/notifications_page.dart';

/// Petites fonctions prêtes à l'emploi pour naviguer vers les pages de la
/// fonctionnalité Notifications depuis N'IMPORTE QUELLE page de l'app
/// (Dashboard, menu, bottom nav...), sans avoir à répéter le code de
/// création du NotificationBloc à chaque fois.
///
/// Exemple d'utilisation dans ton DashboardPage :
///   onTap: () => openNotificationsPage(context),
/// -----------------------------------------------------------------------

/// Ouvre la liste complète des notifications (NotificationsPage).
/// À utiliser pour la carte "Notifications" du Dashboard.
void openNotificationsPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => NotificationsPage(repository: notificationRepository),
    ),
  );
}

/// Ouvre directement le formulaire de création d'une notification.
/// À utiliser pour une action rapide "Nouvelle notification" du Dashboard.
void openAddNotificationPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => NotificationBloc(notificationRepository),
        child: const AddNotificationPage(),
      ),
    ),
  );
}
