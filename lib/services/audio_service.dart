import 'package:flutter/services.dart';

class AudioService {
  /// Plays a beep sound using system haptic feedback and audio
  Future<void> playBeep({bool isStart = true}) async {
    try {
      // Use system haptic feedback as audible cue
      if (isStart) {
        // Start beep - heavier feedback
        await HapticFeedback.mediumImpact();
        await Future.delayed(const Duration(milliseconds: 50));
        await HapticFeedback.lightImpact();
      } else {
        // End beep - double light feedback
        await HapticFeedback.lightImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        await HapticFeedback.lightImpact();
      }

      // Also play system click sound
      await SystemSound.play(SystemSoundType.click);
    } catch (e) {
      // Silently fail if audio can't play - it's not critical
      print('Could not play beep: $e');
    }
  }

  void dispose() {
    // Nothing to dispose with this implementation
  }
}

