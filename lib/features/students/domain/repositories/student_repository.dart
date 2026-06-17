// Une classe abstraite définit le "contrat" : elle dit QUOI faire,
// mais pas COMMENT le faire. C'est la couche domain qui définit
// ce contrat, et la couche data qui l'implémente avec Firebase.
//
// Avantage : si on veut changer Firebase par une autre base de données,
// on change seulement la couche "data", pas le reste de l'app.

import '../entities/student.dart';

abstract class StudentRepository {
  // Récupère tous les élèves depuis Firestore (Stream = données en temps réel)
  Stream<List<Student>> getStudents();

  // Récupère un seul élève par son ID
  Future<Student?> getStudentById(String id);

  // Ajoute un nouvel élève dans Firestore
  Future<void> addStudent(Student student);

  // Met à jour un élève existant
  Future<void> updateStudent(Student student);

  // Supprime un élève par son ID
  Future<void> deleteStudent(String id);

  // Recherche des élèves par nom, prénom ou classe
  Future<List<Student>> searchStudents(String query);
}
