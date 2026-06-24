// ===========================================================
// FICHIER : auth_user_entity.dart
// CHEMIN  : features/auth/domain/entities/auth_user_entity.dart
//
// RÔLE : Représente un utilisateur connecté dans la couche
// "métier" (Domain). Cette classe ne connaît ni Firebase,
// ni Firestore, ni Flutter. Elle décrit juste CE QU'EST
// un utilisateur dans votre application.
//
// C'est l'objet que votre BLoC et votre UI manipuleront.
// ===========================================================

class AuthUserEntity {
  // ── Identifiant unique Firebase ────────────────────────────
  // Généré par Firebase Auth lors de la première connexion.
  // C'est la clé qui permet d'isoler les données :
  // students/{uid}/..., classes/{uid}/... etc.
  final String uid;

  // ── Informations du compte Google ─────────────────────────
  final String name;      // Prénom + Nom du compte Google
  final String email;     // Adresse email
  final String photoUrl;  // URL de la photo de profil

  // ── Rôle dans l'application ───────────────────────────────
  // "admin"  → peut gérer élèves, classes, notes...
  // "parent" → peut seulement consulter les données de son enfant
  final String role;

  // ── Identifiant de l'école ────────────────────────────────
  // Optionnel pour l'instant. Utile si un admin gère plusieurs
  // établissements ou si plusieurs admins partagent une école.
  final String schoolId;

  // ── Date de création du compte dans Firestore ─────────────
  final DateTime createdAt;

  // ── Constructeur ──────────────────────────────────────────
  const AuthUserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.role,
    required this.schoolId,
    required this.createdAt,
  });

  // ──────────────────────────────────────────────────────────
  // Propriétés calculées pratiques
  // ──────────────────────────────────────────────────────────

  // Retourne true si l'utilisateur est administrateur
  bool get isAdmin => role == 'admin';

  // Retourne true si l'utilisateur est un parent
  bool get isParent => role == 'parent';

  // ──────────────────────────────────────────────────────────
  // CONCEPT CLÉ : ownerId
  //
  // Pour isoler les données de chaque admin, on utilisera
  // l'uid comme "ownerId" dans toutes les autres collections.
  //
  // Structure Firestore recommandée :
  //
  //   students/
  //     {docId} → { ownerId: "uid_de_l_admin", nom: "...", ... }
  //
  //   classes/
  //     {docId} → { ownerId: "uid_de_l_admin", nomClasse: "...", ... }
  //
  // Requête pour n'avoir QUE ses propres données :
  //   .where('ownerId', isEqualTo: user.ownerId)
  //
  // C'est le getter ci-dessous qui sert à ça :
  String get ownerId => uid;

  // ── Utile pour les logs ───────────────────────────────────
  @override
  String toString() {
    return 'AuthUserEntity(uid: $uid, name: $name, email: $email, role: $role)';
  }
}
