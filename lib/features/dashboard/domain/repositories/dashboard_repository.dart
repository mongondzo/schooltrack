import 'package:schooltrack/features/dashboard/domain/entities/dashboard_stats_entity.dart';

// Interface du dépôt dashboard
abstract class DashboardRepository {
  Future<DashboardStatsEntity> getDashboardStats();
}
