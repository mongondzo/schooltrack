import 'package:schooltrack/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:schooltrack/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:schooltrack/features/grades/data/datasources/grade_remote_datasource.dart';
import 'package:schooltrack/features/grades/data/repositories/grade_repository_impl.dart';
import 'package:schooltrack/features/grades/domain/repositories/grade_repository.dart';
import 'package:schooltrack/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:schooltrack/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:schooltrack/features/notifications/domain/repositories/notification_repository.dart';
import 'package:schooltrack/features/schedules/data/datasources/schedule_remote_datasource.dart';
import 'package:schooltrack/features/schedules/data/repositories/schedule_repository_impl.dart';
import 'package:schooltrack/features/schedules/domain/repositories/schedule_repository.dart';

import '../../features/attendance/data/datasources/attendance_remote_datasource.dart';

// Repository de la fonctionnalité Grades (Notes), basé sur Firestore.
final GradeRepository gradeRepository = GradeRepositoryImpl(
  GradeRemoteDataSource(),
);

/// Repository de la fonctionnalité Attendance (Présences), basé sur Firestore.
final AttendanceRepository attendanceRepository = AttendanceRepositoryImpl(
  AttendanceRemoteDataSource(),
);

// Repository de la fonctionnalité Notifications, basé sur Firestore.
final NotificationRepository notificationRepository =
    NotificationRepositoryImpl(NotificationRemoteDataSource());

// Repository de la fonctionnaliter schedule
final ScheduleRepository scheduleRepository = ScheduleRepositoryImpl(
  ScheduleRemoteDataSource(),
);

// 👉 Ajoute ici tes autres repositories au fur et à mesure :
// final ClassRepository classRepository = ClassRepositoryImpl(ClassRemoteDataSource());
// final StudentRepository studentRepository = StudentRepositoryImpl(StudentRemoteDataSource());
