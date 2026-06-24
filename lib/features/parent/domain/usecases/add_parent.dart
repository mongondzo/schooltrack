import 'package:schooltrack/features/parent/data/repositories/parent_repository_impl.dart';

import '../entities/parent.dart';

class AddParent {
  final ParentRepository repository;

  AddParent(this.repository);

  Future<void> call(Parent parent) async {
    return await repository.addParent(parent);
  }
}
