import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_for_me/features/specimen_selection/domain/entities/specimen.dart';
import 'package:speak_for_me/features/translation_generator/data/datasources/translation_service.dart';
import 'package:speak_for_me/features/text_to_speech/data/datasources/tts_service.dart';
import 'package:speak_for_me/features/audio_recording/data/datasources/audio_service.dart';
import 'package:speak_for_me/features/audio_recording/presentation/widgets/pulsating_button.dart';
import 'package:speak_for_me/core/widgets/shimmer_loader.dart';
import '../widgets/translation_result.dart';
import 'package:speak_for_me/features/expert_mode/presentation/widgets/spectral_graph_widget.dart';
import 'package:speak_for_me/features/expert_mode/presentation/widgets/technical_data_widget.dart';
import 'package:speak_for_me/features/expert_mode/presentation/widgets/expert_result_widget.dart';
import 'package:speak_for_me/features/favorites/domain/entities/favorite.dart';
import 'package:speak_for_me/features/favorites/data/datasources/favorites_datasource.dart';

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
  final FavoritesDatasource _favoritesDatasource = FavoritesDatasource();

  bool _isExpertMode = false;
  TranslationState _state = TranslationState.idle;
  String _analysisMessage = '';
  String _translatedText = '';
  bool _isFavorite = false;
  double _progress = 0.0;
  Timer? _analysisTimer;
  Timer? _progressTimer;
  int _messageIndex = 0;

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
  }

  @override
  void dispose() {
    _analysisTimer?.cancel();
    _progressTimer?.cancel();
    _ttsService.dispose();
    _audioService.dispose();
    super.dispose();
  }

  void _startRecording() async {
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

    if (mounted) {
      _showResult();
    }
  }

  void _showResult() async {
    final translation = _translationService.translate(widget.profile.type);

    setState(() {
      _state = TranslationState.result;
      _translatedText = translation;
      _isFavorite = false;
    });

    // Speak the result with TTS
    await Future.delayed(const Duration(milliseconds: 500));
    await _ttsService.speak(translation);
  }

  void _toggleFavorite() async {
    final favorite = FavoriteTranslation(
      profileType: widget.profile.type,
      phrase: _translatedText,
      date: DateTime.now(),
    );
    
    if (_isFavorite) {
      await _favoritesDatasource.removeFavorite(favorite);
    } else {
      await _favoritesDatasource.saveFavorite(favorite);
    }
    
    if (mounted) {
      setState(() {
        _isFavorite = !_isFavorite;
      });
    }
  }

  void _reset() {
    _ttsService.stop();
    setState(() {
      _state = TranslationState.idle;
      _translatedText = '';
      _progress = 0.0;
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

        const SizedBox(height: 40),

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
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Nouvelle traduction'),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.profile.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: widget.profile.primaryColor.withValues(alpha: 0.4),
              ),
            ),
          ),
          const SizedBox(width: 16),
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
              onPressed: _toggleFavorite,
              icon: Icon(
                _isFavorite ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              padding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(width: 8),
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
        ],
      ),
    );
  }
}
