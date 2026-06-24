import 'package:schooltrack/features/parent/domain/entities/parent.dart';

abstract class ParentRepository {
  // 🔹 ADMIN : gestion des parents
  Future<List<Parent>> getAllParents();
  Future<Parent?> getParentById(String id);
  Future<void> addParent(Parent parent);
  Future<void> updateParent(Parent parent);
  Future<void> deleteParent(String id);

  // 🔹 PARENT SIMPLE : connexion
  Future<Parent?> loginParent(String email, String password);
  Future<void> logoutParent();
}
