import '../../domain/entities/grade_entity.dart';
import '../../domain/repositories/grade_repository.dart';
import '../datasources/grade_remote_datasource.dart';
import '../models/grade_model.dart';

/// -----------------------------------------------------------------------
/// GradeRepositoryImpl
/// -----------------------------------------------------------------------
/// Implémentation concrète de GradeRepository (l'interface du Domain).
///
/// Son rôle : faire le pont entre le Domain (qui ne connaît que des
/// GradeEntity) et la Data (qui parle Firestore via GradeRemoteDataSource).
/// -----------------------------------------------------------------------
class GradeRepositoryImpl implements GradeRepository {
  final GradeRemoteDataSource remoteDataSource;

  GradeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<GradeEntity>> getGrades() async {
    // GradeModel hérite de GradeEntity : on peut donc renvoyer
    // directement la liste de modèles, elle respecte le contrat.
    return await remoteDataSource.getGrades();
  }

  @override
  Future<void> addGrade(GradeEntity grade) async {
    final model = GradeModel.fromEntity(grade);
    await remoteDataSource.addGrade(model);
  }

  @override
  Future<void> updateGrade(GradeEntity grade) async {
    final model = GradeModel.fromEntity(grade);
    await remoteDataSource.updateGrade(model);
  }

  @override
  Future<void> deleteGrade(String id) async {
    await remoteDataSource.deleteGrade(id);
  }
}
