// ════════════════════════════════════════════════════════════════
// REPOSITORY : ProfileRepositoryImpl
// Couche     : Data
// Rôle       : Implémente le contrat du domaine (ProfileRepository)
//              en déléguant au DataSource.
//              C'est le pont entre le domaine (abstrait) et Firebase.
//
//  Bloc → Repository (interface) → RepositoryImpl → DataSource → Firebase
// ════════════════════════════════════════════════════════════════

import 'package:schooltrack/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:schooltrack/features/profile/domain/entities/profile_entity.dart';
import 'package:schooltrack/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  // Le dataSource est injecté → plus facile à tester et à remplacer
  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProfileEntity> getProfile(String uid) async {
    // ProfileModel étend ProfileEntity → on peut le retourner directement
    return await remoteDataSource.getProfile(uid);
  }

  @override
  Future<void> updateProfile({
    required String uid,
    required String name,
    required String phone,
  }) async {
    await remoteDataSource.updateProfile(
      uid: uid,
      name: name,
      phone: phone,
    );
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }
}
