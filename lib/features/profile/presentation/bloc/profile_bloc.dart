// ════════════════════════════════════════════════════════════════
// BLOC : ProfileBloc
// Couche : Presentation
// Rôle   : Cerveau de la fonctionnalité Profile.
//          Reçoit les Events → appelle le Repository → émet les States.
//          L'UI ne parle jamais directement à Firestore.
// ════════════════════════════════════════════════════════════════

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooltrack/features/profile/domain/entities/profile_entity.dart';
import 'package:schooltrack/features/profile/domain/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  // On garde le profil en mémoire pour les mises à jour optimistes
  ProfileEntity? _currentProfile;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<LogoutProfile>(_onLogoutProfile);
  }

  // ─────────────────────────────────────────────────────────────
  // Charger le profil depuis Firestore
  // ─────────────────────────────────────────────────────────────
  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await repository.getProfile(event.uid);
      _currentProfile = profile; // Mise en cache locale
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError('Impossible de charger le profil : $e'));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Mettre à jour nom + téléphone
  // ─────────────────────────────────────────────────────────────
  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await repository.updateProfile(
        uid: event.uid,
        name: event.name,
        phone: event.phone,
      );

      // On recharge depuis Firestore pour avoir les données fraîches
      final updated = await repository.getProfile(event.uid);
      _currentProfile = updated;

      emit(ProfileUpdateSuccess(
        profile: updated,
        message: 'Profil mis à jour avec succès !',
      ));

      // On émet ensuite ProfileLoaded pour que l'UI affiche les nouvelles données
      emit(ProfileLoaded(updated));
    } catch (e) {
      emit(ProfileError('Impossible de modifier le profil : $e'));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Déconnexion
  // ─────────────────────────────────────────────────────────────
  Future<void> _onLogoutProfile(
    LogoutProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await repository.logout();
      _currentProfile = null; // On nettoie le cache
      emit(ProfileLoggedOut()); // L'UI va rediriger vers LoginPage
    } catch (e) {
      emit(ProfileError('Erreur lors de la déconnexion : $e'));
    }
  }
}
