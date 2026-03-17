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
- Historique des "traductions" récentes
- Partage des résultats absurdes avec vos amis

## 🛠️ Technologies

- Flutter 3.x
- Material 3
- `flutter_tts` - Synthèse vocale
- `font_awesome_flutter` - Icônes
- `google_fonts` - Typographie
- `shimmer` - Effet de chargement

## 🚀 Installation

```bash
flutter pub get
flutter run
```

## 📂 Structure du projet

L'application suit une architecture **Feature-First**. Pour plus de détails, consultez [ARCHITECTURE.md](ARCHITECTURE.md).

```
lib/
├── core/                   # Code partagé (thème, widgets, utils)
├── features/               # Fonctionnalités par dossier
│   ├── audio_recording/    # Enregistrement audio
│   ├── history/            # Historique
│   ├── sharing/            # Partage
│   ├── specimen_selection/ # Choix du profil
│   ├── text_to_speech/     # Synthèse vocale
│   └── translation_generator/ # Logique de traduction
└── main.dart               # Point d'entrée
```

## 🤝 Contribution

Consultez [CONTRIBUTING.md](CONTRIBUTING.md) pour savoir comment contribuer !

## 📄 Licence

Projet créé pour le fun ! 🎉
