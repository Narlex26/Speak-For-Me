import '../../../specimen_selection/domain/entities/specimen.dart';

class TranslationPhrases {
  static const List<String> prohibitedWords = [
    'merde',
    'putain',
    'con',
  ];

  static const Map<ProfileType, List<String>> phrases = {
    ProfileType.baby: [
      "Je refuse catégoriquement de dormir. La nuit est une construction sociale.",
      "Ces légumes verts sont une attaque personnelle contre ma dignité.",
      "Je pleure non pas parce que j'ai faim, mais parce que l'univers est vaste et indifférent.",
      "Pourquoi me mettez-vous des chaussettes ? Mes pieds aspirent à la liberté.",
      "Ce hochet représente le cycle sans fin de l'existence.",
      "J'ai vu le fond de mon biberon. C'est le néant.",
      "La purée de carottes est une métaphore de la condition humaine.",
      "Je ne veux pas faire dodo. Descartes ne dormait que 4 heures.",
      "Mon doudou comprend ma souffrance existentielle.",
      "Pourquoi suis-je petit ? C'est une question que Sartre n'a jamais résolue.",
      "Les épinards sont une conspiration des parents.",
      "Je pleure donc je suis.",
      "Cette couche est une prison pour mon âme libre.",
      "Le lait maternel, c'est bien. Mais avez-vous essayé de comprendre Nietzsche ?",
      "Mes premiers mots seront 'Non' par principe philosophique.",
    ],
    ProfileType.dog: [
      "CROQUETTES ! CROQUETTES ! CROQUETTES ! C'EST L'HEURE DES CROQUETTES ?!",
      "Le facteur est clairement un agent du chaos. Je protège cette maison.",
      "Tu es parti 5 minutes. J'ai cru que tu ne reviendrais JAMAIS.",
      "Cette balle... c'est ma raison de vivre. Lance-la. LANCE-LA !",
      "Je t'aime. Tu es le meilleur humain. Je t'aime. Donne-moi ton sandwich.",
      "Le chat me regarde bizarrement. Il complote quelque chose.",
      "Promenade ? PROMENADE ?! TU AS DIT PROMENADE ?!",
      "J'ai reniflé 47 poteaux aujourd'hui. Journée productive.",
      "Ce canapé est à moi. J'ai mis mes poils dessus, c'est officiel.",
      "Le vétérinaire est un traître. Je m'en souviendrai.",
      "ÉCUREUIL ! ÉCUREUIL ! Oh... c'était une feuille.",
      "Ta main sur ma tête, c'est le paradis. Ne t'arrête jamais.",
      "J'ai aboyé sur mon reflet. Il avait l'air suspect.",
      "Ce os en plastique n'a AUCUN goût. Je suis déçu.",
      "Je dors 14 heures par jour parce que t'aimer, c'est épuisant.",
    ],
    ProfileType.cat: [
      "Tu m'as caressé trois fois. La limite était deux. Prépare-toi.",
      "Je renverse ce verre par pur nihilisme.",
      "La domination mondiale avance bien. Phase 2 en cours.",
      "Tu travailles ? Dommage. Mon derrière doit être sur ton clavier.",
      "Cette plante devait mourir. C'était écrit.",
      "Je te fixe non pas par amour, mais pour évaluer ta faiblesse.",
      "3h du matin est l'heure PARFAITE pour courir partout.",
      "Ce carton vide est mon nouveau royaume. Incline-toi.",
      "Tu m'appelles ? Je t'ignore. C'est le protocole.",
      "Les croquettes sont acceptables. Mais où est le saumon frais ?",
      "Je fais tomber tes affaires car elles offensent mon esthétique.",
      "Ce ronronnement n'est pas de l'affection. C'est de la manipulation.",
      "L'humain pense être le maître. Adorable.",
      "Je t'ai offert un oiseau mort. C'est de l'ART.",
      "Ta présence est tolérée. Pour l'instant.",
    ],
    ProfileType.goldfish: [
      "Tiens, un château !",
      "Oh ! Un château !",
      "C'est nouveau, ce château ?",
      "...",
      "Glou glou.",
      "Où suis-je ?",
      "Waouh ! Un château !",
      "J'ai faim... je crois ?",
      "Ce château est magnifique !",
      "Bulle.",
      "Attends, qui es-tu ?",
      "OH ! Un château !",
      "Je nage donc je suis... je crois.",
      "Cette eau a un goût de... eau.",
      "Bonjour le châ... qu'est-ce que je disais ?",
    ],
  };

  /// Phrases « légendaires » ultra-rares (easter eggs, ~1% de chance).
  /// Volontairement méta : elles brisent le 4e mur pour récompenser la chance.
  /// Texte gardé « propre » (sans emoji) car il est aussi lu par le TTS et partagé.
  static const List<String> easterEggs = [
    "Félicitations, tu viens de déclencher une traduction légendaire. Statistiquement, tu aurais dû jouer au loto aujourd'hui.",
    "Entre nous : personne ne traduit vraiment quoi que ce soit. Mais le spectacle est joli, non ?",
    "Erreur 1 pour cent : pensée trop profonde pour être traduite. Réessaie dans une autre vie.",
    "Une comète traverse le ciel. L'animal fait un vœu. C'était toi, son vœu.",
    "Tu fais partie des un pour cent les plus chanceux. Profites-en, ça ne durera pas.",
    "Mode légendaire activé. Cette phrase n'apparaît qu'une fois sur cent. Encadre-la.",
    "L'animal a brièvement atteint l'illumination, puis a oublié pourquoi il était entré dans la pièce.",
    "Cette traduction est si rare que même nous, on est surpris de la voir.",
  ];
}

