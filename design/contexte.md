# Contexte Design — Speak For Me

> Fichier de référence design system. Mis à jour à chaque session.
> Dernière mise à jour : 2026-06-23

---

## Vision & Concept Produit

**Speak For Me** est un faux traducteur humoristique pour bébés et animaux. L'app simule une analyse sonore pseudo-scientifique et génère des phrases absurdes. 100% offline, 0% sérieux.

- **Ton** : absurde, satirique, second degré assumé. L'humour est la fonctionnalité principale.
- **Cibles utilisateurs** : grand public, familles, amateurs d'animaux, partage social viral
- **Plateforme** : mobile native (Android / iOS) — portrait uniquement
- **Langue** : français (TTS fr-FR, UI française)
- **Aucun backend** : tout est local (SQLite, SharedPreferences, phrases hardcodées)

### Profils disponibles (4)

| Profil | Couleur primaire | Couleur secondaire | Ton |
|--------|------------------|--------------------|-----|
| Bébé | `#FF9AA2` (rose clair) | `#FFB7B2` (rose saumon) | Philosophie existentielle, refus des légumes |
| Chien | `#8B4513` (brun chocolat) | `#D2691E` (chocolat clair) | Enthousiasme absurde, loyauté maximale |
| Chat | `#6B5B95` (violet moyen) | `#9B8DC3` (lavande) | Mépris calculé, domination mondiale |
| Poisson Rouge | `#FF6B35` (orange vif) | `#FFB347` (orange clair) | Mémoire courte, émerveillement répété |

---

## Design System

### Couleurs

```
-- Couleurs globales (thème app) --
--primary:         #667EEA   (violet-bleu — couleur de marque principale)
--primary-dark:    #764BA2   (violet profond — gradient pair avec --primary)
--bg-light:        #F8F9FA   (blanc cassé — fond de page)
--bg-mid:          #E9ECEF   (gris très clair — gradient de fond, second stop)
--text-primary:    #212529   (quasi-noir — titres)
--text-secondary:  #6C757D   (gris moyen — sous-titres, labels)
--text-muted:      #ADB5BD   (gris clair — mentions légales, disclaimer)
--error:           #FF0000 / Colors.red
--success:         Colors.greenAccent (expert mode uniquement)
--white:           #FFFFFF

-- Couleurs per-profil (dynamiques, passées en paramètre) --
Bébé primary:       #FF9AA2
Bébé secondary:     #FFB7B2
Chien primary:      #8B4513
Chien secondary:    #D2691E
Chat primary:       #6B5B95
Chat secondary:     #9B8DC3
Poisson primary:    #FF6B35
Poisson secondary:  #FFB347

-- Couleurs ponctuelles dans le code --
Colors.deepPurple     → AppBar FavoritesPage (incohérence à corriger)
Colors.redAccent      → bouton favori actif, icône favoris dans TranslationPage
Colors.amber          → icône stats
Colors.orange         → icône streak
blue.shade50 + purple.shade50 → gradient FavoriteCard (incohérence, hors système)
```

**Note design :** Les écrans secondaires (Favoris, Historique, Statistiques) utilisent des couleurs ad hoc (`deepPurple`, `blue.shade50`) non connectées au design system principal. C'est une dette visuelle à corriger lors de leur refonte.

### Typographie

```
Display / Titres :  Poppins (GoogleFonts.poppins)
  — Utilisée sur tous les titres, labels de profil, status text, AppBar
  — Weights utilisés : Bold (700), SemiBold (600), Medium (500)
  — Tailles : 32px (titre hero), 18px (AppBar title, section title), 16px (body)
  — Style spécial : titre "Speak for Me" en gradient shader #667EEA → #764BA2

Corps / Citations :  Merriweather (GoogleFonts.merriweather)
  — Utilisée uniquement dans TranslationResult pour afficher la phrase traduite
  — Weight : Medium (500), taille 20px, line-height 1.5
  — Justification : contraste intentionnel entre le sérieux de la serif et l'absurdité du contenu

Mono / Expert mode : Courier (fontFamily: 'Courier')
  — TechnicalDataWidget et ExpertResultWidget uniquement
  — Renforce l'esthétique "terminal de laboratoire"
  — Taille 10-12px
```

### Spacing (base 8px)

```
xs:  4px
sm:  8px
md:  16px
lg:  24px
xl:  32px
2xl: 48px
3xl: 64px

Padding latéral global : 24px (specimen_selection_page, translation_result)
Padding latéral actions : 24px (_buildResultActions)
Padding AppBar custom :  16px (_buildAppBar)
Grid spacing :           16px (crossAxisSpacing + mainAxisSpacing)
```

### Border Radius

```
sm:   4px   (progress bar, TechnicalDataWidget)
md:   8px   (boutons action dans AppBar, FavoriteCard button)
lg:   12px  (SpectralGraphWidget, ExpertResultWidget, FavoriteCard card)
xl:   16px  (boutons résultat — favorite/play/share, ElevatedButton "Nouvelle traduction")
2xl:  20px  (AddPhraseBottomSheet container)
3xl:  24px  (SpecimenCard, TranslationResult container)
pill: 999px (non encore utilisé explicitement)
```

### Ombres

```
low (subtle) :  boxShadow color 10% opacité, blurRadius 10, offset (0, 4)
               → Boutons AppBar custom (back, add, favorites, expert)

mid (card) :   boxShadow color 20% opacité, blurRadius 10-12, offset (0, 4-6)
               → Boutons résultat (favorite, play, share)
               → FavoriteCard elevation: 4

high (hero) :  boxShadow color 40% opacité, blurRadius 20-12, offset (0, 10-8)
               → Logo cercle header (0xFF667EEA 30%, blur 20, offset (0,10))
               → SpecimenCard (primaryColor 40%, blur 12, offset (0,6))
               → PulsatingButton (color 40%, blur 20, offset (0,8))
               → TranslationResult (color 20%, blur 20, offset (0,10))
               → ElevatedButton "Nouvelle traduction" (color 40%)
```

---

## Composants UI Existants

### SpecimenCard
**Fichier :** `lib/features/specimen_selection/presentation/widgets/specimen_card.dart`
- Grille 2 colonnes, aspect ratio 1:1
- Fond : gradient diagonal `primaryColor → secondaryColor`
- Ombre colorée : `primaryColor` à 40%
- Border radius : 24px
- Contenu : icône FontAwesome dans cercle blanc 20% opacité + label Poppins Bold 18px blanc
- Interaction : InkWell splash blanc 30% + FadeTransition + SlideTransition (300ms) vers TranslationPage

### PulsatingButton
**Fichier :** `lib/features/audio_recording/presentation/widgets/pulsating_button.dart`
- Bouton principal d'enregistrement, circulaire
- État idle : 120×120px, gradient `primaryColor → primaryColor 70%`
- État recording : 100×100px (shrink), gradient rouge `red.shade400 → red.shade600`
- Animation : 2 anneaux concentriques qui pulsent en scale (1.0→1.3) + fade out, durée 1000ms, `Curves.easeOut`
- Ombre : color 40% opacité, blur 20, offset (0,8)

### ShimmerLoader
**Fichier :** `lib/core/widgets/shimmer_loader.dart`
- Affiché pendant l'état `analyzing`
- Shimmer sur icône auto_awesome + texte message d'analyse (baseColor 40%→90%)
- Barre de progression 250px wide, 8px height, avec gradient + shimmer overlay blanc 30%
- Compteur pourcentage en dessous (baseColor, 14px, SemiBold)
- Paramètres : `message`, `baseColor`, `progress` (0.0→1.0)

### TranslationResult
**Fichier :** `lib/features/translation_generator/presentation/widgets/translation_result.dart`
- Card blanche, border radius 24px, border colorée (primaryColor 30%), ombre colorée (primaryColor 20%)
- Animation d'entrée : fade (0→1) + scale (0.8→1.0 elasticOut) + slide up (0.3→0) — 800ms
- Icônes guillemets decoratives (format_quote_rounded, primaryColor 50%)
- Texte en Merriweather 20px, gris.shade800, line-height 1.5
- Margin externe : 48px (très généreux — à évaluer sur petits écrans)

### SpectralGraphWidget (Expert Mode)
**Fichier :** `lib/features/expert_mode/presentation/widgets/spectral_graph_widget.dart`
- Container 150px height, fond noir 80% opacité, border colorée (primaryColor 50%), radius 12px
- 30 barres verticales animées en temps réel (Timer 100ms), hauteur aléatoire lissée
- Label "SPECTRAL ANALYSIS" + badge "LIVE" rouge
- Couleur barres : `primaryColor` à 70%

### TechnicalDataWidget (Expert Mode)
**Fichier :** `lib/features/expert_mode/presentation/widgets/technical_data_widget.dart`
- Container 120px height, fond noir pur, border `Colors.greenAccent`, radius 4px
- Terminal qui défile : logs pseudo-techniques générés toutes les 200ms
- Typo Courier, 10px, vert clair (`Colors.lightGreen`)
- Style : terminal Linux années 80

### ExpertResultWidget (Expert Mode)
**Fichier :** `lib/features/expert_mode/presentation/widgets/expert_result_widget.dart`
- Container fond `Colors.black87`, border colorée (primaryColor 50%), radius 12px
- Affiche des stats simulées : Confidence Score (99.9%), Emotional Vector, Frequency Range, Processing Time
- Valeurs colorées : vert (confiance), orange (émotion), bleu (fréquence), blanc (temps)
- Typo Courier 12px pour les données

### FavoriteCard
**Fichier :** `lib/features/favorites/presentation/widgets/favorite_card.dart`
- Card elevation 4, radius 12px
- Fond : gradient diagonal `blue.shade50 → purple.shade50` (hors design system global)
- Affiche : type profil (gris 12px), texte favori (noir87 16px SemiBold), date relative
- Actions : bouton "Réécouter" full-width (deepPurple), icône close

### AddPhraseBottomSheet
**Fichier :** `lib/features/translation_generator/presentation/widgets/add_phrase_sheet.dart`
- Modal bottom sheet, fond blanc, radius 20px, ombre noire 8%
- Titre en `primaryColor` du profil actif
- TextField multiline (3 lignes), InputDecoration standard
- Bouton submit full-width en `primaryColor`, padding vertical 14px
- Modération automatique : longueur min 5 chars, liste noire, doublons

---

## Écrans Existants

### 1. SpecimenSelectionPage (écran d'accueil)
**Fichier :** `lib/features/specimen_selection/presentation/pages/specimen_selection_page.dart`
**Rôle :** Sélection du profil à traduire

Structure :
- Fond : gradient vertical `#F8F9FA → #E9ECEF`
- Header top-right : icônes History + Statistics (couleur `#667EEA`)
- Logo : cercle gradient `#667EEA → #764BA2` avec icône `record_voice_over_rounded` blanc 40px + ombre
- Titre hero "Speak for Me" en Poppins Bold 32px avec shader gradient
- Sous-titre ironique + mention légale "*Non." en italic gris clair
- Section label avec barre accent gradient verticale (4×24px)
- GridView 2×2 de SpecimenCards (spacing 16px, padding 24px)
- Footer disclaimer "Pour le fun uniquement"
- FAB "Mes Favoris" (couleur `#667EEA`, icône favorite_rounded)
- Padding bottom du footer : 80px (pour clearance du FAB)

Navigation : GridView → TranslationPage (FadeTransition + SlideTransition 300ms)

### 2. TranslationPage
**Fichier :** `lib/features/translation_generator/presentation/pages/translation_page.dart`
**Rôle :** Écran principal de traduction

Fond : gradient vertical du profil actif (primaryColor 10% → secondaryColor 5% → blanc)

AppBar custom (Row) :
- Bouton retour custom (blanc, radius 12, ombre low)
- Titre "Traducteur [Profil]"
- Bouton "+" ajouter phrase
- Bouton favoris (heart border, redAccent)
- Toggle Expert Mode (science icon — fond noir/vert si actif)

4 états via `TranslationState` enum :
- **idle** : PulsatingButton (mic icon) + status "Appuyez pour enregistrer"
- **recording** : PulsatingButton animé (stop icon, rouge) + status "Écoute en cours..."
- **analyzing** : ShimmerLoader + progress bar + messages changeants + status "Traduction en cours"
- **result** : TranslationResult animé + actions (favori / TTS / partage) + bouton "Nouvelle traduction"

Expert Mode (toggle) :
- Pendant recording/analyzing : Stack avec SpectralGraphWidget (top overlay) + TechnicalDataWidget (bottom overlay)
- Pendant result : ExpertResultWidget sous TranslationResult

Actions résultat (Row aligné à droite) :
- Favori (rouge si actif) / TTS replay / Partage
- "Nouvelle traduction" (ElevatedButton centré, 220px wide, primaryColor)

### 3. FavoritesPage
**Fichier :** `lib/features/favorites/presentation/pages/favorites_page.dart`
**Rôle :** Liste des phrases favorites

- AppBar solid `Colors.deepPurple`, titre centré blanc — incohérent avec design system
- 3 états : loading (CircularProgressIndicator deepPurple) / empty state (icône coeur gris) / liste
- ListView de FavoriteCards
- RefreshIndicator deepPurple
- Empty state : icône FontAwesome heart 64px gris, CTA "Retour"

**Dette design :** AppBar hardcodée deepPurple, pas connectée aux couleurs système.

### 4. HistoryPage
**Fichier :** `lib/features/history/presentation/pages/history_page.dart`
**Rôle :** Historique des traductions avec horodatage

- AppBar Material 3 standard (transparente via thème global)
- Actions : export .txt + vider historique (si liste non vide)
- ListView de Cards Material avec Dismissible (swipe left → rouge)
- CircleAvatar avec icône profil + texte traduit (2 lignes max) + date + profil
- Suppression individuelle ou totale (AlertDialog de confirmation)
- Export : fichier .txt partagé ou sauvegardé dans Téléchargements (Android)

**Dette design :** Style generic Material 3, pas de cohérence avec le gradient et les couleurs du design system.

### 5. StatisticsPage
**Fichier :** `lib/features/statistics/presentation/pages/statistics_page.dart`
**Rôle :** Statistiques d'utilisation

- AppBar Material 3 standard
- ListView de 3 Cards (elevation 4) :
  - Streak quotidien (icône feu orange)
  - Compteur favoris (icône étoile amber)
  - Traductions par spécimen (liste texte)

**Dette design :** Style entièrement générique Material 3, aucune identité visuelle. À refondre.

---

## Style Général & Esthétique

### Direction visuelle : "Lab Toy" — Science de pacotille assumée

L'identité visuelle mélange deux registres intentionnellement :
1. **App grand public colorée** : gradients doux, cartes arrondies, animations fluides → sert l'accessibilité et la légèreté
2. **Fausse rigueur scientifique** : terminaux noirs, barres de progression, pourcentages, graphes spectraux → renforce le second degré

### Principes visuels appliqués

- **Gradients partout** : couleur de marque (`#667EEA → #764BA2`) + couleurs per-profil. Jamais de couleur plate pour les éléments hero.
- **Ombres colorées** : les ombres reprennent la couleur de l'élément (pas du noir générique). Crée de la profondeur sans alourdissement.
- **Mode clair dominant** : fond quasi-blanc, app grand public / famille. Mode sombre uniquement dans les widgets Expert Mode (volontaire et délimité).
- **Animations fonctionnelles** : chaque animation porte une information (pulsation = en cours d'écoute, fade+scale = résultat apparu, shimmer = chargement). Pas d'animation décorative gratuite.
- **Responsive portrait-only** : `setPreferredOrientations([portraitUp, portraitDown])` — pas de gestion landscape.

### Transitions & Motion

```
Page → Page :     FadeTransition + SlideTransition vertical (offset 0→0.1)
                  Duration 300ms, Curves.easeOut

TranslationResult : fade (easeOut 0→0.5) + scale elasticOut (0.8→1.0, 0→0.6)
                    + slide up (easeOut, 0→0.5) — Duration 800ms total

Status text :     AnimatedSwitcher 300ms entre états

PulsatingButton : scale 1.0→1.3 + opacity 0.6→0.0, 1000ms, Curves.easeOut, repeat

Progress bar :    AnimatedContainer 300ms (fill continu toutes les 50ms +0.02)
```

---

## Architecture & Contraintes Techniques

```
Framework :     Flutter 3.x (sdk: ^3.10.7)
Design System : Material 3 (useMaterial3: true)
État :          StatefulWidget + setState (pas de BLoC, Riverpod ou Provider)
Police :        Google Fonts via réseau (pas bundlée localement)
Icônes :        Material Icons + FontAwesome Flutter (^10.8.0)
Orientation :   Portrait uniquement (forcé au démarrage)
Offline :       100% — SQLite (sqflite ^2.4.2) + SharedPreferences (^2.2.2)
Audio :         flutter_tts ^4.2.0 (fr-FR, pitch bas, débit lent), audioplayers ^6.1.0 (ambiance)
Seed color :    const Color(0xFF667EEA) → génère le ColorScheme Material 3
```

### Seed Color & Material 3

Le thème principal est généré depuis la seed `#667EEA`. Les composants Material 3 standard (AppBar transparente, Cards, ElevatedButton) héritent de ce ColorScheme. Les couleurs per-profil sont passées manuellement en paramètre dans les widgets custom — elles ne dépendent pas du thème.

### Assets

```
assets/audio/audio_traitement.wav  → son d'ambiance pendant l'analyse
```
Pas d'images, pas de fonts bundlées, pas d'icônes custom SVG.

---

## État d'Avancement des Features (22 au total)

### Terminées (15/22)
| # | Feature |
|---|---------|
| 1 | Sélection profil avec animations |
| 2 | Interface Material 3 gradients + animations |
| 3 | Bouton enregistrement pulsation |
| 4 | Simulation analyse pseudo-scientifique |
| 5 | Shimmer pendant l'analyse |
| 6 | Génération aléatoire phrases (15 par profil) |
| 7 | TTS voix grave fr-FR |
| 8 | Feedback haptique |
| 9 | Mode Expert — graphe + données simulés |
| 11 | Gestion permissions microphone |
| 13 | Partage social (texte + share_plus) |
| 14 | Sons d'ambiance laboratoire |
| 18 | Favoris (SharedPreferences) |
| 19 | Statistiques (streak, par spécimen) |
| 21 | Export historique (.txt) |

### En cours (1/22)
| # | Feature | Notes |
|---|---------|-------|
| 10 | Interface responsive + thème sombre/clair auto | Branch `feature/10-interface-responsive` — détection système |

### Non commencées (6/22)
| # | Feature | Notes design |
|---|---------|--------------|
| 12 | Historique SQLite complet | Page existe, datasource ok — UI à refondre |
| 15 | Personnalisation phrases manuelles | AddPhraseBottomSheet existe mais phrases non persistées |
| 16 | Choix voix TTS | Nécessite un picker UI |
| 17 | Thèmes visuels + transitions dark/light | Au-delà de la détection auto |
| 20 | Easter eggs (1% proba) | Transparent pour l'UX — logique pure |
| 22 | Widgets écran d'accueil iOS/Android | |

---

## Dettes Design Identifiées

1. **Incohérence AppBar** : FavoritesPage utilise `Colors.deepPurple` solid au lieu de l'AppBar transparente + couleur système. À aligner.
2. **FavoriteCard hors système** : gradient `blue.shade50 → purple.shade50` non connecté aux tokens. À remplacer par les couleurs per-profil ou une surface neutre.
3. **Écrans secondaires génériques** : History et Statistics n'ont aucune identité visuelle propre à l'app. Refonte nécessaire pour cohérence.
4. **Feature #10 en cours** : dark mode non implémenté. Toutes les couleurs sont hardcodées en light — pas de variables CSS-style. Quand on implémente le dark mode, prévoir une passe complète sur tous les `Colors.white`, `Colors.grey.shade*`, et fonds hardcodés.
5. **TranslationResult margin 48px** : très généreux, risque de débordement sur petits écrans (iPhone SE, téléphones 5"). À tester et ajuster à 24px si nécessaire.
6. **Phrases custom non persistées** : `AddPhraseBottomSheet` ajoute des phrases en mémoire via `TranslationService._customPhrases` — elles disparaissent à la fermeture de l'app. Feature #15 doit ajouter la persistence SQLite.

---

## Prochains Écrans Prévus

1. **Feature #10 — Dark mode** : implémenter la détection du thème système et les variables de couleur pour chaque mode. Priorité : aligner tous les écrans secondaires sur le design system avant d'ajouter le dark mode.
2. **Refonte HistoryPage** : UI générique → design cohérent avec l'identité de l'app (gradients profil, typographie Poppins, empty state illustré).
3. **Refonte StatisticsPage** : cards génériques → visualisation data avec identité visuelle (barre de progression colorées par profil, streak animé).
4. **Feature #12** : historique SQLite complet avec rotation automatique à 500 entrées.
