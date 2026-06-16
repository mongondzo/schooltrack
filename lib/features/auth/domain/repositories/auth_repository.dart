import 'package:schooltrack/features/auth/domain/entities/user_entity.dart';

// Interface du dépôt d'authentification - couche domaine
// Le domaine définit CE QU'ON VEUT faire, sans savoir COMMENT c'est fait
abstract class AuthRepository {
  // Connexion avec Google
  Future<UserEntity> signInWithGoogle();

  // Déconnexion
  Future<void> signOut();

  // Récupère l'utilisateur actuellement connecté (null si non connecté)
  Future<UserEntity?> getCurrentUser();
}
