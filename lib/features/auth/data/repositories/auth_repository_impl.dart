import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/firebase_auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService firebaseAuthServices;

  AuthRepositoryImpl(this.firebaseAuthServices);

  @override
  Future<AuthUser?> getCurrentUser() async {
    final user = firebaseAuthServices.getUser();

    if (user != null) {
      return AuthUser(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        imageUrl: user.photoURL ?? '',
      );
    }
    return null;
  }

  @override
  Future<AuthUser?> signIn(String email, String password) async {
    return await firebaseAuthServices.signIn(email, password);
  }

  @override
  Future<void> signUp(String email, String password, String name) async {
    await firebaseAuthServices.signUp(email, password, name);
  }

  @override
  Future<AuthUser?> signInWithGoogle() async {
    return await firebaseAuthServices.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    await firebaseAuthServices.signOut();
  }
}
