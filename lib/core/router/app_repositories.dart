//epository de la fonctionnaliter Dashboard
import 'package:schooltrack/features/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:schooltrack/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:schooltrack/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:schooltrack/features/classes/data/datasources/class_firestore_datasource.dart';
import 'package:schooltrack/features/classes/data/repositories/class_repository_impl.dart';
import 'package:schooltrack/features/dashboard/data/data/dashboard_remote_datasource.dart';
import 'package:schooltrack/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:schooltrack/features/dashboard/domain/usecases/get_dashboard_stats.dart';
import 'package:schooltrack/features/grades/data/datasources/grade_remote_datasource.dart';
import 'package:schooltrack/features/grades/data/repositories/grade_repository_impl.dart';
import 'package:schooltrack/features/grades/domain/repositories/grade_repository.dart';
import 'package:schooltrack/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:schooltrack/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:schooltrack/features/notifications/domain/repositories/notification_repository.dart';
import 'package:schooltrack/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:schooltrack/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:schooltrack/features/schedules/data/datasources/schedule_remote_datasource.dart';
import 'package:schooltrack/features/schedules/data/repositories/schedule_repository_impl.dart';
import 'package:schooltrack/features/schedules/domain/repositories/schedule_repository.dart';

final dashboardRemoteDatasource = DashboardRemoteDatasourceImpl();
final dashboardRepository = DashboardRepositoryImpl(
  remoteDatasource: dashboardRemoteDatasource,
);
final getDashboardStats = GetDashboardStats(dashboardRepository);

//epository de la fonctionnaliter class
final classRepository = ClassRepositoryImpl(
  dataSource: ClassFirestoreDataSource(),
);

//repository de la fonctionnaliter grades (notes)
final GradeRepository gradeRepository = GradeRepositoryImpl(
  GradeRemoteDataSource(),
);

//repository de la fonctionnaliter attendances(absences et presences)
/// Repository de la fonctionnalité Attendance (Présences), basé sur Firestore.
final AttendanceRepository attendanceRepository = AttendanceRepositoryImpl(
  AttendanceRemoteDataSource(),
);

// Repository de la fonctionnaliter schedule
final ScheduleRepository scheduleRepository = ScheduleRepositoryImpl(
  ScheduleRemoteDataSource(),
);

// Repository de la fonctionnalité Notifications, basé sur Firestore.
final NotificationRepository notificationRepository =
    NotificationRepositoryImpl(NotificationRemoteDataSource());

//repository de la fonctionnaliter profile
final profileRemoteDataSource = ProfileRemoteDataSourceImpl();
final profileRepository = ProfileRepositoryImpl(
  remoteDataSource: profileRemoteDataSource,
);
