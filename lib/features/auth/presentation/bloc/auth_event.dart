abstract class AuthEvent {}
// Les Events sont les actions que l'utilisateur ou l'app peut déclencher

// Événement : vérifier si l'utilisateur est déjà connecté (au démarrage)
class AuthCheckRequested extends AuthEvent {}

// Événement : l'utilisateur veut se connecter avec Google
class AuthGoogleSignInRequested extends AuthEvent {}

// Événement : l'utilisateur veut se déconnecter
class AuthSignOutRequested extends AuthEvent {}
