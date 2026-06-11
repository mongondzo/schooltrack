import '../entities/auth_user.dart';

abstract class AuthRepository {
  //creation de l'interface AuthRepository avec
  //les méthodes signIn, signUp , signOut , singninWithGoogle et getCurrentUser
  Future<AuthUser?> signIn(String email, String password);
  Future<void> signUp(String email, String password, String name);
  Future<AuthUser?> signInWithGoogle();
  Future<void> signOut();
  Future<AuthUser?> getCurrentUser();
}
