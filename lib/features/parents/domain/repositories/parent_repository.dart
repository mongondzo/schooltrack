// ════════════════════════════════════════════════════════════════
// INTERFACE : ParentRepository (parent_repository.dart)
// Couche    : Domain
// Rôle      : Contrat que la couche Data DOIT respecter.
//             Le Bloc dépend SEULEMENT de cette interface abstraite,
//             jamais directement de Firestore. Ainsi, le domaine
//             reste indépendant de la technologie utilisée.
// ════════════════════════════════════════════════════════════════

import 'package:schooltrack/features/parents/domain/entities/parent_entity.dart';

abstract class ParentRepository {
  /// Récupère la liste complète des parents depuis Firestore
  Future<List<ParentEntity>> getParents();

  /// Ajoute un nouveau parent
  Future<void> addParent(ParentEntity parent);

  /// Met à jour un parent existant (identifié par son id)
  Future<void> updateParent(ParentEntity parent);

  /// Supprime un parent par son id
  Future<void> deleteParent(String id);
}
