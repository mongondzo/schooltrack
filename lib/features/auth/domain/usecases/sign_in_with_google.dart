import 'package:schooltrack/features/auth/domain/entities/user_entity.dart';
import 'package:schooltrack/features/auth/domain/repositories/auth_repository.dart';

// Use Case : Connexion avec Google
// Un use case = une action métier précise
class SignInWithGoogle {
  final AuthRepository repository;

  // On injecte le repository via le constructeur
  SignInWithGoogle(this.repository);

  // La méthode call() permet d'utiliser la classe comme une fonction : signInWithGoogle()
  Future<UserEntity> call() async {
    return await repository.signInWithGoogle();
  }
}
