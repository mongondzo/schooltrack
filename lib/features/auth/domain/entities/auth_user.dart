class AuthUser {
  // creation de l'entité AuthUser avec les champs id, email et name
  final String id;
  final String email;
  final String name;
  final String imageUrl;
  // creation du constructeur de l'entité AuthUser
  AuthUser({
    required this.id,
    required this.email,
    required this.name,
    required this.imageUrl,
  });
}
