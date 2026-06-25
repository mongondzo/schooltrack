import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/grade_repository.dart';
import 'grade_event.dart';
import 'grade_state.dart';

/// -----------------------------------------------------------------------
/// GradeBloc
/// -----------------------------------------------------------------------
/// Le "cerveau" de la fonctionnalité Grades côté Presentation.
///
/// Il reçoit des événements (LoadGrades, AddGrade, ...), appelle le
/// GradeRepository (Domain), puis émet un état (GradeLoading, GradeLoaded,
/// GradeError...) que l'UI affichera.
///
/// Le bloc ne contient AUCUNE logique Firestore : tout est délégué au
/// repository, ce qui garde le bloc simple et testable.
/// -----------------------------------------------------------------------
class GradeBloc extends Bloc<GradeEvent, GradeState> {
  final GradeRepository repository;

  GradeBloc(this.repository) : super(GradeInitial()) {
    on<LoadGrades>(_onLoadGrades);
    on<AddGrade>(_onAddGrade);
    on<UpdateGrade>(_onUpdateGrade);
    on<DeleteGrade>(_onDeleteGrade);
  }

  Future<void> _onLoadGrades(
    LoadGrades event,
    Emitter<GradeState> emit,
  ) async {
    emit(GradeLoading());
    try {
      final grades = await repository.getGrades();
      emit(GradeLoaded(grades));
    } catch (e) {
      emit(GradeError('Impossible de charger les notes : $e'));
    }
  }

  Future<void> _onAddGrade(
    AddGrade event,
    Emitter<GradeState> emit,
  ) async {
    try {
      await repository.addGrade(event.grade);
      // On recharge la liste pour que l'UI affiche la nouvelle note.
      await _onLoadGrades(LoadGrades(), emit);
    } catch (e) {
      emit(GradeError("Impossible d'ajouter la note : $e"));
    }
  }

  Future<void> _onUpdateGrade(
    UpdateGrade event,
    Emitter<GradeState> emit,
  ) async {
    try {
      await repository.updateGrade(event.grade);
      await _onLoadGrades(LoadGrades(), emit);
    } catch (e) {
      emit(GradeError('Impossible de modifier la note : $e'));
    }
  }

  Future<void> _onDeleteGrade(
    DeleteGrade event,
    Emitter<GradeState> emit,
  ) async {
    try {
      await repository.deleteGrade(event.gradeId);
      await _onLoadGrades(LoadGrades(), emit);
    } catch (e) {
      emit(GradeError('Impossible de supprimer la note : $e'));
    }
  }
}
