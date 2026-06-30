import 'package:flutter/material.dart';
import 'package:schooltrack/core/router/app_repositories.dart';

const _primaryColor = Color(0xFF2563EB);

/// -----------------------------------------------------------------------
/// NotificationsCountCard
/// -----------------------------------------------------------------------
/// Carte à placer sur le Dashboard, qui affiche le nombre total de
/// notifications envoyées.
///
/// Au chargement, elle récupère toutes les notifications via
/// `notificationRepository` et affiche simplement leur nombre.
/// -----------------------------------------------------------------------
class NotificationsCountCard extends StatefulWidget {
  /// Action déclenchée quand on appuie sur la carte (ex: ouvrir NotificationsPage).
  final VoidCallback? onTap;

  const NotificationsCountCard({super.key, this.onTap});

  @override
  State<NotificationsCountCard> createState() => _NotificationsCountCardState();
}

class _NotificationsCountCardState extends State<NotificationsCountCard> {
  int? _count;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadCount();
  }

  Future<void> _loadCount() async {
    try {
      final notifications = await notificationRepository.getNotifications();
      setState(() => _count = notifications.length);
    } catch (_) {
      setState(() => _hasError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: Colors.white70,
                  size: 18,
                ),
                SizedBox(width: 6),
                Text('Notifications', style: TextStyle(color: Colors.white70)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _hasError ? '--' : (_count == null ? '...' : '$_count'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Notifications envoyées',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
