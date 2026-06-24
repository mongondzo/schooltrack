import 'package:schooltrack/features/parent/data/repositories/parent_repository_impl.dart';
import 'package:schooltrack/features/parent/domain/entities/parent.dart';

class ParentRepositoryImpl implements ParentRepository {
  final ParentRemoteDatasourceImpl datasource;

  ParentRepositoryImpl(this.datasource);

  @override
  Future<List<Parent>> getAllParents() {
    return datasource.getAllParents();
  }

  @override
  Future<void> addParent(Parent parent) {
    return datasource.addParent(parent);
  }

  @override
  Future<void> deleteParent(String id) {
    return datasource.deleteParent(id);
  }

  @override
  Future<Parent?> getParentById(String id) {
    return datasource.getParentById(id);
  }

  @override
  Future<Parent?> loginParent(String email, String password) {
    return datasource.loginParent(email, password);
  }

  @override
  Future<void> logoutParent() {
    return datasource.logoutParent();
  }

  @override
  Future<void> updateParent(Parent parent) {
    return datasource.updateParent(parent);
  }
}
