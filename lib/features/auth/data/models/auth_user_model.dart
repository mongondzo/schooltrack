import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  // creation du modèle AuthUserModel qui étend l'entité AuthUser
  AuthUserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.imageUrl,
  });

  // méthode pour convertir une instance de AuthUserModel en Json
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'imageUrl': imageUrl};
  }

  // factory method pour créer une instance de AuthUserModel à partir d'un Json
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
