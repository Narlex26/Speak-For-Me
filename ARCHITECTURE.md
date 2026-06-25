# Architecture du Projet Speak For Me

Ce document décrit l'architecture technique du projet **Speak For Me**.

## 🏗 Structure Globale

Le projet suit une architecture **Feature-First** (ou "Package by Feature"), ce qui signifie que le code est organisé par fonctionnalité plutôt que par type technique. Cela permet une meilleure scalabilité et maintenabilité.

En plus de l'organisation par fonctionnalité, chaque feature suit une structure inspirée de la **Clean Architecture** avec une séparation des responsabilités en couches (Data, Domain, Presentation).

### Arborescence des Dossiers

```
lib/
├── core/                   # Code partagé et utilitaires transverses
│   ├── constants/          # Constantes globales (couleurs, dimensions, etc.)
│   ├── database/           # Gestion de la base de données locale (si applicable)
│   ├── error/              # Gestion des erreurs et exceptions
│   ├── theme/              # Thème de l'application (Material 3)
│   ├── utils/              # Fonctions utilitaires
│   └── widgets/            # Widgets réutilisables dans toute l'app
│
├── features/               # Fonctionnalités de l'application
│   ├── audio_recording/    # Enregistrement audio
│   ├── history/            # Historique des traductions
│   ├── sharing/            # Partage de contenu
│   ├── specimen_selection/ # Choix du profil (Bébé, Chien, Chat...)
│   ├── text_to_speech/     # Synthèse vocale
│   └── translation_generator/ # Logique de génération de "traduction"
│
└── main.dart               # Point d'entrée de l'application
```

## 🧩 Détail des Couches par Feature

Chaque fonctionnalité (ex: `specimen_selection`) est généralement divisée en sous-dossiers :

*   **data/** : Gestion des données (API, base de données locale, shared preferences). Contient les `datasources` et les `models` (DTOs).
*   **domain/** : Logique métier pure (entités). *Note: Dans ce projet simple, cette couche peut être allégée.*
*   **presentation/** : Interface utilisateur.
    *   **pages/** : Les écrans complets.
    *   **widgets/** : Les composants graphiques spécifiques à la feature.

## 🛠 Choix Techniques

*   **Framework** : Flutter
*   **Gestion d'État** : `StatefulWidget` (Gestion d'état locale et simple pour cette application).
*   **Navigation** : Navigation standard de Flutter (`Navigator`).
*   **Services** : Les services (Audio, Translation, TTS) sont instanciés directement dans les widgets ou passés en paramètres.

## 📦 Dépendances Clés

Les fonctionnalités principales reposent sur ces packages :

*   **flutter_tts** : Pour la synthèse vocale des traductions.
*   **shimmer** : Pour les effets de chargement visuels.
*   **font_awesome_flutter** : Pour les icônes.
*   **google_fonts** : Pour la typographie personnalisée.

---

Cette structure permet d'ajouter de nouvelles "créatures" ou fonctionnalités (comme un historique, des favoris) sans impacter le reste du code existant.

