import 'package:schooltrack/features/parent/data/repositories/parent_repository_impl.dart';

class DeleteParent {
  final ParentRepository repository;

  DeleteParent(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteParent(id);
  }
}
