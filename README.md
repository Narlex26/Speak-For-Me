# Speak for Me 🎭

Une application mobile humoristique Flutter qui "traduit" les bébés et les animaux !

## 📱 Concept

**Speak for Me** est un faux traducteur pour bébés et animaux. L'application simule une analyse sonore sophistiquée pour afficher des phrases absurdes et drôles. 100% fiable* (*Non.)

## 🐾 Profils disponibles

- **👶 Bébé** - Philosophie existentielle, refus du sommeil et guerre contre les légumes
- **🐕 Chien** - Loyauté inconditionnelle, obsession des croquettes et haine du facteur
- **🐈 Chat** - Domination mondiale, mépris calculé et jugement silencieux
- **🐠 Poisson Rouge** - Mémoire courte et émerveillement répété devant le château

## ✨ Fonctionnalités

- Interface Material 3 moderne avec dégradés et animations fluides
- Bouton d'enregistrement avec animation de pulsation
- Effet Shimmer pendant l'analyse
- Messages de statut changeants ("Analyse des miaulements...", "Décryptage du mépris félin...")
- Text-to-Speech avec voix grave pour un effet comique
- Sons de bip au début et à la fin de l'enregistrement

## 🛠️ Technologies

- Flutter 3.x
- Material 3
- `flutter_tts` - Synthèse vocale
- `font_awesome_flutter` - Icônes
- `google_fonts` - Typographie
- `shimmer` - Effet de chargement
- `audioplayers` - Sons

## 🚀 Installation

```bash
flutter pub get
flutter run
```

## 📂 Structure du projet

```
lib/
├── main.dart
├── data/
│   └── translation_phrases.dart
├── models/
│   └── profile.dart
├── screens/
│   ├── home_screen.dart
│   └── translation_screen.dart
├── services/
│   ├── audio_service.dart
│   ├── translation_service.dart
│   └── tts_service.dart
└── widgets/
    ├── profile_card.dart
    ├── pulsating_button.dart
    ├── shimmer_loader.dart
    └── translation_result.dart
```

## 📄 Licence

Projet créé pour le fun ! 🎉
