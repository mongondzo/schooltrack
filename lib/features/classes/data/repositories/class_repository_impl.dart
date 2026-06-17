// ============================================================
// FICHIER : data/repositories/class_repository_impl.dart
//
// RÔLE : C'est l'implémentation concrète du contrat défini dans
// domain/repositories/class_repository.dart.
//
// Ce fichier fait le pont entre :
//   - Le domain (qui parle d'entités : ClassEntity)
//   - La data source (qui parle de modèles : ClassModel + Firestore)
//
// Le BLoC utilisera ClassRepository (l'abstrait).
// Mais en coulisse, c'est ClassRepositoryImpl qui fait le travail.
// ============================================================

import '../../domain/entities/class_entity.dart';
import '../../domain/repositories/class_repository.dart';
import '../datasources/class_firestore_datasource.dart';
import '../models/class_model.dart';

class ClassRepositoryImpl implements ClassRepository {
  final ClassFirestoreDataSource _dataSource;

  ClassRepositoryImpl({ClassFirestoreDataSource? dataSource})
      : _dataSource = dataSource ?? ClassFirestoreDataSource();

  @override
  Future<List<ClassEntity>> getClasses() async {
    // La datasource retourne des ClassModel (sous-classe de ClassEntity)
    // Dart accepte de les traiter directement comme des ClassEntity.
    return await _dataSource.getClasses();
  }

  @override
  Future<ClassEntity?> getClassById(String id) async {
    return await _dataSource.getClassById(id);
  }

  @override
  Future<void> addClass(ClassEntity classEntity) async {
    // On convertit l'entité en modèle avant d'envoyer à Firestore
    final model = ClassModel.fromEntity(classEntity);
    await _dataSource.addClass(model);
  }

  @override
  Future<void> updateClass(ClassEntity classEntity) async {
    final model = ClassModel.fromEntity(classEntity);
    await _dataSource.updateClass(model);
  }

  @override
  Future<void> deleteClass(String id) async {
    await _dataSource.deleteClass(id);
  }
}
