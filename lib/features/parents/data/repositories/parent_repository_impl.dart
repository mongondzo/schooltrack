// ════════════════════════════════════════════════════════════════
// REPOSITORY : ParentRepositoryImpl (parent_repository_impl.dart)
// Couche     : Data
// Rôle       : Implémente le contrat ParentRepository (domain)
//              en déléguant au DataSource. Convertit les
//              ParentEntity en ParentModel avant l'envoi à Firestore.
//              Aucune gestion d'erreur complexe : les exceptions
//              remontent simplement telles quelles vers le Bloc.
//
//   Bloc → ParentRepository (interface)
//        → ParentRepositoryImpl → DataSource → Firestore
// ════════════════════════════════════════════════════════════════

import 'package:schooltrack/features/parents/data/datasources/parent_remote_datasource.dart';
import 'package:schooltrack/features/parents/data/models/parent_model.dart';
import 'package:schooltrack/features/parents/domain/entities/parent_entity.dart';
import 'package:schooltrack/features/parents/domain/repositories/parent_repository.dart';

class ParentRepositoryImpl implements ParentRepository {
  final ParentRemoteDataSource remoteDataSource;

  ParentRepositoryImpl(
    ParentRemoteDataSource parentRemoteDataSource, {
    required this.remoteDataSource,
  });

  @override
  Future<List<ParentEntity>> getParents() async {
    // ParentModel étend ParentEntity → retour direct sans conversion
    return await remoteDataSource.getParents();
  }

  @override
  Future<void> addParent(ParentEntity parent) async {
    // On convertit l'entité (domaine) en modèle (data) pour Firestore
    final model = ParentModel(
      id: parent.id,
      name: parent.name,
      email: parent.email,
      phone: parent.phone,
      address: parent.address,
      childrenIds: parent.childrenIds,
      createdAt: parent.createdAt,
    );
    await remoteDataSource.addParent(model);
  }

  @override
  Future<void> updateParent(ParentEntity parent) async {
    final model = ParentModel(
      id: parent.id,
      name: parent.name,
      email: parent.email,
      phone: parent.phone,
      address: parent.address,
      childrenIds: parent.childrenIds,
      createdAt: parent.createdAt,
    );
    await remoteDataSource.updateParent(model);
  }

  @override
  Future<void> deleteParent(String id) async {
    await remoteDataSource.deleteParent(id);
  }
}
