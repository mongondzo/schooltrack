// Le "domain" est le cœur de l'application. Cette classe représente
// un élève tel qu'il existe dans la logique métier de l'app,
// sans se soucier de Firebase ou de l'interface utilisateur.

class Student {
  final String id; // Identifiant unique généré par Firestore
  final String nom; // Nom de famille
  final String prenom; // Prénom
  final String classe; // Ex: "6ème A", "5ème B"
  final DateTime dateNaissance;
  final String telephoneParent;
  final String adresse;
  final DateTime createdAt; // Date de création dans la base de données

  const Student({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.classe,
    required this.dateNaissance,
    required this.telephoneParent,
    required this.adresse,
    required this.createdAt,
  });

  // Getter utilitaire : retourne "Prénom Nom" (ex: "nevy mongondzo")
  String get nomComplet => '$prenom $nom';

  // Getter utilitaire : retourne les initiales pour l'avatar (ex: "JD")
  String get initiales {
    final firstLetter = prenom.isNotEmpty ? prenom[0].toUpperCase() : '';
    final secondLetter = nom.isNotEmpty ? nom[0].toUpperCase() : '';
    return '$firstLetter$secondLetter';
  }

  // Méthode copyWith : crée une copie de l'élève avec certains champs modifiés.
  // Très utile pour les mises à jour partielles.
  Student copyWith({
    String? id,
    String? nom,
    String? prenom,
    String? classe,
    DateTime? dateNaissance,
    String? telephoneParent,
    String? adresse,
    DateTime? createdAt,
  }) {
    return Student(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      classe: classe ?? this.classe,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      telephoneParent: telephoneParent ?? this.telephoneParent,
      adresse: adresse ?? this.adresse,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Student(id: $id, nom: $nomComplet, classe: $classe)';
  }
}
