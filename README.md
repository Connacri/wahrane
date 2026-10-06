# Wahrane

Application Flutter (Android/iOS/Web) de petites annonces et de réservation d'hôtels pour la région d'Oran (Algérie).

## Fonctionnalités

- Authentification Firebase (e-mail/mot de passe, Google Sign-In, vérification e-mail)
- Rôles utilisateur (admin / utilisateur public)
- Fil d'actualité type Instagram (posts, likes, commentaires, upload)
- Catalogue hôtelier : chambres, disponibilités, réservation
- Annonces (listings) type Ouedkniss
- Notifications FCM
- UI dark, police Oswald, support fr/en

## Stack

- Flutter / Dart
- Firebase : Auth, Firestore, Realtime Database, Storage, Messaging, Analytics
- Google Sign-In, OpenStreetMap (flutter_map), image_picker, video_player

## Développement

```bash
flutter pub get
flutter run
```

Analyse statique :

```bash
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter test
```

## Builds de production

Produits uniquement par GitHub Actions (`.github/workflows/build.yml`) à chaque push sur `master`/`main` :

- `app-release.apk` (signé)
- `app-release.aab` (signé)

Secrets GitHub requis : `KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`.

## Structure

```
lib/
  main.dart
  features/
    auth/        # pages de connexion, inscription, Google Sign-In
    home/        # fil d'actualité, profils, upload, pages admin
    hotel/       # réservation, chambres, graphiques
    listings/    # annonces
```

## CI

[![CI Build](https://github.com/Connacri/wahrane/actions/workflows/build.yml/badge.svg)](https://github.com/Connacri/wahrane/actions/workflows/build.yml)
