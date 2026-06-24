# 📚 Guide d'Authentification Simplifié - SchoolTrack

## 🎯 Objectif
Ce guide explique comment fonctionne l'authentification Google avec Firebase, **spécialement conçu pour les débutants**.

---

## 📁 Structure des fichiers (Version Simplifiée)

```
lib/features/auth/
├── domain/
│   ├── entities/
│   │   └── auth_user.dart              # ✅ Structure de l'utilisateur
│   └── repositories/
│       └── auth_repository_simple.dart # ✅ Interface (contrat)
├── data/
│   └── repositories/
│       └── auth_repository_simple_impl.dart # ✅ Implémentation Firebase
└── presentation/
    ├── bloc/
    │   └── auth_bloc_simple.dart       # ✅ Gestion d'état
    ├── pages/
    │   ├── splash_page.dart            # ✅ Écran de démarrage
    │   ├── login_page.dart             # ✅ Page de connexion
    │   └── no_internet_page.dart       # ✅ Page hors-ligne
    └── widgets/
        └── google_sign_in_button.dart  # ✅ Bouton Google
```

---

## 🔄 Flux d'Authentification (Étapes Simples)

```
1. UTILISATEUR
   └─► Ouvre l'application

2. SPLASH PAGE (Écran de démarrage)
   └─► Vérifie la connexion internet
   └─► Vérifie si l'utilisateur est déjà connecté
       │
       ├─► OUI → Dashboard
       └─► NON → Login Page

3. LOGIN PAGE (Page de connexion)
   └─► Affiche le bouton "Connexion avec Google"
   └─► Utilisateur clique sur le bouton

4. AUTH BLOC (Cerveau)
   └─► Reçoit l'événement "SignInWithGoogle"
   └─► Appelle le Repository

5. REPOSITORY (Traducteur)
   └─► Ouvre le sélecteur de compte Google
   └─► Récupère les informations du compte
   └─► Envoie à Firebase pour vérification

6. FIREBASE (Backend)
   └─► Vérifie les identifiants Google
   └─► Crée ou récupère le profil utilisateur
   └─► Retourne les informations

7. RETOUR À L'APPLICATION
   └─► Repository retourne l'utilisateur
   └─► BLoC émet l'état "AuthAuthenticated"
   └─► UI navigue vers le Dashboard
```

---

## 🧩 Les 3 Concepts Clés

### 1. **ENTITÉ** (`auth_user.dart`)
**C'est quoi ?** La structure de données d'un utilisateur.

```dart
class AuthUser {
  final String id;        // ID unique (généré par Firebase)
  final String email;     // Email du compte Google
  final String name;      // Nom complet
  final String photoUrl;  // Photo de profil
}
```

**Analogie :** C'est comme une carte d'identité. Elle contient les informations essentielles d'une personne.

---

### 2. **REPOSITORY** (`auth_repository_simple.dart` + `auth_repository_simple_impl.dart`)
**C'est quoi ?** L'interface qui définit ce qu'on peut faire avec l'authentification.

**Fichier 1 - L'interface (contrat) :**
```dart
abstract class AuthRepositorySimple {
  Future<AuthUser> signInWithGoogle();      // Se connecter
  Future<AuthUser?> getCurrentUser();       // Vérifier la session
  Future<void> signOut();                   // Se déconnecter
}
```

**Fichier 2 - L'implémentation (réalité) :**
```dart
class AuthRepositorySimpleImpl implements AuthRepositorySimple {
  // C'est ici qu'on parle à Firebase
  // Firebase Auth + Google Sign-In + Firestore
}
```

**Analogie :** 
- L'interface = La commande "Je veux du café" (ce qu'on veut)
- L'implémentation = Le barista qui prépare le café (comment c'est fait)

---

### 3. **BLoC** (`auth_bloc_simple.dart`)
**C'est quoi ?** Le cerveau qui gère toute la logique d'authentification.

**Structure :**
```
ÉVÉNEMENTS (Actions) → BLoC → ÉTATS (Résultats) → UI
```

**Événements (ce que l'utilisateur fait) :**
```dart
class CheckAuthStatus extends AuthEvent {}  // "Est-ce que je suis connecté ?"
class SignInWithGoogle extends AuthEvent {} // "Je veux me connecter avec Google"
class SignOut extends AuthEvent {}          // "Je veux me déconnecter"
```

**États (ce qui se passe) :**
```dart
AuthInitial()        // État de départ
AuthLoading()        // "Patience, ça charge..."
AuthAuthenticated()  // "✅ Connecté !"
AuthUnauthenticated() // "❌ Pas connecté"
AuthError()          // "⚠️ Erreur : message"
```

**Analogie :** Le BLoC est comme un chef d'orchestre :
- Il reçoit les demandes (Événements)
- Il travaille (appelle Firebase)
- Il annonce le résultat (États)
- L'UI s'adapte automatiquement

---

## 🚀 Comment ça marche ? (Pas à pas)

### Étape 1 : Démarrage de l'application

**Fichier : `main.dart`**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Démarre Firebase
  runApp(const SchoolTrackApp());
}
```

**Fichier : `main.dart` (suite)**
```dart
BlocProvider<AuthBloc>(
  create: (_) => AuthBloc(
    repository: AuthRepositorySimpleImpl()
  )..add(const CheckAuthStatus()),  // ✅ Vérifie la session au démarrage
),
```

---

### Étape 2 : Vérification de session

**Fichier : `auth_bloc_simple.dart`**
```dart
Future<void> _onCheckAuthStatus(...) async {
  emit(const AuthLoading());  // Affiche le chargement
  
  try {
    final user = await _repository.getCurrentUser();
    
    if (user != null) {
      emit(AuthAuthenticated(user));  // ✅ Utilisateur trouvé
    } else {
      emit(const AuthUnauthenticated());  // ❌ Pas connecté
    }
  } catch (e) {
    emit(AuthError('Erreur : ${e.toString()}'));
  }
}
```

---

### Étape 3 : Affichage de la page de connexion

**Fichier : `splash_page.dart`**
```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      // ✅ Connecté → Dashboard
      _navigateByRole(context, state);
    } else if (state is AuthUnauthenticated) {
      // ❌ Pas connecté → Login
      Navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage())
      );
    }
  },
  child: // ... UI du splash screen
)
```

---

### Étape 4 : Connexion avec Google

**Fichier : `login_page.dart`**
```dart
// Quand l'utilisateur clique sur le bouton Google :
ElevatedButton(
  onPressed: () {
    context.read<AuthBloc>().add(const SignInWithGoogle());
  },
  child: Text('Se connecter avec Google'),
)
```

---

### Étape 5 : Traitement de la connexion

**Fichier : `auth_bloc_simple.dart`**
```dart
Future<void> _onSignInWithGoogle(...) async {
  emit(const AuthLoading());  // Affiche le chargement
  
  try {
    final user = await _repository.signInWithGoogle();
    emit(AuthAuthenticated(user));  // ✅ Succès !
  } catch (e) {
    emit(AuthError('Erreur : ${e.toString()}'));  // ❌ Erreur
  }
}
```

---

### Étape 6 : Communication avec Firebase

**Fichier : `auth_repository_simple_impl.dart`**
```dart
Future<AuthUser> signInWithGoogle() async {
  // 1. Ouvrir le sélecteur Google
  final GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();
  
  // 2. Récupérer les tokens
  final GoogleSignInAuthentication googleAuth = 
      await googleAccount.authentication;
  
  // 3. Créer le credential Firebase
  final OAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  
  // 4. Connecter avec Firebase
  final UserCredential userCredential = 
      await _firebaseAuth.signInWithCredential(credential);
  
  // 5. Créer l'objet AuthUser
  final authUser = AuthUser(
    id: firebaseUser.uid,
    email: firebaseUser.email ?? '',
    name: firebaseUser.displayName ?? 'Utilisateur',
    photoUrl: firebaseUser.photoURL ?? '',
  );
  
  // 6. Sauvegarder dans Firestore
  await _saveUserToFirestore(authUser);
  
  return authUser;
}
```

---

### Étape 7 : Navigation vers le Dashboard

**Fichier : `login_page.dart` ou `splash_page.dart`**
```dart
if (state is AuthAuthenticated) {
  // L'utilisateur est connecté, on va au Dashboard
  Navigator.pushReplacement(
    MaterialPageRoute(builder: (_) => const ProfilePage())
  );
}
```

---

## 🎨 Interface Utilisateur

### Splash Page (Écran de démarrage)
- Animation du logo SchoolTrack
- Vérification de la connexion internet
- Vérification de la session utilisateur
- Durée : ~1.5 secondes

### Login Page (Page de connexion)
- Header avec gradient bleu
- Logo de l'application
- Bouton "Connexion avec Google"
- Indicateur de chargement pendant la connexion
- Gestion des erreurs avec SnackBar

### Dashboard (Page d'accueil)
- Affichage du nom de l'utilisateur
- Affichage de l'ID utilisateur
- Bouton de déconnexion

---

## 🔧 Configuration Firebase

### 1. Créer un projet Firebase
1. Aller sur [Firebase Console](https://console.firebase.google.com/)
2. Créer un nouveau projet
3. Ajouter les applications (Android, iOS, Web)

### 2. Activer les services
- **Authentication** → Sign-in method → Google (activé)
- **Firestore Database** → Créer la base de données
- **Storage** (optionnel, pour les fichiers)

### 3. Télécharger les fichiers de configuration
- Android : `google-services.json`
- iOS : `GoogleService-Info.plist`
- Web : Copier les variables dans `firebase_options.dart`

### 4. Structure Firestore

**Collection : `users`**
```
users/
  {uid}/
    ├─ id: "abc123..."
    ├─ email: "user@gmail.com"
    ├─ name: "Marie Curie"
    ├─ photoUrl: "https://..."
    ├─ createdAt: Timestamp
```

---

## 🧪 Tester l'Authentification

### Test 1 : Vérifier la compilation
```bash
flutter pub get
flutter analyze
```

### Test 2 : Lancer l'application
```bash
flutter run
```

### Test 3 : Tester la connexion Google
1. Lancer l'application
2. Cliquer sur "Connexion avec Google"
3. Sélectionner un compte Google
4. Vérifier que le Dashboard s'affiche

### Test 4 : Tester la persistance
1. Se connecter avec Google
2. Fermer l'application
3. Rouvrir l'application
4. Vérifier que l'utilisateur est toujours connecté

### Test 5 : Tester la déconnexion
1. Être connecté sur le Dashboard
2. Cliquer sur "Se déconnecter"
3. Vérifier le retour à la page de login

---

## 🐛 Dépannage (Problèmes courants)

### Problème 1 : "Firebase not initialized"
**Solution :** Vérifier que `Firebase.initializeApp()` est bien appelé dans `main.dart`

### Problème 2 : "Google Sign-In not working"
**Solution :** 
- Vérifier que Google Sign-In est activé dans Firebase Console
- Vérifier les SHA-1/SHA-256 pour Android
- Vérifier le bundle ID pour iOS

### Problème 3 : "User not found in Firestore"
**Solution :** C'est normal la première fois. Le système crée automatiquement le profil.

### Problème 4 : "Permission denied"
**Solution :** Vérifier les règles Firestore :
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## 📚 Concepts à Approfondir

### 1. BLoC Pattern
- **Events** : Actions de l'utilisateur
- **States** : États de l'application
- **Bloc** : Transforme Events en States

### 2. Repository Pattern
- **Interface** : Définit WHAT (quoi faire)
- **Implémentation** : Définit HOW (comment faire)
- **Avantage** : Facile de changer Firebase → Supabase plus tard

### 3. Firebase Auth
- Gestion des sessions
- Tokens JWT
- Persistance automatique

### 4. Firestore
- Base de données NoSQL
- Structure : Collections → Documents → Fields
- Temps réel avec Streams

---

## 🎓 Pour les Débutants

### Par où commencer ?

1. **Lire ce guide** ✅ (Vous y êtes !)
2. **Comprendre le flux** : Utilisateur → UI → BLoC → Repository → Firebase
3. **Tester l'application** : Faire fonctionner la connexion Google
4. **Explorer le code** : Lire les commentaires dans chaque fichier
5. **Modifier** : Changer les couleurs, les textes, etc.

### Questions à se poser

- ❓ Que se passe-t-il quand l'utilisateur clique sur le bouton Google ?
  → Réponse : Un événement `SignInWithGoogle` est envoyé au BLoC

- ❓ Pourquoi utiliser un Repository ?
  → Réponse : Pour séparer la logique métier de Firebase. Si on change Firebase, on modifie seulement le Repository.

- ❓ C'est quoi un State ?
  → Réponse : C'est l'état de l'authentification (connecté, pas connecté, chargement, erreur)

- ❓ Pourquoi utiliser BLoC ?
  → Réponse : Pour organiser le code. Le BLoC gère toute la logique, l'UI affiche juste ce que le BLoC dit.

---

## 🚀 Prochaines Étapes

### Niveau 1 : Comprendre (Maintenant)
- [x] Lire ce guide
- [x] Comprendre le flux d'authentification
- [x] Tester la connexion Google

### Niveau 2 : Personnaliser (1-2 jours)
- [ ] Changer les couleurs de l'application
- [ ] Modifier les textes (français → anglais, etc.)
- [ ] Ajouter un logo personnalisé
- [ ] Changer le nom de l'application

### Niveau 3 : Étendre (1 semaine)
- [ ] Ajouter l'authentification email/mot de passe
- [ ] Créer une page d'inscription
- [ ] Ajouter la réinitialisation de mot de passe
- [ ] Gérer les rôles (admin, parent, élève)

### Niveau 4 : Maîtriser (1 mois)
- [ ] Ajouter d'autres features (élèves, classes, notes)
- [ ] Implémenter les tests unitaires
- [ ] Optimiser les performances
- [ ] Déployer sur les stores

---

## 📞 Support

### Documentation officielle
- [Flutter](https://flutter.dev/docs)
- [Firebase](https://firebase.google.com/docs)
- [BLoC](https://bloclibrary.dev/)

### Communauté
- [Flutter France](https://flutterfrance.fr/)
- [Discord Flutter](https://discord.gg/flutter)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

---

## ✅ Checklist de Vérification

Avant de déployer, vérifiez :

- [ ] Firebase est correctement configuré
- [ ] Google Sign-In est activé dans Firebase Console
- [ ] Les fichiers de configuration sont présents
- [ ] L'application compile sans erreur
- [ ] La connexion Google fonctionne
- [ ] La déconnexion fonctionne
- [ ] La persistance de session fonctionne
- [ ] La gestion hors-ligne fonctionne
- [ ] Les règles Firestore sont sécurisées
- [ ] L'UI est responsive (mobile + tablette)

---

## 🎉 Félicitations !

Vous avez maintenant une application Flutter avec :
- ✅ Authentification Google fonctionnelle
- ✅ Architecture Clean et maintenable
- ✅ Code simplifié et commenté
- ✅ Gestion d'état avec BLoC
- ✅ Firebase intégré

**Bon développement ! 🚀**