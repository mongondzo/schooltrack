import 'package:schooltrack/features/parent/data/repositories/parent_repository_impl.dart';

import '../entities/parent.dart';

class GetParentById {
  final ParentRepository repository;

  GetParentById(this.repository);

  Future<Parent?> call(String id) async {
    return await repository.getParentById(id);
  }
}
