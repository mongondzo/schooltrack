import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooltrack/features/auth/domain/entities/user_entity.dart';
import 'package:schooltrack/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:schooltrack/features/auth/domain/usecases/sign_out.dart';
import 'package:schooltrack/features/auth/presentation/bloc/auth_event.dart';
import 'package:schooltrack/features/auth/presentation/bloc/auth_state.dart';

// AuthBloc : cerveau de l'authentification
// Il écoute les Events et émet des States en réponse
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle signInWithGoogle;
  final SignOut signOut;

  AuthBloc({required this.signInWithGoogle, required this.signOut})
    : super(AuthInitial()) {
    // On enregistre un handler pour chaque type d'Event

    // Vérification initiale de l'authentification
    on<AuthCheckRequested>(_onAuthCheckRequested);

    // Connexion avec Google
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);

    // Déconnexion
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  // Handler : vérifie si l'utilisateur est déjà connecté
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading()); // On affiche le chargement

    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  // Handler : connexion avec Google
  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading()); // Indique qu'une opération est en cours

    try {
      final UserEntity user = await signInWithGoogle();
      emit(AuthAuthenticated(user)); // Connexion réussie !
    } catch (e) {
      // En cas d'erreur, on retourne à l'état non connecté avec le message
      emit(AuthError(e.toString()));
    }
  }

  // Handler : déconnexion
  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await signOut();
      emit(AuthUnauthenticated()); // Déconnecté avec succès
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
