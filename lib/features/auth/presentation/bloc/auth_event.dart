// ===========================================================
// FICHIER : auth_event.dart
// CHEMIN  : features/auth/presentation/bloc/auth_event.dart
//
// RÔLE : Définit toutes les "actions" que l'UI peut envoyer
// au BLoC. Chaque action utilisateur = un Event.
//
// Ce fichier fait partie du "barrel" auth_bloc.dart
// grâce à "part of".
// ===========================================================

part of 'auth_bloc.dart';

// Classe de base pour tous les events (abstraite = ne peut
// pas être instanciée directement)
abstract class AuthEvent {
  const AuthEvent();
}

// ──────────────────────────────────────────────────────────
// CheckAuthStatus
//
// Envoyé au démarrage de l'application pour savoir si
// l'utilisateur est déjà connecté (session Firebase active).
//
// Qui l'envoie : le widget racine de l'app (main.dart ou
// un wrapper), dans son initState ou son build.
//
// Exemple :
//   context.read<AuthBloc>().add(const CheckAuthStatus());
// ──────────────────────────────────────────────────────────
class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

// ──────────────────────────────────────────────────────────
// SignInWithGoogle
//
// Envoyé quand l'utilisateur appuie sur le bouton
// "Se connecter avec Google".
//
// Exemple :
//   context.read<AuthBloc>().add(const SignInWithGoogle());
// ──────────────────────────────────────────────────────────
class SignInWithGoogle extends AuthEvent {
  const SignInWithGoogle();
}

// ──────────────────────────────────────────────────────────
// SignOut
//
// Envoyé quand l'utilisateur appuie sur "Se déconnecter"
// (dans le profil ou les paramètres).
//
// Exemple :
//   context.read<AuthBloc>().add(const SignOut());
// ──────────────────────────────────────────────────────────
class SignOut extends AuthEvent {
  const SignOut();
}
