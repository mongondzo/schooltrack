// ===========================================================
// FICHIER : auth_bloc.dart
// CHEMIN  : features/auth/presentation/bloc/auth_bloc.dart
//
// RÔLE : Cerveau de l'authentification. Reçoit les Events
// (actions utilisateur), appelle le Repository, et émet
// les States (nouveaux états) pour mettre à jour l'UI.
//
// Pattern : Event → BLoC → Repository → State → UI
//
// Les fichiers auth_event.dart et auth_state.dart sont
// inclus ici grâce aux directives "part of" / "part".
// ===========================================================

// Inclut les définitions d'events et de states dans ce fichier
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooltrack/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:schooltrack/features/auth/domain/entities/auth_user_entity.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // ── Repository injecté ────────────────────────────────────
  // Le BLoC ne parle pas directement à Firebase.
  // Il passe par le Repository, qui passe par le DataSource.
  final AuthRepository _repository;

  // ── Constructeur ──────────────────────────────────────────
  AuthBloc({AuthRepository? repository})
    : _repository = repository ?? AuthRepositoryImpl(),
      // État initial : on ne sait pas encore qui est connecté
      super(const AuthInitial()) {
    // Enregistrement des handlers pour chaque Event
    // Quand le BLoC reçoit X, il appelle la méthode _onX
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<SignOut>(_onSignOut);
  }

  // ──────────────────────────────────────────────────────────
  // _onCheckAuthStatus — Vérifie la session au démarrage
  //
  // Appelé une seule fois au lancement de l'app.
  // Vérifie si Firebase a encore une session active en mémoire.
  //
  // Résultat :
  //   → Utilisateur trouvé : AuthAuthenticated(user)
  //   → Pas d'utilisateur : AuthUnauthenticated()
  //   → Erreur Firebase : AuthError(message)
  // ──────────────────────────────────────────────────────────
  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    // Montre un indicateur de chargement pendant la vérification
    emit(const AuthLoading());

    try {
      // Demande au Repository si quelqu'un est connecté
      final AuthUserEntity? user = await _repository.getCurrentUser();

      if (user != null) {
        // Session active trouvée → l'utilisateur va au Dashboard
        emit(AuthAuthenticated(user));
      } else {
        // Pas de session → l'utilisateur voit l'écran de connexion
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      // Erreur inattendue (ex : Firestore inaccessible)
      emit(AuthError('Erreur lors de la vérification : ${e.toString()}'));
    }
  }

  // ──────────────────────────────────────────────────────────
  // _onSignInWithGoogle — Connexion avec Google
  //
  // Déclenché par un appui sur le bouton "Connexion Google".
  //
  // Résultat :
  //   → Succès : AuthAuthenticated(user)
  //   → Annulation ou erreur : AuthError(message)
  //              + retour à AuthUnauthenticated après 2s
  // ──────────────────────────────────────────────────────────
  Future<void> _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Le Repository gère toute la logique :
      //   1. Ouvre le sélecteur de compte Google
      //   2. Authentifie via Firebase
      //   3. Crée ou récupère le profil Firestore
      final AuthUserEntity user = await _repository.signInWithGoogle();

      // Connexion réussie → on passe au Dashboard
      emit(AuthAuthenticated(user));

      // ── À ce stade, user.uid est disponible ──────────────
      //
      // Dans vos AUTRES BLoC (StudentBloc, ClassBloc, etc.),
      // vous pouvez récupérer l'ownerId comme ceci :
      //
      //   final authState = context.read<AuthBloc>().state;
      //   if (authState is AuthAuthenticated) {
      //     final ownerId = authState.ownerId;
      //     // Puis filtrez Firestore avec ce ownerId :
      //     firestore
      //       .collection('students')
      //       .where('ownerId', isEqualTo: ownerId)
      //       .snapshots();
      //   }
    } catch (e) {
      // L'utilisateur a peut-être annulé → message clair
      final message = e.toString().contains('annulée')
          ? 'Connexion annulée'
          : 'Erreur de connexion : ${e.toString()}';

      emit(AuthError(message));

      // Après l'erreur, on repasse à l'état "non connecté"
      // pour que l'UI réaffiche le bouton de connexion
      await Future.delayed(const Duration(milliseconds: 100));
      emit(const AuthUnauthenticated());
    }
  }

  // ──────────────────────────────────────────────────────────
  // _onSignOut — Déconnexion
  //
  // Déclenché par "Se déconnecter" dans les paramètres.
  //
  // Résultat :
  //   → Toujours : AuthUnauthenticated()
  // ──────────────────────────────────────────────────────────
  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    try {
      // Déconnecte de Firebase Auth ET de Google Sign-In
      await _repository.signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      // Même en cas d'erreur de déconnexion, on force l'état
      // "non connecté" par sécurité
      emit(const AuthUnauthenticated());
    }
  }
}
