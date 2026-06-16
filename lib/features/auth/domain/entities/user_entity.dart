// Entité User - couche domaine
// Les entités représentent les objets métier purs, sans dépendance à Firebase ou autre
class UserEntity {
  final String uid;       // Identifiant unique Firebase
  final String email;     // Email Google
  final String name;      // Nom complet
  final String? photoUrl; // Photo de profil (peut être null)
  final String role;      // Rôle : 'admin', 'teacher', 'parent'

  const UserEntity({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.role,
  });
}
