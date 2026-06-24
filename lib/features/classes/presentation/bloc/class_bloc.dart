// ============================================================
// FICHIER : presentation/bloc/class_bloc.dart
//
// RÔLE : Le BLoC est le "cerveau" de la feature.
// Il reçoit des Events, appelle le Repository, et émet des States.
//
// L'interface NE PARLE JAMAIS directement à Firestore.
// Elle envoie un Event au BLoC → le BLoC fait le travail →
// le BLoC émet un State → l'interface se reconstruit.
//
// FLUX COMPLET :
// Page → bloc.add(LoadClasses())
//      → BLoC appelle repository.getClasses()
//      → repository appelle datasource.getClasses()
//      → datasource parle à Firestore
//      → résultat remonte jusqu'au BLoC
//      → BLoC émet ClassLoaded(classes)
//      → Page se reconstruit avec la liste
// ============================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/class_repository.dart';
import 'class_event.dart';
import 'class_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  // Le BLoC dépend du repository ABSTRAIT (pas de l'implémentation).
  // C'est ce qui permet de garder le BLoC indépendant de Firestore.
  final ClassRepository repository;

  ClassBloc({required this.repository}) : super(ClassInitial()) {
    // On enregistre un handler pour chaque type d'event.
    // "on<MonEvent>(_monHandler)" signifie : quand cet event arrive,
    // appelle cette fonction.
    on<LoadClasses>(_onLoadClasses);
    on<AddClass>(_onAddClass);
    on<UpdateClass>(_onUpdateClass);
    on<DeleteClass>(_onDeleteClass);
  }

  // ----------------------------------------------------------
  // CHARGER toutes les classes
  // ----------------------------------------------------------
  Future<void> _onLoadClasses(
    LoadClasses event,
    Emitter<ClassState> emit,
  ) async {
    // On signale que le chargement commence → l'UI affiche un spinner
    emit(ClassLoading());

    try {
      final classes = await repository.getClasses();
      // Succès → on envoie la liste à l'interface
      emit(ClassLoaded(classes));
    } catch (e) {
      // Erreur réseau, Firestore indisponible, etc.
      emit(ClassError('Impossible de charger les classes : $e'));
    }
  }

  // ----------------------------------------------------------
  // AJOUTER une classe
  // ----------------------------------------------------------
  Future<void> _onAddClass(AddClass event, Emitter<ClassState> emit) async {
    // Pas de ClassLoading ici pour éviter un flash dans l'UI,
    // la page de formulaire sera fermée immédiatement.
    try {
      await repository.addClass(event.classEntity);
      // Après l'ajout, on recharge la liste complète
      add(LoadClasses());
    } catch (e) {
      emit(ClassError("Impossible d'ajouter la classe : $e"));
    }
  }

  // ----------------------------------------------------------
  // MODIFIER une classe
  // ----------------------------------------------------------
  Future<void> _onUpdateClass(
    UpdateClass event,
    Emitter<ClassState> emit,
  ) async {
    try {
      await repository.updateClass(event.classEntity);
      // Après la modification, on recharge la liste
      add(LoadClasses());
    } catch (e) {
      emit(ClassError('Impossible de modifier la classe : $e'));
    }
  }

  // ----------------------------------------------------------
  // SUPPRIMER une classe
  // ----------------------------------------------------------
  Future<void> _onDeleteClass(
    DeleteClass event,
    Emitter<ClassState> emit,
  ) async {
    try {
      await repository.deleteClass(event.id);
      // Après la suppression, on recharge la liste
      add(LoadClasses());
    } catch (e) {
      emit(ClassError('Impossible de supprimer la classe : $e'));
    }
  }
}
