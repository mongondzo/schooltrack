// Les States représentent l'état actuel de l'interface.
// L'UI "écoute" le BLoC et se reconstruit chaque fois que le State change.
//
// Cycle de vie typique :
//   1. StudentInitial     → l'écran vient d'être créé
//   2. StudentLoading     → on charge les données
//   3. StudentsLoaded     → les données sont prêtes, on les affiche
//   4. StudentError       → une erreur s'est produite, on affiche le message
//   5. StudentActionSuccess → une opération (ajout/modif/suppression) a réussi
// =============================================================================

import '../../domain/entities/student.dart';

// Classe de base dont tous les states héritent
abstract class StudentState {}

// État initial : rien n'a encore été chargé
class StudentInitial extends StudentState {}

// Chargement en cours : afficher un spinner / indicateur de progression
class StudentLoading extends StudentState {}

// Données chargées avec succès
class StudentsLoaded extends StudentState {
  // La liste des élèves à afficher
  final List<Student> students;

  // Liste filtrée lors d'une recherche (peut être identique à students)
  final List<Student> filteredStudents;

  // Indique si une recherche est en cours (pour afficher un indicateur)
  final bool isSearching;

  StudentsLoaded({
    required this.students,
    List<Student>? filteredStudents,
    this.isSearching = false,
  }) : filteredStudents = filteredStudents ?? students;

  // Retourne les élèves à afficher selon le contexte (recherche ou non)
  List<Student> get displayStudents =>
      isSearching ? filteredStudents : students;
}

// Une erreur s'est produite : afficher le message à l'utilisateur
class StudentError extends StudentState {
  final String message; // Message d'erreur lisible par l'utilisateur

  StudentError({required this.message});
}

// Une action (ajout, modification, suppression) s'est terminée avec succès
// Permet d'afficher un SnackBar de confirmation ou de naviguer en arrière.
class StudentActionSuccess extends StudentState {
  final String message; // Ex: "Élève ajouté avec succès"

  StudentActionSuccess({required this.message});
}
