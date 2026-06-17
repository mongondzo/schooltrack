// Les Events sont les "actions" que l'utilisateur ou l'app peut déclencher.
// Le BLoC reçoit ces events et décide quoi faire (appeler un repository, etc.)
//
// Schéma de communication :
//   UI → Event → BLoC → traitement → State → UI se reconstruit
//
// Chaque action utilisateur = un Event différent.

import '../../domain/entities/student.dart';

// Classe de base dont tous les events héritent
abstract class StudentEvent {}

// Chargement initial : déclenché au démarrage de l'écran de liste
class LoadStudents extends StudentEvent {}

// Ajout d'un élève : l'utilisateur soumet le formulaire d'ajout
class AddStudent extends StudentEvent {
  final Student student; // L'élève à ajouter (construit depuis le formulaire)
  AddStudent({required this.student});
}

// Modification d'un élève : l'utilisateur soumet le formulaire d'édition
class UpdateStudent extends StudentEvent {
  final Student student; // L'élève avec les nouvelles valeurs
  UpdateStudent({required this.student});
}

// Suppression d'un élève : l'utilisateur confirme la suppression
class DeleteStudent extends StudentEvent {
  final String studentId; // On n'a besoin que de l'ID pour supprimer
  DeleteStudent({required this.studentId});
}

// Recherche : l'utilisateur tape dans la barre de recherche
class SearchStudents extends StudentEvent {
  final String query; // Le texte saisi par l'utilisateur
  SearchStudents({required this.query});
}

// Réinitialise la recherche : retourne à la liste complète
class ClearSearch extends StudentEvent {}
