import 'package:schooltrack/features/auth/domain/entities/user_entity.dart';

abstract class AuthState {}

// Les States représentent l'état courant de l'authentification

// État initial : on ne sait pas encore si l'utilisateur est connecté
class AuthInitial extends AuthState {}

// État : vérification en cours (pendant le chargement)
class AuthLoading extends AuthState {}

// État : l'utilisateur est connecté
class AuthAuthenticated extends AuthState {
  final UserEntity user; // L'utilisateur connecté

  AuthAuthenticated(this.user);
}

// État : l'utilisateur n'est PAS connecté
class AuthUnauthenticated extends AuthState {}

// État : une erreur s'est produite
class AuthError extends AuthState {
  final String message; // Message d'erreur à afficher

  AuthError(this.message);
}
