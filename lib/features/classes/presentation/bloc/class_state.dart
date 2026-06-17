// ============================================================
// FICHIER : presentation/bloc/class_state.dart
//
// RÔLE : Les "states" (états) représentent CE QUE L'INTERFACE
// DOIT AFFICHER à un moment donné.
//
// L'interface observe le state actuel et se reconstruit
// automatiquement quand il change.
//
// Flux typique :
//   ClassInitial → ClassLoading → ClassLoaded (ou ClassError)
// ============================================================

import '../../domain/entities/class_entity.dart';

// Classe mère dont tous les states héritent
abstract class ClassState {}

// État au démarrage, avant toute action
class ClassInitial extends ClassState {}

// Pendant un appel Firestore → on affiche un indicateur de chargement
class ClassLoading extends ClassState {}

// Firestore a répondu avec succès → on affiche la liste
class ClassLoaded extends ClassState {
  // La liste complète des classes récupérée depuis Firestore
  final List<ClassEntity> classes;

  ClassLoaded(this.classes);
}

// Une erreur s'est produite → on affiche le message d'erreur
class ClassError extends ClassState {
  final String message;

  ClassError(this.message);
}
