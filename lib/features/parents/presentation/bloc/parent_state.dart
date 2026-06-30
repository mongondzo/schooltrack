// ════════════════════════════════════════════════════════════════
// STATES : ParentState (parent_state.dart)
// Rôle   : Représente ce que l'UI doit afficher à un instant donné.
//          Le Bloc émet un State → l'UI se reconstruit en réponse.
// ════════════════════════════════════════════════════════════════

part of 'parent_bloc.dart';

abstract class ParentState {}

/// Rien n'a encore été chargé (état de départ)
class ParentInitial extends ParentState {}

/// Une opération est en cours → afficher un spinner / skeleton
class ParentLoading extends ParentState {}

/// Liste chargée avec succès (utilisé aussi après ajout/modif/suppr)
class ParentLoaded extends ParentState {
  final List<ParentEntity> parents;
  final bool isSearching;  // true si un filtre de recherche est actif
  final String? message;   // message de succès optionnel (SnackBar)

  ParentLoaded({
    required this.parents,
    this.isSearching = false,
    this.message,
  });
}

/// Une erreur s'est produite → afficher le message dans l'UI
class ParentError extends ParentState {
  final String message;
  ParentError(this.message);
}
