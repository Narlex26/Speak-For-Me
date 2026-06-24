import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_for_me/features/specimen_selection/domain/entities/specimen.dart';
import 'package:speak_for_me/features/translation_generator/data/datasources/translation_service.dart';

Future<bool?> showAddPhraseBottomSheet({
  required BuildContext context,
  required Profile profile,
  required TranslationService translationService,
}) {
  var typedPhrase = '';
  final messenger = ScaffoldMessenger.of(context);

  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 12,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(sheetContext).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Theme.of(sheetContext).colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Ajouter une phrase personnalisee',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: profile.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mode ${profile.name}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    onChanged: (value) {
                      typedPhrase = value;
                    },
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Ex: Je suis un chat philosophe.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: () {
                      final phrase = typedPhrase.trim();
                      if (phrase.isEmpty) {
                        messenger.showSnackBar(const SnackBar(
                          content: Text('La phrase ne peut pas etre vide.'),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }

                      final success =
                          translationService.addCustomPhrase(profile.type, phrase);
                      if (!success) {
                        messenger.showSnackBar(const SnackBar(
                          content: Text(
                            'Phrase refusee (doublon, trop courte ou langage inapproprie).',
                          ),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }

                      Navigator.of(sheetContext).pop(true);
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Ajouter la phrase'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: profile.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
