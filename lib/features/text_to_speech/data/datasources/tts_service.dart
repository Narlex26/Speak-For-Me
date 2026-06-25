import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Configure TTS for a serious, low-pitched voice
    await _flutterTts.setLanguage("fr-FR");
    await _flutterTts.setSpeechRate(0.45); // Slower for dramatic effect
    await _flutterTts.setPitch(0.8); // Lower pitch for seriousness
    await _flutterTts.setVolume(1.0);

    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    await initialize();
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  void dispose() {
    _flutterTts.stop();
  }
}

