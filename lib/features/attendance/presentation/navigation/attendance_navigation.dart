import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooltrack/core/router/app_repositories.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../pages/add_attendance_page.dart';
import '../pages/attendance_page.dart';

/// Petites fonctions prêtes à l'emploi pour naviguer vers les pages de la
/// fonctionnalité Attendance depuis N'IMPORTE QUELLE page de l'app
/// (Dashboard, menu, bottom nav...), sans avoir à répéter le code de
/// création de l'AttendanceBloc à chaque fois.
///
/// Exemple d'utilisation dans ton DashboardPage :
///   onTap: () => openAttendancePage(context),
/// Ouvre la liste complète des présences (AttendancePage).
/// À utiliser pour la carte "Présences" du Dashboard.
void openAttendancePage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AttendancePage(repository: attendanceRepository),
    ),
  );
}

/// Ouvre directement le formulaire d'ajout d'une présence.
/// À utiliser pour une action rapide "Nouvelle présence" du Dashboard.
void openAddAttendancePage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) =>
            AttendanceBloc(attendanceRepository)..add(LoadAttendance()),
        child: const AddAttendancePage(),
      ),
    ),
  );
}
