// ════════════════════════════════════════════════════════════════
// ENTITÉ : ProfileEntity
// Couche  : Domain (la plus pure — aucune dépendance externe)
// Rôle    : Représente un profil utilisateur dans la logique métier.
//           Pas de Firebase, pas de JSON ici : juste les données.
// ════════════════════════════════════════════════════════════════

class ProfileEntity {
  final String id;          // UID Firebase Auth
  final String name;        // Nom complet affiché
  final String email;       // Email Google (non modifiable)
  final String? photoUrl;   // URL de la photo de profil (peut être null)
  final String role;        // Rôle : 'admin', 'teacher', 'parent'
  final String phone;       // Numéro de téléphone (modifiable)
  final DateTime createdAt; // Date de création du compte

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.role,
    required this.phone,
    required this.createdAt,
  });

  // Label lisible pour le rôle (utile dans l'UI)
  String get roleLabel {
    switch (role) {
      case 'admin':
        return 'Administrateur';
      case 'teacher':
        return 'Enseignant';
      case 'parent':
        return 'Parent';
      default:
        return role;
    }
  }

  // Initiales pour l'avatar de secours si pas de photo
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}
