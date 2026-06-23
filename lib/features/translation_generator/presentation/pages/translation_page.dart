import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speak_for_me/features/specimen_selection/domain/entities/specimen.dart';
import 'package:speak_for_me/features/translation_generator/data/datasources/translation_service.dart';
import 'package:speak_for_me/features/text_to_speech/data/datasources/tts_service.dart';
import 'package:speak_for_me/features/audio_recording/data/datasources/audio_service.dart';
import 'package:speak_for_me/features/audio_recording/presentation/widgets/pulsating_button.dart';
import 'package:speak_for_me/core/widgets/shimmer_loader.dart';
import 'package:speak_for_me/features/translation_generator/presentation/widgets/add_phrase_sheet.dart';
import '../widgets/translation_result.dart';
import 'package:speak_for_me/features/expert_mode/presentation/widgets/spectral_graph_widget.dart';
import 'package:speak_for_me/features/expert_mode/presentation/widgets/technical_data_widget.dart';
import 'package:speak_for_me/features/expert_mode/presentation/widgets/expert_result_widget.dart';
import 'package:speak_for_me/features/favorites/presentation/pages/favorites_page.dart';
import 'package:speak_for_me/features/favorites/domain/usecases/favorite_usecases.dart';
import 'package:speak_for_me/features/statistics/data/datasources/statistics_local_datasource.dart';
import 'package:speak_for_me/features/history/data/datasources/history_local_datasource.dart';
import 'package:speak_for_me/features/history/data/models/history_model.dart';

enum TranslationState { idle, recording, analyzing, result }

class TranslationPage extends StatefulWidget {
  final Profile profile;

  const TranslationPage({super.key, required this.profile});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final TranslationService _translationService = TranslationService();
  final TtsService _ttsService = TtsService();
  final AudioService _audioService = AudioService();
  final StatisticsLocalDataSource _statisticsDataSource = StatisticsLocalDataSource();
  final HistoryLocalDataSource _historyDataSource = HistoryLocalDataSource();

  late AddFavoriteUseCase _addFavoriteUseCase;
  late RemoveFavoriteUseCase _removeFavoriteUseCase;
  late IsFavoriteUseCase _isFavoriteUseCase;

  bool _isExpertMode = false;
  bool _isFavorited = false;
  TranslationState _state = TranslationState.idle;
  String _analysisMessage = '';
  String _translatedText = '';
  double _progress = 0.0;
  Timer? _analysisTimer;
  Timer? _progressTimer;
  int _messageIndex = 0;

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
    _initializeFavoritesUseCases();
  }

  Future<void> _initializeFavoritesUseCases() async {
    final prefs = await SharedPreferences.getInstance();
    _addFavoriteUseCase = AddFavoriteUseCase(prefs);
    _removeFavoriteUseCase = RemoveFavoriteUseCase(prefs);
    _isFavoriteUseCase = IsFavoriteUseCase(prefs);
  }

  @override
  void dispose() {
    _analysisTimer?.cancel();
    _progressTimer?.cancel();
    _audioService.stopAnalysisAmbience();
    _ttsService.dispose();
    _audioService.dispose();
    super.dispose();
  }

  void _startRecording() async {
    // First, check if permission is permanently denied
    final isPermanentlyDenied = await _audioService.isMicrophonePermissionPermanentlyDenied();
    
    if (isPermanentlyDenied) {
      // User previously clicked "Don't Allow" or "Never Ask Again" - show error without asking again
      if (mounted) {
        _showPermissionErrorDialog();
      }
      return;
    }

    // Request permission (this will show the dialog if not already allowed)
    final permissionGranted = await _audioService.requestMicrophonePermission();
    
    if (!permissionGranted) {
      // Permission denied - show error dialog
      if (mounted) {
        _showPermissionErrorDialog();
      }
      return; // Don't start recording
    }

    // Play start beep
    await _audioService.playBeep(isStart: true);

    setState(() {
      _state = TranslationState.recording;
      _translatedText = '';
    });

    // Simulate recording for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    if (mounted && _state == TranslationState.recording) {
      _startAnalysis();
    }
  }

  void _showPermissionErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission du microphone requise'),
          content: const Text(
            'L\'application nécessite l\'accès au microphone pour fonctionner. '
            'Veuillez autoriser l\'accès au microphone dans les paramètres de votre appareil.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Paramètres'),
            ),
          ],
        );
      },
    );
  }

  void _stopRecording() {
    if (_state == TranslationState.recording) {
      _startAnalysis();
    }
  }

  void _startAnalysis() async {
    // Play end beep
    await _audioService.playBeep(isStart: false);

    setState(() {
      _state = TranslationState.analyzing;
      _progress = 0.0;
      _messageIndex = 0;
      _analysisMessage = widget.profile.analysisMessages.isNotEmpty
          ? widget.profile.analysisMessages[0]
          : 'Analyse en cours...';
    });

    await _audioService.startAnalysisAmbience();

    // Update progress
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_progress < 1.0) {
        setState(() {
          _progress += 0.02;
        });
      } else {
        timer.cancel();
      }
    });

    // Update analysis messages
    _analysisTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (_messageIndex < widget.profile.analysisMessages.length - 1) {
        setState(() {
          _messageIndex++;
          _analysisMessage = widget.profile.analysisMessages[_messageIndex];
        });
      }
    });

    // Wait for analysis to complete
    await Future.delayed(const Duration(seconds: 3));

    _analysisTimer?.cancel();
    _progressTimer?.cancel();
    await _audioService.stopAnalysisAmbience();

    if (mounted) {
      _showResult();
    }
  }

  void _showResult() async {
    await _audioService.stopAnalysisAmbience();

    final translation = _translationService.translate(widget.profile.type);
    final favoriteId = '${widget.profile.type}_${translation.hashCode}';

    // Update statistics
    await _statisticsDataSource.incrementSpecimenTranslation(widget.profile.name);

    // Save to history
    await _historyDataSource.createHistory(
      HistoryModel(
        profileType: widget.profile.name,
        translatedText: translation,
        timestamp: DateTime.now(),
      ),
    );

    // Check if already favorited
    final isFav = await _isFavoriteUseCase(favoriteId);

    setState(() {
      _state = TranslationState.result;
      _translatedText = translation;
      _isFavorited = isFav;
    });

    // Speak the result with TTS
    await Future.delayed(const Duration(milliseconds: 500));
    await _ttsService.speak(translation);
  }

  Future<void> _toggleFavorite() async {
    final favoriteId = '${widget.profile.type}_${_translatedText.hashCode}';
    
    try {
      if (_isFavorited) {
        // Remove from favorites
        await _removeFavoriteUseCase(favoriteId);
        setState(() {
          _isFavorited = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Supprimé des favoris'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      } else {
        // Add to favorites
        await _addFavoriteUseCase(
          id: favoriteId,
          text: _translatedText,
          profileType: widget.profile.type.toString().split('.').last,
        );
        setState(() {
          _isFavorited = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ajouté aux favoris'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavoritesPage(),
      ),
    );
  }

  Future<void> _openAddPhraseSheet() async {
    final added = await showAddPhraseBottomSheet(
      context: context,
      profile: widget.profile,
      translationService: _translationService,
    );

    if (!mounted || added != true) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Phrase ajoutee avec succes.'),
      backgroundColor: Colors.green,
    ));

    setState(() {
      // Refresh UI to reflect updated in-memory phrase list.
    });
  }

  void _reset() {
    _ttsService.stop();
    _audioService.stopAnalysisAmbience();
    setState(() {
      _state = TranslationState.idle;
      _translatedText = '';
      _progress = 0.0;
      _isFavorited = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              widget.profile.primaryColor.withValues(alpha: 0.1),
              widget.profile.secondaryColor.withValues(alpha: 0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              _buildAppBar(),

              // Content
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: widget.profile.primaryColor,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Traducteur ${widget.profile.name}',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Add Phrase button
          GestureDetector(
            onTap: _openAddPhraseSheet,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              child: Icon(
                Icons.add_rounded,
                color: widget.profile.primaryColor,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Favorites button
          GestureDetector(
            onTap: _openFavorites,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              child: const Icon(
                Icons.favorite_border,
                color: Colors.redAccent,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Expert Mode Toggle
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpertMode = !_isExpertMode;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isExpertMode ? Colors.black87 : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              child: Icon(
                Icons.science,
                color: _isExpertMode ? Colors.greenAccent : Colors.grey,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // If expert mode is on, we wrap the content or show overlays
    if (_isExpertMode && (_state == TranslationState.recording || _state == TranslationState.analyzing)) {
      return Stack(
        children: [
          // Background content
          Column(
            children: [
              const Spacer(flex: 1),
              _buildMainTranslationArea(),
              const Spacer(flex: 1),
            ],
          ),
          
          // Expert Overlays
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: SpectralGraphWidget(
              baseColor: widget.profile.primaryColor,
              isAnimating: _state == TranslationState.recording || _state == TranslationState.analyzing,
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: const TechnicalDataWidget(),
          ),
        ],
      );
    }
    
    return Column(
      children: [
        const Spacer(flex: 1),
        // Status text
        _buildStatusText(),

        const SizedBox(height: 20),

        _buildMainTranslationArea(),

        const Spacer(flex: 1),
      ],
    );
  }

  Widget _buildMainTranslationArea() {
    if (_state == TranslationState.analyzing) {
      return ShimmerLoader(
        message: _analysisMessage,
        baseColor: widget.profile.primaryColor,
        progress: _progress.clamp(0.0, 1.0),
      );
    } else if (_state == TranslationState.result) {
      return Expanded(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TranslationResult(
                      text: _translatedText,
                      color: widget.profile.primaryColor,
                    ),
                    if (_isExpertMode) ...[
                      const SizedBox(height: 24),
                      ExpertResultWidget(color: widget.profile.primaryColor),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildResultActions(),
          ],
        ),
      );
    } else {
      return PulsatingButton(
        onPressed: _state == TranslationState.recording ? _stopRecording : _startRecording,
        isRecording: _state == TranslationState.recording,
        color: widget.profile.primaryColor,
        icon: _state == TranslationState.recording ? Icons.stop_rounded : Icons.mic_rounded,
      );
    }
  }

  Widget _buildStatusText() {
    String text;
    IconData icon;

    switch (_state) {
      case TranslationState.idle:
        text = 'Appuyez pour enregistrer';
        icon = Icons.touch_app_rounded;
        break;
      case TranslationState.recording:
        text = 'Écoute en cours...';
        icon = Icons.hearing_rounded;
        break;
      case TranslationState.analyzing:
        text = 'Traduction en cours';
        icon = Icons.auto_awesome;
        break;
      case TranslationState.result:
        text = 'Traduction terminée';
        icon = Icons.check_circle_rounded;
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Row(
        key: ValueKey(_state),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: widget.profile.primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Top row with Favorite, Play, Share buttons (aligned right)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Favorite button
              Container(
                decoration: BoxDecoration(
                  color: _isFavorited ? Colors.redAccent : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    _isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorited ? Colors.white : Colors.redAccent,
                  ),
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(width: 12),
              // Play button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => _ttsService.speak(_translatedText),
                  icon: Icon(
                    Icons.volume_up_rounded,
                    color: widget.profile.primaryColor,
                  ),
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(width: 12),
              // Share button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: _shareResult,
                  icon: Icon(
                    Icons.share_rounded,
                    color: widget.profile.primaryColor,
                  ),
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bottom row with "Nouvelle traduction" button (centered)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 220,
                child: ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text(
                    'Nouvelle traduction',
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.profile.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: widget.profile.primaryColor.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _shareResult() {
    Share.share(
      _translatedText,
      subject: 'Traduction ${widget.profile.name}',
    );
  }
}
