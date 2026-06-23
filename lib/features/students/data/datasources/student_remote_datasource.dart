import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_model.dart';

// Classe abstraite qui définit les opérations disponibles
abstract class StudentRemoteDataSource {
  Stream<List<StudentModel>> getStudents();
  Future<StudentModel?> getStudentById(String id);
  Future<void> addStudent(StudentModel student);
  Future<void> updateStudent(StudentModel student);
  Future<void> deleteStudent(String id);
  Future<List<StudentModel>> searchStudents(String query);
}

// Implémentation concrète qui utilise Cloud Firestore
class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  // Instance de Firestore injectée dans le constructeur (bonne pratique)
  final FirebaseFirestore firestore;

  // Nom de la collection dans Firestore
  static const String _collection = 'students';

  StudentRemoteDataSourceImpl({required this.firestore});

  // Raccourci pour accéder à la collection 'students'
  CollectionReference<Map<String, dynamic>> get _studentsCollection =>
      firestore.collection(_collection);

  @override
  Stream<List<StudentModel>> getStudents() {
    return _studentsCollection
        .orderBy('nom') // Tri alphabétique par nom
        .snapshots() // Retourne un Stream (temps réel)
        .map((snapshot) {
          // Convertit chaque document Firestore en StudentModel
          return snapshot.docs.map((doc) {
            return StudentModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            );
          }).toList();
        });
  }

  // Récupère un seul élève par son ID Firestore
  @override
  Future<StudentModel?> getStudentById(String id) async {
    final doc =
        await _studentsCollection.doc(id).get()
            as DocumentSnapshot<Map<String, dynamic>>;

    if (!doc.exists) return null; // L'élève n'existe pas dans Firestore
    return StudentModel.fromFirestore(doc);
  }

  // Ajoute un nouvel élève dans Firestore
  // Firestore génère automatiquement un ID unique pour le document.
  @override
  Future<void> addStudent(StudentModel student) async {
    // Si l'ID est vide, Firestore en génère un. Sinon on utilise celui fourni.
    if (student.id.isEmpty) {
      await _studentsCollection.add(student.toFirestore());
    } else {
      await _studentsCollection.doc(student.id).set(student.toFirestore());
    }
  }

  // Met à jour un élève existant
  // On utilise 'update' pour ne modifier que les champs fournis.
  @override
  Future<void> updateStudent(StudentModel student) async {
    await _studentsCollection.doc(student.id).update(student.toFirestore());
  }

  // Supprime un élève par son ID
  @override
  Future<void> deleteStudent(String id) async {
    await _studentsCollection.doc(id).delete();
  }

  // Recherche locale dans la liste complète des élèves.
  @override
  Future<List<StudentModel>> searchStudents(String query) async {
    final snapshot = await _studentsCollection.get();
    final allStudents = snapshot.docs
        .map(
          (doc) => StudentModel.fromFirestore(
            doc as DocumentSnapshot<Map<String, dynamic>>,
          ),
        )
        .toList();

    // Filtre par nom, prénom ou classe (insensible à la casse)
    final lowerQuery = query.toLowerCase();
    return allStudents.where((student) {
      return student.nom.toLowerCase().contains(lowerQuery) ||
          student.prenom.toLowerCase().contains(lowerQuery) ||
          student.classe.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
