import 'package:schooltrack/features/auth/domain/repositories/auth_repository.dart';

// Use Case : Déconnexion
class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  Future<void> call() async {
    return await repository.signOut();
  }
}
