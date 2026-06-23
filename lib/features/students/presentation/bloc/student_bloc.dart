// Le BLoC (Business Logic Component) est le cerveau de la feature.
// Il reçoit des Events, traite la logique métier, et émet des States.
//
// Il ne connaît pas l'UI (pas de widgets) et ne connaît pas Firebase
// (il passe par le repository). C'est ce qu'on appelle la séparation des
// responsabilités (Separation of Concerns).
// Flux complet :
//   1. L'UI ajoute un Event au BLoC : bloc.add(LoadStudents())
//   2. Le BLoC traite l'event dans le bon handler
//   3. Le BLoC émet un nouveau State
//   4. L'UI se reconstruit via BlocBuilder

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';
import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  // Le BLoC dépend du repository (abstrait), pas de Firebase directement
  final StudentRepository repository;

  // On garde une référence à la liste complète pour la recherche locale
  List<Student> _allStudents = [];

  // Subscription au Stream Firestore (pour pouvoir l'annuler plus tard)
  StreamSubscription<List<Student>>? _studentsSubscription;

  // On commence avec l'état initial
  StudentBloc({required this.repository}) : super(StudentInitial()) {
    // Enregistrement de chaque handler d'événement
    on<LoadStudents>(_onLoadStudents);
    on<AddStudent>(_onAddStudent);
    on<UpdateStudent>(_onUpdateStudent);
    on<DeleteStudent>(_onDeleteStudent);
    on<SearchStudents>(_onSearchStudents);
    on<ClearSearch>(_onClearSearch);
  }

  // Chargement en temps réel via Stream Firestore
  // Dès que Firestore change, la liste se met à jour automatiquement.
  Future<void> _onLoadStudents(
    LoadStudents event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading()); // Affiche le spinner

    try {
      // Annule l'ancienne subscription si elle existe
      await _studentsSubscription?.cancel();

      // Écoute le Stream Firestore en temps réel
      // emit.forEach gère automatiquement la subscription dans le BLoC
      await emit.forEach<List<Student>>(
        repository.getStudents(),
        onData: (students) {
          _allStudents = students; // Sauvegarde la liste complète
          return StudentsLoaded(students: students);
        },
        onError: (error, stackTrace) {
          return StudentError(message: 'Erreur de chargement: $error');
        },
      );
    } catch (e) {
      emit(StudentError(message: 'Impossible de charger les élèves: $e'));
    }
  }

  // Ajout d'un élève
  Future<void> _onAddStudent(
    AddStudent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      await repository.addStudent(event.student);
      // Firestore met à jour le Stream automatiquement,
      // mais on émet un état de succès pour afficher un message.
      emit(StudentActionSuccess(message: 'Élève ajouté avec succès !'));
      // On recharge la liste pour revenir à l'état normal
      add(LoadStudents());
    } catch (e) {
      emit(StudentError(message: 'Impossible d\'ajouter l\'élève: $e'));
    }
  }

  // Modification d'un élève
  Future<void> _onUpdateStudent(
    UpdateStudent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      await repository.updateStudent(event.student);
      emit(StudentActionSuccess(message: 'Élève modifié avec succès !'));
      add(LoadStudents());
    } catch (e) {
      emit(StudentError(message: 'Impossible de modifier l\'élève: $e'));
    }
  }

  // Suppression d'un élève
  Future<void> _onDeleteStudent(
    DeleteStudent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      await repository.deleteStudent(event.studentId);
      emit(StudentActionSuccess(message: 'Élève supprimé avec succès !'));
      add(LoadStudents());
    } catch (e) {
      emit(StudentError(message: 'Impossible de supprimer l\'élève: $e'));
    }
  }

  // Recherche dans la liste locale (pas de nouvel appel Firestore)
  Future<void> _onSearchStudents(
    SearchStudents event,
    Emitter<StudentState> emit,
  ) async {
    if (event.query.isEmpty) {
      // Si la recherche est vide, on affiche tous les élèves
      emit(StudentsLoaded(students: _allStudents));
      return;
    }

    final lowerQuery = event.query.toLowerCase();
    final filtered = _allStudents.where((student) {
      return student.nom.toLowerCase().contains(lowerQuery) ||
          student.prenom.toLowerCase().contains(lowerQuery) ||
          student.classe.toLowerCase().contains(lowerQuery);
    }).toList();

    emit(
      StudentsLoaded(
        students: _allStudents,
        filteredStudents: filtered,
        isSearching: true,
      ),
    );
  }

  // Réinitialise la recherche
  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentsLoaded(students: _allStudents));
  }

  // Important : annule la subscription Firestore quand le BLoC est détruit
  // Évite les memory leaks (fuites mémoire).
  @override
  Future<void> close() {
    _studentsSubscription?.cancel();
    return super.close();
  }
}
