// ════════════════════════════════════════════════════════════════
// INTERFACE : ProfileRepository
// Couche    : Domain
// Rôle      : Contrat que la couche Data doit respecter.
//             Le domaine décrit QUOI faire, pas COMMENT.
//             Si demain tu changes Firebase par une API REST,
//             seule la couche Data change — le domaine reste intact.
// ════════════════════════════════════════════════════════════════

import 'package:schooltrack/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  /// Récupère le profil de l'utilisateur connecté depuis Firestore
  Future<ProfileEntity> getProfile(String uid);

  /// Met à jour le nom et/ou le téléphone dans Firestore
  Future<void> updateProfile({
    required String uid,
    required String name,
    required String phone,
  });

  /// Déconnecte l'utilisateur de Firebase Auth et Google Sign-In
  Future<void> logout();
}
