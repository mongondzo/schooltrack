// ════════════════════════════════════════════════════════════════
// EVENTS : ProfileEvent
// Couche  : Presentation / Bloc
// Rôle    : Chaque action de l'utilisateur est modélisée comme Event.
//           L'UI envoie un Event → le Bloc réagit → émet un State.
// ════════════════════════════════════════════════════════════════

part of 'profile_bloc.dart';

abstract class ProfileEvent {}

// ── Charger le profil (au démarrage de ProfilePage) ───────────
class LoadProfile extends ProfileEvent {
  final String uid; // On a besoin de l'UID pour requêter Firestore
  LoadProfile(this.uid);
}

// ── Mettre à jour nom + téléphone ─────────────────────────────
class UpdateProfile extends ProfileEvent {
  final String uid;
  final String name;
  final String phone;

  UpdateProfile({
    required this.uid,
    required this.name,
    required this.phone,
  });
}

// ── Déconnexion ───────────────────────────────────────────────
class LogoutProfile extends ProfileEvent {}
