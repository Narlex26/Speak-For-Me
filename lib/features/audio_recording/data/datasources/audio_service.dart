import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

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

  /// Requests microphone permission from the user.
  /// Handles three cases:
  /// - Permanently allowed: doesn't ask, returns true
  /// - Temporarily allowed (Allow once): asks again next time
  /// - Denied/Never shown: asks for permission
  /// Returns true if permission is granted (temporarily or permanently), false if denied.
  Future<bool> requestMicrophonePermission() async {
    try {
      final status = await Permission.microphone.request();
      return status.isGranted;
    } catch (e) {
      print('Error requesting microphone permission: $e');
      return false;
    }
  }

  /// Checks if permission is permanently denied (user clicked "Don't Allow" or "Never Ask Again").
  /// Returns true if permanently denied, false otherwise.
  Future<bool> isMicrophonePermissionPermanentlyDenied() async {
    try {
      final status = await Permission.microphone.status;
      return status.isDenied && status.isPermanentlyDenied;
    } catch (e) {
      print('Error checking if permission is permanently denied: $e');
      return false;
    }
  }

  /// Gets the current status of microphone permission.
  /// Returns the PermissionStatus to allow checking for different states.
  Future<PermissionStatus> getMicrophonePermissionStatus() async {
    try {
      return await Permission.microphone.status;
    } catch (e) {
      print('Error checking microphone permission: $e');
      return PermissionStatus.denied;
    }
  }

  void dispose() {
    // Nothing to dispose with this implementation
  }
}

