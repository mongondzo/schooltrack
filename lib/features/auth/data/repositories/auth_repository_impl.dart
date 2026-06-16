import 'package:schooltrack/features/auth/data/data/auth_remote_datasource.dart';
import 'package:schooltrack/features/auth/domain/entities/user_entity.dart';
import 'package:schooltrack/features/auth/domain/repositories/auth_repository.dart';

// Implémentation du repository d'authentification
// Fait le lien entre le domaine et la source de données
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  Future<UserEntity> signInWithGoogle() async {
    // Délègue au datasource et retourne l'entité
    return await remoteDatasource.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    return await remoteDatasource.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await remoteDatasource.getCurrentUser();
  }
}
