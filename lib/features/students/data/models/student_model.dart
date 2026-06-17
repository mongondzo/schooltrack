// Le modèle est la version "données" de l'entité Student.
// Il sait comment se convertir depuis/vers un document Firestore.
// Différence avec l'entité :
//   - Entité (domain) : représente l'objet métier pur
//   - Modèle (data)   : sait parler avec Firebase (JSON, Firestore)

import '../../domain/entities/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel extends Student {
  const StudentModel({
    required super.id,
    required super.nom,
    required super.prenom,
    required super.classe,
    required super.dateNaissance,
    required super.telephoneParent,
    required super.adresse,
    required super.createdAt,
  });

  // FACTORY : Crée un StudentModel depuis un document Firestore
  // On utilise cette méthode quand on lit des données depuis Firebase.
  factory StudentModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return StudentModel(
      id: doc.id, // L'ID est toujours le nom du document dans Firestore
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      classe: data['classe'] ?? '',
      // Firestore stocke les dates en Timestamp, on les convertit en DateTime
      dateNaissance: (data['dateNaissance'] as Timestamp).toDate(),
      telephoneParent: data['telephoneParent'] ?? '',
      adresse: data['adresse'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // FACTORY : Crée un StudentModel depuis un Map (JSON local)
  // Utile pour les tests ou si on stocke en local.
  factory StudentModel.fromMap(Map<String, dynamic> map, String id) {
    return StudentModel(
      id: id,
      nom: map['nom'] ?? '',
      prenom: map['prenom'] ?? '',
      classe: map['classe'] ?? '',
      dateNaissance: (map['dateNaissance'] as Timestamp).toDate(),
      telephoneParent: map['telephoneParent'] ?? '',
      adresse: map['adresse'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convertit le modèle en Map pour l'envoyer à Firestore
  // On n'inclut pas 'id' car c'est le nom du document, pas un champ.
  Map<String, dynamic> toFirestore() {
    return {
      'nom': nom,
      'prenom': prenom,
      'classe': classe,
      'dateNaissance': Timestamp.fromDate(dateNaissance),
      'telephoneParent': telephoneParent,
      'adresse': adresse,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Convertit l'entité Student (domain) en StudentModel (data)
  // Utile quand on veut sauvegarder une entité dans Firestore.
  factory StudentModel.fromEntity(Student student) {
    return StudentModel(
      id: student.id,
      nom: student.nom,
      prenom: student.prenom,
      classe: student.classe,
      dateNaissance: student.dateNaissance,
      telephoneParent: student.telephoneParent,
      adresse: student.adresse,
      createdAt: student.createdAt,
    );
  }
}
