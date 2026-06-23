# Speak for Me 🎭

Une application mobile Flutter humoristique qui "traduit" les bébés et les animaux !

---

## 📱 Concept

**Speak for Me** est un faux traducteur pour bébés et animaux. L'application simule une analyse sonore sophistiquée pour afficher des phrases absurdes et drôles. 100% fiable\* (\*Non.)

---

## 🐾 Profils disponibles

| Profil | Description |
|--------|-------------|
| 👶 **Bébé** | Philosophie existentielle, refus du sommeil et guerre contre les légumes |
| 🐕 **Chien** | Loyauté inconditionnelle, obsession des croquettes et haine du facteur |
| 🐈 **Chat** | Domination mondiale, mépris calculé et jugement silencieux |
| 🐠 **Poisson Rouge** | Mémoire courte et émerveillement répété devant le château |

---

## 🗺️ État d'avancement

> Légende : ✅ Terminé · 🟡 En cours · 🔴 Non commencé

### Must-have

| # | Fonctionnalité | Statut | Notes |
|---|----------------|--------|-------|
| 1 | Sélection du profil (Bébé, Chien, Chat, Poisson Rouge) avec animations | ✅ Terminé | |
| 2 | Interface Material 3 avec dégradés et animations fluides | ✅ Terminé | |
| 3 | Bouton d'enregistrement avec animation de pulsation | ✅ Terminé | |
| 4 | Simulation d'analyse pseudo-scientifique — messages changeants + barre de progression | ✅ Terminé | |
| 5 | Effet Shimmer pendant l'analyse | ✅ Terminé | |
| 6 | Génération aléatoire de phrases par profil | ✅ Terminé | 15 phrases par profil, sélection purement aléatoire |
| 7 | Text-to-Speech voix grave et lente (fr-FR) | ✅ Terminé | `flutter_tts ^4.2.0` — speak / stop uniquement |
| 8 | Feedback haptique au début/fin d'enregistrement | ✅ Terminé | `HapticFeedback` + `SystemSound.click` |
| 9 | Mode Expert — graphe spectral et données techniques simulés | ✅ Terminé | |
| 10 | Interface responsive (Android / iOS) avec thème sombre/clair auto | 🟡 En cours | Détection automatique thème système |
| 11 | Gestion des permissions microphone | 🟡 En cours | Demandé même si micro non utilisé |
| 12 | Historique des traductions avec horodatage + suppression individuelle | ✅ Terminé | SQLite local, 100 entrées affichées, rotation auto à 500 |
| 13 | Partage social vers apps tierces (WhatsApp, Instagram…) | 🔴 Non commencé | Export texte + capture écran avec watermark |

### Nice-to-have

| # | Fonctionnalité | Statut | Notes |
|---|----------------|--------|-------|
| 14 | Effets sonores d'ambiance — sons de laboratoire pendant l'analyse | ✅ Terminé | Renforcement immersion pseudo-scientifique |
| 15 | Personnalisation des réponses — ajout manuel de phrases avec modération automatique | 🔴 Non commencé | Whitelist caractères, filtre côté client |
| 16 | Personnalisation audio — choix voix TTS masculines/féminines | 🔴 Non commencé | |
| 17 | Thèmes visuels — animations de transition sombre/clair | 🔴 Non commencé | Au-delà de la détection auto |
| 18 | Favoris — système d'étoiles avec section dédiée | ✅ Terminé | Colonne SQLite dédiée |
| 19 | Statistiques — compteur par spécimen, phrases favorites, streaks quotidiens | ✅ Terminé | |
| 20 | Easter eggs — phrases rares (1% de probabilité) | 🔴 Non commencé | |
| 21 | Export de l'historique (format texte) | 🔴 Non commencé | |
| 22 | Widgets écran d'accueil iOS/Android | 🔴 Non commencé | Dernière traduction ou bouton accès rapide |

---

## 🛠️ Stack technologique

| Couche | Technologie |
|--------|-------------|
| Mobile / Frontend | Flutter 3.x (sdk: ^3.10.7) |
| Architecture | Feature-First + StatefulWidget / setState |
| UI Design System | Material 3 |
| Phrases humoristiques | Hardcodées dans `translation_phrases.dart` — 15 phrases × 4 profils |
| Synthèse vocale | `flutter_tts ^4.2.0` |
| Icônes | `font_awesome_flutter ^10.8.0` |
| Typographie | `google_fonts ^6.2.1` |
| Effets de chargement | `shimmer ^3.0.0` |

> **Aucun backend.** L'application fonctionne 100% offline. Aucune donnée hébergée externalement.

---

## 🚀 Installation

```bash
flutter pub get
flutter run
```

**Prérequis :** Flutter 3.x (sdk: ^3.10.7)

---

## 📂 Structure du projet

Architecture **Feature-First** par feature (data / domain / presentation).

```
lib/
├── main.dart
├── core/
│   └── widgets/              # Widgets réutilisables (ShimmerLoader)
└── features/
    ├── specimen_selection/   # Sélection du profil
    ├── audio_recording/      # Feedback haptique
    ├── translation_generator/ # Phrases + logique de traduction
    ├── text_to_speech/       # TTS
    ├── expert_mode/          # Graphe spectral et données simulés
    ├── history/              # Non implémenté
    └── sharing/              # Non implémenté
```

Chaque feature suit le pattern : `data/datasources/` → `domain/entities/` → `presentation/pages/` + `widgets/`.

Pour plus de détails, consultez [ARCHITECTURE.md](ARCHITECTURE.md).

---

## 🤝 Contribution

Consultez [CONTRIBUTING.md](CONTRIBUTING.md) pour savoir comment contribuer.
## 📄 Licence

Projet créé pour le fun ! 🎉
