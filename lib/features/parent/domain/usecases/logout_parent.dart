import 'package:schooltrack/features/parent/data/repositories/parent_repository_impl.dart';

class LogoutParent {
  final ParentRepository repository;

  LogoutParent(this.repository);

  Future<void> call() async {
    return await repository.logoutParent();
  }
}
