// ============================================================
// FICHIER : data/repositories/schedule_repository_impl.dart
//
// RÔLE : Implémentation concrète du contrat ScheduleRepository.
//
// Fait le pont entre :
//   ● Le domain  → parle en ScheduleEntity (objets purs)
//   ● La data    → parle en ScheduleModel  (+ Firestore)
//
// Le BLoC appelle ScheduleRepository (interface abstraite).
// En coulisse, Flutter utilise cette classe concrète.
// ============================================================

import '../../domain/entities/schedule_entity.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../datasources/schedule_remote_datasource.dart';
import '../models/schedule_model.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource _dataSource;

  ScheduleRepositoryImpl(
    ScheduleRemoteDataSource scheduleRemoteDataSource, {
    ScheduleRemoteDataSource? dataSource,
  }) : _dataSource = dataSource ?? ScheduleRemoteDataSource();

  @override
  Future<List<ScheduleEntity>> getSchedules() async {
    // ScheduleModel hérite de ScheduleEntity →
    // Dart les accepte comme List<ScheduleEntity> directement
    return await _dataSource.getSchedules();
  }

  @override
  Future<void> addSchedule(ScheduleEntity schedule) async {
    // On convertit l'entité pure en modèle avant d'envoyer à Firestore
    final model = ScheduleModel.fromEntity(schedule);
    await _dataSource.addSchedule(model);
  }

  @override
  Future<void> updateSchedule(ScheduleEntity schedule) async {
    final model = ScheduleModel.fromEntity(schedule);
    await _dataSource.updateSchedule(model);
  }

  @override
  Future<void> deleteSchedule(String id) async {
    await _dataSource.deleteSchedule(id);
  }
}
