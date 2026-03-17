# Contribuer à Speak For Me 🤝

Merci de vous intéresser à **Speak For Me** ! Nous apprécions grandement l'aide de la communauté pour rendre cette application encore plus amusante et fiable (pour rire).

## 🚀 Par où commencer ?

1.  **Parcourir les issues** : Cherchez les issues marquées "good first issue" ou "help wanted" pour trouver un point de départ.
2.  **Tester l'application** : Tentez de reproduire des bugs ou trouvez des problèmes d'UI/UX.
3.  **Proposer des idées** : Ouvrez une nouvelle issue pour discuter d'une nouvelle fonctionnalité avant de commencer à coder.

## 🛠 Environnement de Développement

### Prérequis

*   [Flutter SDK](https://flutter.dev/docs/get-started/install) (version stable recommandée)
*   Dart SDK (inclus avec Flutter)
*   Un simulateur iOS/Android ou un appareil physique.

### Installation

1.  **Cloner le dépôt** :
    ```bash
    git clone https://github.com/Narlex26/Speak-For-Me.git
    cd Speak-For-Me
    ```

2.  **Installer les dépendances** :
    ```bash
    flutter pub get
    ```

3.  **Lancer l'application** :
    ```bash
    flutter run
    ```

## 📝 Bonnes Pratiques de Code

*   **Style** : Nous suivons les recommandations standard de Flutter (`flutter_lints`). Assurez-vous que votre éditeur (VS Code ou Android Studio) est configuré pour formater le code automatiquement à la sauvegarde (`dart format`).
*   **Architecture** : Respectez l'architecture existante expliquée dans [`ARCHITECTURE.md`](ARCHITECTURE.md). Si vous ajoutez une nouvelle fonctionnalité, créez un nouveau dossier dans `lib/features/`.
*   **Tests** : Ajoutez des tests unitaires ou des tests de widget si possible, surtout pour la logique métier.

## 🔄 Soumettre une Pull Request (PR)

1.  **Créer une branche** : Créez une nouvelle branche pour votre fonctionnalité ou correction de bug.
    ```bash
    git checkout -b feature/ma-super-feature
    # ou
    git checkout -b fix/probleme-critique
    ```

2.  **Commiter vos changements** : Faites des commits atomiques et descriptifs.
    ```bash
    git commit -m "feat: ajoute la traduction pour les perruches"
    ```

3.  **Tester** : Vérifiez que l'application compile et fonctionne comme prévu avant de pousser.

4.  **Pousser et ouvrir la PR** : Poussez votre branche et ouvrez une Pull Request sur GitHub. Décrivez clairement vos changements.

## 🐛 Rapporter un Bug

Si vous trouvez un bug, veuillez créer une issue en incluant :
*   Les étapes pour reproduire le problème.
*   Le comportement attendu vs le comportement actuel.
*   Des captures d'écran ou vidéos si pertinent.
*   Votre environnement (OS, version Flutter, appareil).

Merci pour votre contribution ! 🎉

