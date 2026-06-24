//epository de la fonctionnaliter Dashboard
import 'package:schooltrack/features/classes/data/datasources/class_firestore_datasource.dart';
import 'package:schooltrack/features/classes/data/repositories/class_repository_impl.dart';
import 'package:schooltrack/features/dashboard/data/data/dashboard_remote_datasource.dart';
import 'package:schooltrack/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:schooltrack/features/dashboard/domain/usecases/get_dashboard_stats.dart';

final dashboardRemoteDatasource = DashboardRemoteDatasourceImpl();
final dashboardRepository = DashboardRepositoryImpl(
  remoteDatasource: dashboardRemoteDatasource,
);
final getDashboardStats = GetDashboardStats(dashboardRepository);

//epository de la fonctionnaliter class
final classRepository = ClassRepositoryImpl(
  dataSource: ClassFirestoreDataSource(),
);
