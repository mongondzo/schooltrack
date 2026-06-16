// Entité représentant les statistiques du dashboard
class DashboardStatsEntity {
  final int totalStudents;      // Nombre total d'élèves
  final int totalClasses;       // Nombre total de classes
  final int totalAttendances;   // Nombre de présences du jour
  final int totalNotifications; // Nombre de notifications non lues

  const DashboardStatsEntity({
    required this.totalStudents,
    required this.totalClasses,
    required this.totalAttendances,
    required this.totalNotifications,
  });
}
