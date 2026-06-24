import 'package:schooltrack/features/parent/data/repositories/parent_repository_impl.dart';

import '../entities/parent.dart';

class GetAllParents {
  final ParentRepository repository;

  GetAllParents(this.repository);

  Future<List<Parent>> call() {
    return repository.getAllParents();
  }
}
