import 'dart:async';
import 'package:flutter/material.dart';
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
import 'package:speak_for_me/features/translation_generator/presentation/widgets/translation_app_bar.dart';
import 'package:speak_for_me/features/translation_generator/presentation/widgets/translation_status_text.dart';
import 'package:speak_for_me/features/translation_generator/presentation/widgets/translation_result_actions.dart';
import '../widgets/translation_result.dart';
import 'package:speak_for_me/features/expert_mode/presentation/widgets/spectral_graph_widget.dart';
import 'package:speak_for_me/features/expert_mode/presentation/widgets/technical_data_widget.dart';
import 'package:speak_for_me/features/expert_mode/presentation/widgets/expert_result_widget.dart';
import 'package:speak_for_me/features/favorites/presentation/pages/favorites_page.dart';
import 'package:speak_for_me/features/favorites/domain/usecases/favorite_usecases.dart';
import 'package:speak_for_me/features/statistics/data/datasources/statistics_local_datasource.dart';
import 'package:speak_for_me/features/history/data/datasources/history_local_datasource.dart';
import 'package:speak_for_me/features/history/data/models/history_model.dart';

part 'translation_logic.dart';
enum TranslationState { idle, recording, analyzing, result }

class TranslationPage extends StatefulWidget {
  final Profile profile;
  const TranslationPage({super.key, required this.profile});
  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> with _TranslationLogic {
  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
    _initializeFavoritesUseCases();
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
              TranslationAppBar(
                profile: widget.profile,
                isExpertMode: _isExpertMode,
                onBack: () => Navigator.pop(context),
                onAddPhrase: _openAddPhraseSheet,
                onOpenFavorites: _openFavorites,
                onToggleExpertMode: () => setState(() => _isExpertMode = !_isExpertMode),
              ),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isExpertMode && (_state == TranslationState.recording || _state == TranslationState.analyzing)) {
      return Stack(
        children: [
          Column(children: [const Spacer(), _buildMainArea(), const Spacer()]),
          Positioned(
            top: 10, left: 10, right: 10,
            child: SpectralGraphWidget(
              baseColor: widget.profile.primaryColor,
              isAnimating: _state == TranslationState.recording || _state == TranslationState.analyzing,
            ),
          ),
          Positioned(bottom: 10, left: 10, right: 10, child: const TechnicalDataWidget()),
        ],
      );
    }
    final (text, icon) = _statusInfo;
    return Column(
      children: [
        const Spacer(),
        TranslationStatusText(text: text, icon: icon, color: widget.profile.primaryColor),
        const SizedBox(height: 20),
        _buildMainArea(),
        const Spacer(),
      ],
    );
  }

  Widget _buildMainArea() {
    if (_state == TranslationState.analyzing) {
      return ShimmerLoader(message: _analysisMessage, baseColor: widget.profile.primaryColor, progress: _progress.clamp(0.0, 1.0));
    }
    if (_state == TranslationState.result) {
      return Expanded(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  TranslationResult(text: _translatedText, color: widget.profile.primaryColor),
                  if (_isExpertMode) ...[const SizedBox(height: 24), ExpertResultWidget(color: widget.profile.primaryColor)],
                ]),
              ),
            ),
            const SizedBox(height: 16),
            TranslationResultActions(
              primaryColor: widget.profile.primaryColor,
              isFavorited: _isFavorited,
              onReset: _reset,
              onToggleFavorite: _toggleFavorite,
              onSpeak: () => _ttsService.speak(_translatedText),
              onShare: _shareResult,
            ),
          ],
        ),
      );
    }
    return PulsatingButton(
      onPressed: _state == TranslationState.recording ? _stopRecording : _startRecording,
      isRecording: _state == TranslationState.recording,
      color: widget.profile.primaryColor,
      icon: _state == TranslationState.recording ? Icons.stop_rounded : Icons.mic_rounded,
    );
  }
}
