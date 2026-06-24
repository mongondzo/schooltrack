// ===========================================================
// FICHIER : auth_repository.dart
// CHEMIN  : features/auth/domain/repositories/auth_repository.dart
//
// RÔLE : Contrat (interface abstraite) qui déclare QUELLES
// opérations d'authentification existent dans l'application.
//
// La couche Domain dit "je veux pouvoir faire ça",
// sans savoir COMMENT c'est fait (Firebase, API REST, etc.).
//
// L'implémentation concrète est dans :
//   data/repositories/auth_repository_impl.dart
// ===========================================================

import '../entities/auth_user_entity.dart';

abstract class AuthRepository {
  // ──────────────────────────────────────────────────────────
  // Connexion avec Google
  //
  // Ouvre le sélecteur de compte Google, connecte l'utilisateur
  // via Firebase Auth, et crée/récupère son profil dans
  // Firestore. Retourne l'utilisateur connecté.
  // ──────────────────────────────────────────────────────────
  Future<AuthUserEntity> signInWithGoogle();

  // ──────────────────────────────────────────────────────────
  // Vérifier si un utilisateur est déjà connecté
  //
  // Appelé au démarrage de l'app pour savoir si la session
  // Firebase est encore active. Si oui, on va directement
  // au Dashboard. Si non, on affiche l'écran de connexion.
  //
  // Retourne null si personne n'est connecté.
  // ──────────────────────────────────────────────────────────
  Future<AuthUserEntity?> getCurrentUser();

  // ──────────────────────────────────────────────────────────
  // Déconnexion
  //
  // Déconnecte de Firebase Auth et de Google Sign-In.
  // ──────────────────────────────────────────────────────────
  Future<void> signOut();

  // ──────────────────────────────────────────────────────────
  // Stream de l'état de connexion
  //
  // Émet l'utilisateur connecté ou null si déconnecté.
  // Utile si vous voulez réagir automatiquement aux changements
  // de session (ex : token expiré).
  // ──────────────────────────────────────────────────────────
  Stream<AuthUserEntity?> get authStateChanges;
}
