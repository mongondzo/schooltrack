import 'package:schooltrack/features/dashboard/domain/entities/dashboard_stats_entity.dart';

// Modèle des statistiques dashboard - couche data
class DashboardStatsModel extends DashboardStatsEntity {
  const DashboardStatsModel({
    required super.totalStudents,
    required super.totalClasses,
    required super.totalAttendances,
    required super.totalNotifications,
  });

  // Crée depuis un Map (résultat de plusieurs requêtes Firestore agrégées)
  factory DashboardStatsModel.fromMap(Map<String, dynamic> map) {
    return DashboardStatsModel(
      totalStudents: map['totalStudents'] as int? ?? 0,
      totalClasses: map['totalClasses'] as int? ?? 0,
      totalAttendances: map['totalAttendances'] as int? ?? 0,
      totalNotifications: map['totalNotifications'] as int? ?? 0,
    );
  }
}
