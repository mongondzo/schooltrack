// ════════════════════════════════════════════════════════════════
// STATES : ProfileState
// Couche  : Presentation / Bloc
// Rôle    : Chaque état possible de l'écran profil.
//           L'UI observe ces états et se reconstruit en conséquence.
// ════════════════════════════════════════════════════════════════

part of 'profile_bloc.dart';

abstract class ProfileState {}

// Rien n'a encore été chargé (état de départ)
class ProfileInitial extends ProfileState {}

// Une opération est en cours → afficher un spinner
class ProfileLoading extends ProfileState {}

// Le profil est chargé et disponible → afficher les données
class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  ProfileLoaded(this.profile);
}

// Une modification a réussi → afficher un SnackBar de succès
class ProfileUpdateSuccess extends ProfileState {
  final ProfileEntity profile; // Le profil mis à jour
  final String message;
  ProfileUpdateSuccess({required this.profile, required this.message});
}

// La déconnexion a réussi → l'UI redirige vers LoginPage
class ProfileLoggedOut extends ProfileState {}

// Une erreur s'est produite → afficher le message
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
