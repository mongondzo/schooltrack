import '../../domain/entities/parent.dart';

abstract class ParentEvent {}

class LoadParents extends ParentEvent {}

class AddParentEvent extends ParentEvent {
  final Parent parent;
  AddParentEvent(this.parent);
}

class UpdateParentEvent extends ParentEvent {
  final Parent parent;
  UpdateParentEvent(this.parent);
}

class DeleteParentEvent extends ParentEvent {
  final String id;
  DeleteParentEvent(this.id);
}

class LoginParentEvent extends ParentEvent {
  final String email;
  final String password;

  LoginParentEvent(this.email, this.password);
}

class LogoutParentEvent extends ParentEvent {}

class GetParentByIdEvent extends ParentEvent {
  final String id;
  GetParentByIdEvent(this.id);
}
