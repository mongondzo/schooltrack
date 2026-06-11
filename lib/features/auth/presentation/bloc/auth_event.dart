// AuthInitialEvent, AuthLoginEvent, AuthSignUpEvent, AuthSignInWithGoogleEvent et autres événements liés à l'authentification

abstract class AuthEvent {}

class AuthInitialEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent({required this.email, required this.password});
}

class AuthSignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  AuthSignUpEvent({
    required this.email,
    required this.password,
    required this.name,
  });
}

class AuthSignInWithGoogleEvent extends AuthEvent {}

class AuthSignOutEvent extends AuthEvent {}

class AuthCheckConnectionEvent extends AuthEvent {}
