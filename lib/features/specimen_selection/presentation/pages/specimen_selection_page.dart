import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_for_me/features/specimen_selection/domain/entities/specimen.dart';
import 'package:speak_for_me/features/specimen_selection/presentation/widgets/specimen_card.dart';
import 'package:speak_for_me/features/specimen_selection/presentation/widgets/specimen_header.dart';
import 'package:speak_for_me/features/specimen_selection/presentation/widgets/specimen_section_title.dart';
import 'package:speak_for_me/features/translation_generator/presentation/pages/translation_page.dart' as trans;
import 'package:speak_for_me/features/favorites/presentation/pages/favorites_page.dart';
import 'package:speak_for_me/features/statistics/presentation/pages/statistics_page.dart';
import 'package:speak_for_me/features/history/presentation/pages/history_page.dart';
import 'package:speak_for_me/main.dart';

class SpecimenSelectionPage extends StatelessWidget {
  const SpecimenSelectionPage({super.key});

  void _toggleTheme(BuildContext context) {
    final notifier = ThemeController.of(context);
    notifier.value = switch (notifier.value) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.dark,
    };
  }

  @override
  Widget build(BuildContext context) {
    final profiles = Profile.getAllProfiles();
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [cs.surface, cs.surfaceContainerHighest],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        color: const Color(0xFF667EEA),
                      ),
                      tooltip: isDark ? 'Mode clair' : 'Mode sombre',
                      onPressed: () => _toggleTheme(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.history, color: Color(0xFF667EEA)),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const HistoryPage())),
                    ),
                    IconButton(
                      icon: const Icon(Icons.bar_chart_rounded, color: Color(0xFF667EEA)),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const StatisticsPage())),
                    ),
                  ],
                ),
              ),
              const SpecimenHeader(),
              const SizedBox(height: 40),
              const SpecimenSectionTitle(),
              const SizedBox(height: 24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final profile = profiles[index];
                      return SpecimenCard(
                        profile: profile,
                        onTap: () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                trans.TranslationPage(profile: profile),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.1),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOut,
                                    )),
                                    child: child,
                                  ),
                                ),
                            transitionDuration: const Duration(milliseconds: 300),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 80, top: 16, left: 16, right: 16),
                child: Text(
                  '🎭 Pour le fun uniquement',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade500),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FavoritesPage()),
        ),
        backgroundColor: const Color(0xFF667EEA),
        icon: const Icon(Icons.favorite_rounded),
        label: const Text('Mes Favoris'),
      ),
    );
  }
}
