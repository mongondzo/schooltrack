// ════════════════════════════════════════════════════════════════
// EVENTS : ParentEvent (parent_event.dart)
// Rôle   : Chaque action que l'utilisateur (admin) peut déclencher
//          dans l'écran Parents est représentée par un Event.
// ════════════════════════════════════════════════════════════════

part of 'parent_bloc.dart';

abstract class ParentEvent {}

/// Charger la liste complète des parents depuis Firestore
class LoadParents extends ParentEvent {}

/// Ajouter un nouveau parent
class AddParent extends ParentEvent {
  final ParentEntity parent;
  AddParent(this.parent);
}

/// Modifier un parent existant
class UpdateParent extends ParentEvent {
  final ParentEntity parent;
  UpdateParent(this.parent);
}

/// Supprimer un parent par son ID
class DeleteParent extends ParentEvent {
  final String parentId;
  DeleteParent(this.parentId);
}

/// Rechercher des parents par nom / email / téléphone
class SearchParents extends ParentEvent {
  final String query;
  SearchParents(this.query);
}

/// Réinitialiser la recherche → revenir à la liste complète
class ClearParentSearch extends ParentEvent {}
