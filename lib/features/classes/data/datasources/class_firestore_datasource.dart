// ============================================================
// FICHIER : data/datasources/class_firestore_datasource.dart
//
// RÔLE : C'est ici que tout le code Firestore se trouve.
// Ce fichier est le SEUL endroit de la feature "Classes" qui
// parle directement à Firebase.
//
// Avantage : si tu changes de base de données, tu changes
// seulement ce fichier.
//
// La collection Firestore utilisée est "classes".
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/class_model.dart';

class ClassFirestoreDataSource {
  // Instance de Firestore injectée via le constructeur.
  // On l'injecte (plutôt que FirebaseFirestore.instance directement)
  // pour faciliter les tests unitaires si tu en fais un jour.
  final FirebaseFirestore _firestore;

  ClassFirestoreDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Raccourci pratique vers la collection "classes"
  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('classes');

  // -----------------------------------------------------------
  // LIRE toutes les classes
  // orderBy createdAt desc = les plus récentes en premier
  // -----------------------------------------------------------
  Future<List<ClassModel>> getClasses() async {
    final snapshot = await _collection
        .orderBy('createdAt', descending: true)
        .get();

    // Pour chaque document Firestore, on crée un ClassModel
    return snapshot.docs
        .map((doc) => ClassModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  // -----------------------------------------------------------
  // LIRE une seule classe par son id
  // Retourne null si le document n'existe pas
  // -----------------------------------------------------------
  Future<ClassModel?> getClassById(String id) async {
    final doc = await _collection.doc(id).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return ClassModel.fromMap(doc.id, doc.data()!);
  }

  // -----------------------------------------------------------
  // AJOUTER une classe
  // .add() laisse Firestore générer un identifiant unique
  // automatiquement. C'est pourquoi dans le BLoC, on passe
  // id: '' quand on crée une nouvelle ClassEntity.
  // -----------------------------------------------------------
  Future<void> addClass(ClassModel classModel) async {
    await _collection.add(classModel.toMap());
  }

  // -----------------------------------------------------------
  // MODIFIER une classe
  // .doc(id).update() modifie seulement les champs fournis,
  // sans écraser les autres champs du document.
  // -----------------------------------------------------------
  Future<void> updateClass(ClassModel classModel) async {
    await _collection.doc(classModel.id).update(classModel.toMap());
  }

  // -----------------------------------------------------------
  // SUPPRIMER une classe
  // .doc(id).delete() supprime définitivement le document.
  // -----------------------------------------------------------
  Future<void> deleteClass(String id) async {
    await _collection.doc(id).delete();
  }
}
