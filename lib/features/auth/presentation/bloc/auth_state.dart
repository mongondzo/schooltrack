import '../../domain/entities/auth_user.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthAuthenticatedState extends AuthState {
  final AuthUser user;

  AuthAuthenticatedState(this.user);
}

class AuthUnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState(this.message);
}

class AuthCheckConnectionState extends AuthState {}
