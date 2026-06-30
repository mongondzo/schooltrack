// ════════════════════════════════════════════════════════════════
// BLOC : ParentBloc (parent_bloc.dart)
// Couche : Presentation
// Rôle   : Cerveau de la fonctionnalité Parents.
//          Reçoit les Events de l'UI → appelle le Repository
//          → émet des States que l'UI observe pour se reconstruire.
//
//   UI  → Event  → ParentBloc → Repository → Firestore
//   UI  ← State  ← ParentBloc
// ════════════════════════════════════════════════════════════════

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooltrack/features/parents/domain/entities/parent_entity.dart';
import 'package:schooltrack/features/parents/domain/repositories/parent_repository.dart';

part 'parent_event.dart';
part 'parent_state.dart';

class ParentBloc extends Bloc<ParentEvent, ParentState> {
  final ParentRepository repository;

  // Cache local de la liste complète, utilisé pour la recherche
  // instantanée sans avoir à refaire un appel Firestore
  List<ParentEntity> _allParents = [];

  ParentBloc({required this.repository}) : super(ParentInitial()) {
    on<LoadParents>(_onLoadParents);
    on<AddParent>(_onAddParent);
    on<UpdateParent>(_onUpdateParent);
    on<DeleteParent>(_onDeleteParent);
    on<SearchParents>(_onSearchParents);
    on<ClearParentSearch>(_onClearSearch);
  }

  // ── Charger tous les parents ──────────────────────────────────
  Future<void> _onLoadParents(
    LoadParents event,
    Emitter<ParentState> emit,
  ) async {
    emit(ParentLoading());
    try {
      _allParents = await repository.getParents();
      emit(ParentLoaded(parents: _allParents));
    } catch (e) {
      emit(ParentError('Impossible de charger les parents : $e'));
    }
  }

  // ── Ajouter un parent ─────────────────────────────────────────
  Future<void> _onAddParent(
    AddParent event,
    Emitter<ParentState> emit,
  ) async {
    emit(ParentLoading());
    try {
      await repository.addParent(event.parent);
      // On recharge la liste fraîche depuis Firestore après l'ajout
      _allParents = await repository.getParents();
      emit(ParentLoaded(
        parents: _allParents,
        message: 'Parent ajouté avec succès !',
      ));
    } catch (e) {
      emit(ParentError('Impossible d\'ajouter le parent : $e'));
    }
  }

  // ── Modifier un parent ────────────────────────────────────────
  Future<void> _onUpdateParent(
    UpdateParent event,
    Emitter<ParentState> emit,
  ) async {
    emit(ParentLoading());
    try {
      await repository.updateParent(event.parent);
      _allParents = await repository.getParents();
      emit(ParentLoaded(
        parents: _allParents,
        message: 'Parent modifié avec succès !',
      ));
    } catch (e) {
      emit(ParentError('Impossible de modifier le parent : $e'));
    }
  }

  // ── Supprimer un parent ───────────────────────────────────────
  Future<void> _onDeleteParent(
    DeleteParent event,
    Emitter<ParentState> emit,
  ) async {
    emit(ParentLoading());
    try {
      await repository.deleteParent(event.parentId);
      _allParents = await repository.getParents();
      emit(ParentLoaded(
        parents: _allParents,
        message: 'Parent supprimé avec succès !',
      ));
    } catch (e) {
      emit(ParentError('Impossible de supprimer le parent : $e'));
    }
  }

  // ── Rechercher des parents (filtre local, sans appel réseau) ──
  Future<void> _onSearchParents(
    SearchParents event,
    Emitter<ParentState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(ParentLoaded(parents: _allParents));
      return;
    }
    final q = event.query.toLowerCase();
    final filtered = _allParents
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.email.toLowerCase().contains(q) ||
            p.phone.contains(q))
        .toList();
    emit(ParentLoaded(parents: filtered, isSearching: true));
  }

  // ── Effacer la recherche ──────────────────────────────────────
  Future<void> _onClearSearch(
    ClearParentSearch event,
    Emitter<ParentState> emit,
  ) async {
    emit(ParentLoaded(parents: _allParents));
  }
}
