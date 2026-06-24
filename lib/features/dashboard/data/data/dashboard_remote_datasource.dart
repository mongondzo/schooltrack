import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schooltrack/features/dashboard/data/models/dashboard_stats_model.dart';

// Interface de la source de données dashboard
abstract class DashboardRemoteDatasource {
  Future<DashboardStatsModel> getDashboardStats();
}

// Implémentation avec Firestore
class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    // On récupère les statistiques en parallèle pour aller plus vite
    final results = await Future.wait([
      // Compte le nombre d'élèves dans la collection 'students'
      _firestore.collection('students').count().get(),

      // Compte le nombre de classes dans la collection 'classes'
      _firestore.collection('classes').count().get(),

      // Compte les présences d'aujourd'hui
      _firestore
          .collection('attendances')
          .where('date', isEqualTo: _getTodayString())
          .count()
          .get(),

      // Compte les notifications non lues
      _firestore
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .count()
          .get(),
    ]);

    // Extrait les compteurs de chaque résultat
    return DashboardStatsModel(
      totalStudents: results[0].count ?? 0,
      totalClasses: results[1].count ?? 0,
      totalAttendances: results[2].count ?? 0,
      totalNotifications: results[3].count ?? 0,
    );
  }

  // Retourne la date d'aujourd'hui au format 'yyyy-MM-dd'
  String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
