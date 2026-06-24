import 'package:schooltrack/features/parent/data/repositories/parent_repository_impl.dart';

import '../../domain/entities/parent.dart';

abstract class ParentRemoteDatasourceImpl implements ParentRepository {
  final List<Parent> _parents = [
    Parent(
      id: "1",
      firstName: "Jean",
      lastName: "Mavoungou",
      email: "jean@gmail.com",
      phone: "061234567",
      childrenIds: ["S1"],
    ),
    Parent(
      id: "2",
      firstName: "Marie",
      lastName: "Ngoma",
      email: "marie@gmail.com",
      phone: "069876543",
      childrenIds: ["S2"],
    ),
  ];

  @override
  Future<List<Parent>> getAllParents() async {
    return _parents;
  }

  @override
  Future<void> addParent(Parent parent) async {
    _parents.add(parent);
  }

  @override
  Future<void> updateParent(Parent parent) async {
    final index = _parents.indexWhere((p) => p.id == parent.id);
    if (index != -1) {
      _parents[index] = parent;
    }
  }

  @override
  Future<void> deleteParent(String id) async {
    _parents.removeWhere((p) => p.id == id);
  }

  @override
  Future<Parent?> getParentById(String id) async {
    try {
      return _parents.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Parent?> loginParent(String email, String password) async {
    try {
      return _parents.firstWhere((p) => p.email == email);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> logoutParent() async {
    // mock → rien à faire
  }
}
