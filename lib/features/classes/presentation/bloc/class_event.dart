// ============================================================
// FICHIER : presentation/bloc/class_event.dart
//
// RÔLE : Les "events" (événements) sont les ACTIONS que
// l'utilisateur peut déclencher dans l'interface.
//
// Pense à ça comme des boutons invisibles :
//   - L'utilisateur appuie sur "Ajouter" → on envoie AddClass
//   - La page s'ouvre → on envoie LoadClasses
//   - L'utilisateur supprime → on envoie DeleteClass
//
// Le BLoC écoute ces events et décide quoi faire.
// ============================================================

import '../../domain/entities/class_entity.dart';

// Classe mère dont tous les events héritent
abstract class ClassEvent {}

// Déclenché quand la page s'ouvre : charge la liste depuis Firestore
class LoadClasses extends ClassEvent {}

// Déclenché quand l'utilisateur valide le formulaire d'ajout
class AddClass extends ClassEvent {
  final ClassEntity classEntity;
  AddClass(this.classEntity);
}

// Déclenché quand l'utilisateur valide le formulaire de modification
class UpdateClass extends ClassEvent {
  final ClassEntity classEntity;
  UpdateClass(this.classEntity);
}

// Déclenché quand l'utilisateur confirme la suppression
class DeleteClass extends ClassEvent {
  final String id;
  DeleteClass(this.id);
}
