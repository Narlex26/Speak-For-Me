import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/profile.dart';
import '../widgets/profile_card.dart';
import 'translation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profiles = Profile.getAllProfiles();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F9FA),
              Color(0xFFE9ECEF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667EEA).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.record_voice_over_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Speak for Me',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                          ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Le traducteur universel\n(100% fiable*)',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '*Non.',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Qui voulez-vous comprendre ?',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Grid of profiles
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
                      return ProfileCard(
                        profile: profile,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  TranslationScreen(profile: profile),
                              transitionsBuilder:
                                  (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
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
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 300),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              // Footer
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '🎭 Pour le fun uniquement',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

