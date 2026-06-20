import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_datasource.dart';
import '../models/attendance_model.dart';

/// -----------------------------------------------------------------------
/// AttendanceRepositoryImpl
/// -----------------------------------------------------------------------
/// Implémentation concrète de AttendanceRepository (l'interface du Domain).
///
/// Son rôle : faire le pont entre le Domain (qui ne connaît que des
/// AttendanceEntity) et la Data (qui parle Firestore via
/// AttendanceRemoteDataSource).
/// -----------------------------------------------------------------------
class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;

  AttendanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<AttendanceEntity>> getAttendance() async {
    // AttendanceModel hérite de AttendanceEntity : on peut donc renvoyer
    // directement la liste de modèles, elle respecte le contrat.
    return await remoteDataSource.getAttendance();
  }

  @override
  Future<void> addAttendance(AttendanceEntity attendance) async {
    final model = AttendanceModel.fromEntity(attendance);
    await remoteDataSource.addAttendance(model);
  }

  @override
  Future<void> updateAttendance(AttendanceEntity attendance) async {
    final model = AttendanceModel.fromEntity(attendance);
    await remoteDataSource.updateAttendance(model);
  }

  @override
  Future<void> deleteAttendance(String id) async {
    await remoteDataSource.deleteAttendance(id);
  }
}
