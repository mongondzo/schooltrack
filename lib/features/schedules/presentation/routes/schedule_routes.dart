// ============================================================
// FICHIER : presentation/routes/schedule_routes.dart
//
// RÔLE : Centralise les noms de routes et leur génération.
//
// UTILISATION dans MaterialApp :
//   onGenerateRoute: (settings) =>
//       ScheduleRoutes.generate(settings) ?? autresRoutes...,
//
// NAVIGATION depuis une page :
//   Navigator.pushNamed(context, ScheduleRoutes.list);
//   Navigator.pushNamed(context, ScheduleRoutes.details,
//       arguments: maScheduleEntity);
// ============================================================

import 'package:flutter/material.dart';
import '../../domain/entities/schedule_entity.dart';
import '../pages/add_schedule_page.dart';
import '../pages/edit_schedule_page.dart';
import '../pages/schedule_details_page.dart';
import '../pages/schedules_page.dart';

class ScheduleRoutes {
  static const String list    = '/schedules';
  static const String add     = '/schedules/add';
  static const String edit    = '/schedules/edit';
  static const String details = '/schedules/details';

  ScheduleRoutes._();

  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      case list:
        return MaterialPageRoute(builder: (_) => const SchedulesPage());

      case add:
        return MaterialPageRoute(
            builder: (_) => const AddSchedulePage());

      case edit:
        final s = settings.arguments as ScheduleEntity?;
        if (s == null) return _errorRoute('edit nécessite une ScheduleEntity.');
        return MaterialPageRoute(
            builder: (_) => EditSchedulePage(schedule: s));

      case details:
        final s = settings.arguments as ScheduleEntity?;
        if (s == null) return _errorRoute('details nécessite une ScheduleEntity.');
        return MaterialPageRoute(
            builder: (_) => ScheduleDetailsPage(schedule: s));

      default:
        return null;
    }
  }

  static MaterialPageRoute _errorRoute(String msg) =>
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('⚠️ Route error: $msg',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center),
          ),
        ),
      );
}
