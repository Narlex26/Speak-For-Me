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
    });

    // Speak the result with TTS
    await Future.delayed(const Duration(milliseconds: 500));
    await _ttsService.speak(translation);
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
                    color: Colors.grey.withValues(alpha: 0.1),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mode ${widget.profile.name}',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.profile.primaryColor,
                  ),
                ),
                Text(
                  'Traducteur en temps réel',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.profile.primaryColor,
                  widget.profile.secondaryColor,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.profile.icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        const Spacer(flex: 1),

        // Status text
        _buildStatusText(),

        const SizedBox(height: 40),

        // Main action area
        if (_state == TranslationState.analyzing)
          ShimmerLoader(
            message: _analysisMessage,
            baseColor: widget.profile.primaryColor,
            progress: _progress.clamp(0.0, 1.0),
          )
        else if (_state == TranslationState.result)
          Expanded(
            child: SingleChildScrollView(
              child: TranslationResult(
                text: _translatedText,
                color: widget.profile.primaryColor,
              ),
            ),
          )
        else
          PulsatingButton(
            onPressed: _state == TranslationState.recording
                ? _stopRecording
                : _startRecording,
            isRecording: _state == TranslationState.recording,
            color: widget.profile.primaryColor,
            icon: Icons.mic_rounded,
          ),

        const Spacer(flex: 1),

        // Bottom buttons
        if (_state == TranslationState.result) _buildResultActions(),

        const SizedBox(height: 32),
      ],
    );
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

