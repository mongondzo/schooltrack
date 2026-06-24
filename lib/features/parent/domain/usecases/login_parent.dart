import 'package:schooltrack/features/parent/data/repositories/parent_repository_impl.dart';

import '../entities/parent.dart';

class LoginParent {
  final ParentRepository repository;

  LoginParent(this.repository);

  Future<Parent?> call({
    required String email,
    required String password,
  }) async {
    return await repository.loginParent(email, password);
  }
}
