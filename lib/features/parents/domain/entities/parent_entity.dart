// ════════════════════════════════════════════════════════════════
// ENTITÉ : ParentEntity
// Couche  : Domain — aucune dépendance à Firebase ou autre lib
// Rôle    : Représente un parent dans la logique métier de l'app.
//           C'est un objet PUR, sans connaissance de Firestore.
// ════════════════════════════════════════════════════════════════

class ParentEntity {
  final String id;                // Identifiant unique Firestore
  final String name;              // Nom complet du parent
  final String email;             // Email de contact
  final String phone;             // Numéro de téléphone
  final String address;           // Adresse du domicile
  final List<String> childrenIds; // IDs des élèves (collection 'students')
  final DateTime createdAt;       // Date d'enregistrement dans le système

  const ParentEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.childrenIds,
    required this.createdAt,
  });

  // Initiales pour l'avatar (ex : "Jean Dupont" → "JD")
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'P';
  }

  // Nombre d'enfants associés à ce parent
  int get childrenCount => childrenIds.length;
}
