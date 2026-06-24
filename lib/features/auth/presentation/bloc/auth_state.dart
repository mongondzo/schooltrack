// ===========================================================
// FICHIER : auth_state.dart
// CHEMIN  : features/auth/presentation/bloc/auth_state.dart
//
// RÔLE : Définit tous les états possibles de l'authentification.
// L'UI observe ces états pour décider quoi afficher.
//
// Flux normal :
//   AuthInitial → AuthLoading → AuthAuthenticated
//                            → AuthUnauthenticated
//                            → AuthError
// ===========================================================

part of 'auth_bloc.dart';

// Classe de base abstraite pour tous les états
abstract class AuthState {
  const AuthState();
}

// ──────────────────────────────────────────────────────────
// AuthInitial
//
// État de départ, avant toute vérification.
// L'app vient de démarrer, on ne sait pas encore si
// quelqu'un est connecté.
//
// L'UI affiche généralement un écran blanc ou un logo
// pendant cet état très bref.
// ──────────────────────────────────────────────────────────
class AuthInitial extends AuthState {
  const AuthInitial();
}

// ──────────────────────────────────────────────────────────
// AuthLoading
//
// Une opération est en cours (connexion, vérification,
// déconnexion). L'UI affiche un indicateur de chargement.
// ──────────────────────────────────────────────────────────
class AuthLoading extends AuthState {
  const AuthLoading();
}

// ──────────────────────────────────────────────────────────
// AuthAuthenticated
//
// L'utilisateur est connecté et son profil est chargé.
// L'UI doit afficher le Dashboard (ou l'écran principal).
//
// Contient l'objet utilisateur complet pour que l'UI
// puisse afficher le nom, la photo, le rôle, etc.
//
// IMPORTANT : user.uid = user.ownerId, la clé pour filtrer
// les données Firestore de cet utilisateur uniquement.
// ──────────────────────────────────────────────────────────
class AuthAuthenticated extends AuthState {
  final AuthUserEntity user;

  const AuthAuthenticated(this.user);

  // Pratique pour accéder à l'ownerId depuis n'importe quel
  // widget qui écoute le BLoC :
  //   final state = context.read<AuthBloc>().state;
  //   if (state is AuthAuthenticated) {
  //     final ownerId = state.ownerId; // ← ici
  //   }
  String get ownerId => user.uid;
}

// ──────────────────────────────────────────────────────────
// AuthUnauthenticated
//
// Personne n'est connecté. L'UI doit afficher l'écran
// de connexion (LoginPage).
// ──────────────────────────────────────────────────────────
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

// ──────────────────────────────────────────────────────────
// AuthError
//
// Une erreur s'est produite. L'UI affiche un message
// d'erreur tout en restant sur l'écran de connexion.
//
// Exemples d'erreurs :
//   - L'utilisateur a annulé la sélection de compte Google
//   - Pas de connexion internet
//   - Erreur Firebase interne
// ──────────────────────────────────────────────────────────
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}
