# TODO - Auth Google only (Firebase)

- [x] Identifier les erreurs bloquantes dans la logique auth.
- [x] Corriger le problème d’import invalide dans `lib/features/auth/presentation/pages/login_page.dart` (suppression de `auth_bloc_simple.dart`).
- [ ] Lancer `flutter analyze` / build pour vérifier la compilation (outil terminal sous Windows PS/&&).
- [ ] Vérifier `splash_page.dart` et toute autre page pour s’assurer que rien ne dépend d’un `auth_bloc_simple.dart` manquant.
- [ ] Nettoyer toute UI / code restant pour email/password si présent (après compilation).

