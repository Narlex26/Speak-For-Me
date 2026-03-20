# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run on a specific device
flutter run -d <device-id>

# List available devices
flutter devices

# Analyze code (lint)
flutter analyze

# Format code
dart format lib/

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Build APK (Android)
flutter build apk

# Build for iOS
flutter build ios
```

## Architecture

**Speak for Me** is a Flutter app (Material 3) that pretends to "translate" babies and animals. All translation output is pre-written humorous phrases — no real audio recording or AI processing occurs.

### Feature-First + Clean Architecture

Code is organized by feature under `lib/features/`, each following a layered structure:

```
lib/features/<feature>/
  data/datasources/   # Services (no repos/models in this simple app)
  domain/entities/    # Plain Dart entities
  presentation/
    pages/            # Full screens
    widgets/          # Feature-specific widgets
```

Shared code lives in `lib/core/widgets/`.

### Feature Map & Data Flow

The app has two screens connected by `Navigator.push`:

1. **`specimen_selection`** — Home screen. Displays profile cards from `Profile.getAllProfiles()`. Each `Profile` entity holds colors, icon, name, and per-profile `analysisMessages`.

2. **`translation_generator`** — Main screen (`TranslationPage`). Receives a `Profile` and orchestrates the fake translation flow via a `TranslationState` enum (`idle → recording → analyzing → result`). Instantiates three services directly:
   - `AudioService` — haptic feedback only (no real mic access)
   - `TranslationService` — picks a random phrase from `TranslationPhrases` by `ProfileType`
   - `TtsService` — wraps `flutter_tts`, configured for French (`fr-FR`) at slow rate/low pitch for comic effect

### Expert Mode

A toggle (science icon) on `TranslationPage` enables "Expert Mode", which overlays fake `SpectralGraphWidget` and `TechnicalDataWidget` on top of the recording/analysis views, and shows `ExpertResultWidget` below the translation result. All data is simulated.

### Adding a New Profile

1. Add a value to the `ProfileType` enum in `lib/features/specimen_selection/domain/entities/specimen.dart`
2. Add a `Profile(...)` entry in `Profile.getAllProfiles()`
3. Add phrases for the new type in `lib/features/translation_generator/data/datasources/translation_phrases.dart`

### State Management

Uses plain `StatefulWidget` with `setState`. No external state management library.

## Workflow — Feature branches

Branch naming convention: `feature/<N>-<short-description>`
where `<N>` is the feature number from the README status table (global unique numbering, 1–22).

Examples: `feature/10-responsive-ui`, `feature/12-historique`, `feature/18-favoris`

**When creating a feature branch**, always update the corresponding row in `README.md`:
- Set status to `🟡 En cours` when starting work
- Set status to `✅ Terminé` when the feature is complete

The README status table is under `## 🗺️ État d'avancement`. Find the row matching `| N |` and update the status column.
