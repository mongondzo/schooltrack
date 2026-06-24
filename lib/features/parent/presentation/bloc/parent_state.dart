import '../../domain/entities/parent.dart';

abstract class ParentState {}

class ParentInitial extends ParentState {}

class ParentLoading extends ParentState {}

class ParentsLoaded extends ParentState {
  final List<Parent> parents;
  ParentsLoaded(this.parents);
}

class ParentLoaded extends ParentState {
  final Parent parent;
  ParentLoaded(this.parent);
}

class ParentLoggedIn extends ParentState {
  final Parent parent;
  ParentLoggedIn(this.parent);
}

class ParentLoggedOut extends ParentState {}

class ParentError extends ParentState {
  final String message;
  ParentError(this.message);
}
