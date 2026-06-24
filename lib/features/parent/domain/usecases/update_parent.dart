import 'package:schooltrack/features/parent/data/repositories/parent_repository_impl.dart';

import '../entities/parent.dart';

class UpdateParent {
  final ParentRepository repository;

  UpdateParent(this.repository);

  Future<void> call(Parent parent) async {
    return await repository.updateParent(parent);
  }
}
