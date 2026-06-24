import 'package:schooltrack/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:schooltrack/features/dashboard/domain/repositories/dashboard_repository.dart';

// Use Case : Récupérer les statistiques du dashboard
class GetDashboardStats {
  final DashboardRepository repository;

  GetDashboardStats(this.repository);

  Future<DashboardStatsEntity> call() async {
    return await repository.getDashboardStats();
  }
}
