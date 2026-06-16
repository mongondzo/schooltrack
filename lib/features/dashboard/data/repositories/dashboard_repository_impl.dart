import 'package:schooltrack/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:schooltrack/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:schooltrack/features/dashboard/domain/repositories/dashboard_repository.dart';

// Implémentation du dépôt dashboard
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource remoteDatasource;

  DashboardRepositoryImpl({required this.remoteDatasource});

  @override
  Future<DashboardStatsEntity> getDashboardStats() async {
    return await remoteDatasource.getDashboardStats();
  }
}
