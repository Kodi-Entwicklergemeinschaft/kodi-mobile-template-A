# Kodi Mobile

<!-- kodi-badges -->
[![Lizenz: EUPL-1.2](https://img.shields.io/badge/Lizenz-EUPL%201.2-blue.svg)](LICENSE) ![Open Source](https://img.shields.io/badge/Open%20Source-Ja-brightgreen.svg) ![Smart City](https://img.shields.io/badge/Smart%20City-Kommunal-orange.svg) ![Sprache](https://img.shields.io/badge/Sprache-Dart-informational.svg) ![KODI](https://img.shields.io/badge/KODI-Entwicklergemeinschaft-blueviolet.svg)
<!-- /kodi-badges -->

A Flutter mono-repository powering **Kodi** — a city services and citizen app for the city in Germany. The repository is structured to support scalable multi-project development through shared local packages.

> _Template A reference application — open-sourced from **KODI-Kommunen-Digital**. Licensed under the [EUPL-1.2](LICENSE)._

---

## Table of Contents

- [Project Structure](#project-structure)
- [Applications](#applications)
  - [Kodi](#kodi)
- [Shared Packages](#shared-packages)
- [Architecture](#architecture)
- [Environments & Flavors](#environments--flavors)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Firebase Setup](#firebase-setup)
  - [Android Signing Setup](#android-signing-setup)
  - [Environment Configuration](#environment-configuration)
- [Running the App](#running-the-app)
- [Building for Release](#building-for-release)
- [License](#license)

---

## Project Structure

```
kodi-mobile/
├── projects/
│   └── kodi/               # Kodi app (Flutter)
└── packages/
    ├── common_components/  # Shared UI widgets & extensions
    ├── local_storage/      # Encrypted local preferences
    ├── locale/             # Localisation / i18n
    ├── network/            # Dio HTTP client wrapper
    ├── scaling_dep/        # Responsive scaling utilities
    ├── shared_dependencies/# Shared Flutter package re-exports
    └── theme/              # App theme, colours & typography
```

---

## Applications

### Kodi

| Property        | Value                     |
|-----------------|---------------------------|
| Version         | 1.0.4+1                   |
| Flutter SDK     | ^3.8.0                    |
| Dart SDK        | ^3.8.0                    |
| Platforms       | Android, iOS              |

A citizen-facing mobile app for the city of Germany. It provides access to city services, local listings, events, maps, and account management.

**Main screens:**

| Module           | Screens                                                   |
|------------------|-----------------------------------------------------------|
| Onboarding       | Splash, Welcome                                           |
| Auth             | Login, Register, Forgot Password, Change Password, User Type Selection |
| Dashboard        | Home, Services (Search), Events (Calendar), Account       |
| Listings         | Categories, Listings, Events, Favourites, Global Search   |
| City             | City info & map                                           |
| User             | Profile, Account, Terms & Conditions                      |

---

## Shared Packages

All packages live under `packages/` and are referenced as local path dependencies.

| Package               | Description                                                                 |
|-----------------------|-----------------------------------------------------------------------------|
| `common_components`   | Reusable widgets (animations, shimmer, slide transitions), form validation, and Dart extensions |
| `local_storage`       | Encrypted `SharedPreferences` wrapper with a clean `PreferenceManager` interface |
| `locale`              | Localisation support — `AppLocalization`, translations provider, locale controller |
| `network`             | Dio-based HTTP client factory with interceptors, error models, and logging  |
| `scaling_dep`         | Responsive scaling helpers for mobile and tablet screen sizes               |
| `shared_dependencies` | Re-exports of common Flutter dependencies (Riverpod, GoRouter, etc.) to keep project pubspec files lean |
| `theme`               | App colours, typography (Raleway + Google Fonts), and theme configuration   |

---

## Architecture

- **State management** — [Riverpod](https://riverpod.dev/) (`flutter_riverpod`)
- **Navigation** — [GoRouter](https://pub.dev/packages/go_router)
- **Networking** — [Dio](https://pub.dev/packages/dio) via the `network` package
- **Local storage** — Encrypted `SharedPreferences` via the `local_storage` package
- **Push notifications** — Firebase Cloud Messaging (`firebase_messaging`)
- **Maps** — `flutter_map` + `latlong2`
- **Geolocation** — `geolocator`
- **In-app browser** — `flutter_inappwebview`
- **Font** — Raleway (Regular, Bold, ExtraBold, Thin, ExtraLight — with italic variants)

The app follows a **feature-first** folder layout:

```
projects/kodi/lib/
├── feat/
│   ├── auth/
│   ├── base_UI/
│   ├── city/
│   ├── dashboard/
│   ├── discover/
│   ├── home/
│   ├── intro/
│   ├── listings/
│   ├── splash/
│   └── user/
└── utils/
    ├── env_config.dart     # Environment & Firebase config
    ├── routing/            # GoRouter routes
    └── ...
```

Each feature module contains `data/` (models + repositories), `controller/` (Riverpod notifiers + states), and `presentation/` (screens + widgets).

---

## Environments & Flavors

The app supports two environments, each mapped to an Android product flavor:

| Environment | Android Flavor | App Name     | Signing       |
|-------------|----------------|--------------|---------------|
| Staging     | `stage`        | `kodi-stage` | Debug keystore |
| Production  | `prod`         | `kodi`       | Release keystore (`key.properties`) |

Environment selection happens at app bootstrap via `EnvironmentConfig.setEnvironment(AppEnvironment.stage)` in `main_stage.dart` / `main_prod.dart`. Each environment has its own:

- **Base URL** — configured in `projects/kodi/lib/utils/env_config.dart`
- **Firebase project** — separate `GoogleService-Info.plist` / `google-services.json` per environment, referenced through `firebase_options/stage/` and `firebase_options/prod/`

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) **≥ 3.8.0**
- Dart SDK **≥ 3.8.0** (bundled with Flutter)
- Android Studio or Xcode (for platform builds)
- A Firebase project for both staging and production

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd kodi-mobile

# Install dependencies for the Kodi app
cd projects/kodi
flutter pub get
```

The shared packages are resolved automatically as local path dependencies — no separate `pub get` is required for them.

### Firebase Setup

1. Create two Firebase projects (or two apps within one project) — one for staging, one for production.
2. Download the config files and place them at:

**Android:**
```
projects/kodi/android/app/google-services.json          # staging
projects/kodi/android/app/google-services-prod.json     # production (rename as needed per flavor config)
```

**iOS:**
```
projects/kodi/ios/Runner/GoogleService-Info.plist        # staging
projects/kodi/ios/Runner/GoogleService-Info-Prod.plist   # production (rename as needed per scheme)
```

3. The app picks up the correct Firebase options at runtime based on `EnvironmentConfig.firebaseOptions`.

### Android Signing Setup

For the `prod` flavor a keystore is required. Create a `key.properties` file at `projects/kodi/android/key.properties`:

```properties
keyAlias=<your-key-alias>
keyPassword=<your-key-password>
storeFileProd=<absolute-path-to-your.jks>
storePassword=<your-store-password>
```

> This file is **not committed** to version control. Keep it out of source control.

### Environment Configuration

Open `projects/kodi/lib/utils/env_config.dart` and replace the placeholder base URLs:

```dart
case AppEnvironment.stage:
  return "https://your-staging-api.example.com";   // ← replace
case AppEnvironment.prod:
  return "https://your-production-api.example.com"; // ← replace
```

Also update the Android package name in `projects/kodi/android/app/build.gradle.kts`:

```kotlin
namespace = "com.your.package.name"
// ...
applicationId = "com.your.package.name"
```

And in `projects/kodi/android/app/src/main/kotlin/.../MainActivity.kt`:

```kotlin
package com.your.package.name
```

---

## Running the App

```bash
cd projects/kodi

# Staging (debug)
flutter run --flavor stage -t lib/main_stage.dart

# Production (debug)
flutter run --flavor prod -t lib/main_prod.dart
```

---

## Building for Release

**Android APK:**
```bash
cd projects/kodi

# Staging
flutter build apk --flavor stage -t lib/main_stage.dart

# Production
flutter build apk --flavor prod -t lib/main_prod.dart --release
```

**Android App Bundle:**
```bash
flutter build appbundle --flavor prod -t lib/main_prod.dart --release
```

**iOS:**
```bash
flutter build ipa --flavor prod -t lib/main_prod.dart --release
```

---

## License

This project is licensed under the **European Union Public Licence (EUPL) v1.2**.  
See the [LICENSE](LICENSE) file in this repository, or the [EUPL licence text](https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12) for full details.