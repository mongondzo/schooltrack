// Le repository implémente le contrat défini dans le domain.
// Il fait le lien entre le datasource (Firebase) et le reste de l'app.
//
// Rôle du repository :
//   - Appeller le datasource pour récupérer des données
//   - Convertir les modèles (data) en entités (domain)
//   - Gérer les erreurs Firebase et les transformer en exceptions lisibles

import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/student_remote_datasource.dart';
import '../models/student_model.dart';

class StudentRepositoryImpl implements StudentRepository {
  // Le repository dépend du datasource abstrait (pas de l'implémentation)
  // C'est ce qu'on appelle l'injection de dépendances.
  final StudentRemoteDataSource remoteDataSource;

  StudentRepositoryImpl({required this.remoteDataSource});

  // Écoute en temps réel et transforme les StudentModel en Student (entité)
  @override
  Stream<List<Student>> getStudents() {
    // On transforme le Stream<List<StudentModel>> en Stream<List<Student>>
    // Les StudentModel sont déjà des Student (héritage), donc c'est transparent
    return remoteDataSource.getStudents();
  }

  // Récupère un élève par son ID
  @override
  Future<Student?> getStudentById(String id) async {
    try {
      return await remoteDataSource.getStudentById(id);
    } catch (e) {
      throw Exception('Impossible de récupérer l\'élève: $e');
    }
  }

  // Ajoute un élève : on convertit l'entité en modèle avant de sauvegarder
  @override
  Future<void> addStudent(Student student) async {
    try {
      // Conversion entité → modèle pour pouvoir appeler toFirestore()
      final studentModel = StudentModel.fromEntity(student);
      await remoteDataSource.addStudent(studentModel);
    } catch (e) {
      throw Exception('Impossible d\'ajouter l\'élève: $e');
    }
  }

  // Met à jour un élève existant
  @override
  Future<void> updateStudent(Student student) async {
    try {
      final studentModel = StudentModel.fromEntity(student);
      await remoteDataSource.updateStudent(studentModel);
    } catch (e) {
      throw Exception('Impossible de modifier l\'élève: $e');
    }
  }

  // Supprime un élève par son ID
  @override
  Future<void> deleteStudent(String id) async {
    try {
      await remoteDataSource.deleteStudent(id);
    } catch (e) {
      throw Exception('Impossible de supprimer l\'élève: $e');
    }
  }

  // Recherche des élèves selon une requête texte
  @override
  Future<List<Student>> searchStudents(String query) async {
    try {
      return await remoteDataSource.searchStudents(query);
    } catch (e) {
      throw Exception('Erreur lors de la recherche: $e');
    }
  }
}
