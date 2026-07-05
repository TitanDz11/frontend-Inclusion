import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Provider for accessibility settings (font scale, high contrast, toggles).
class AccessibilityProvider extends ChangeNotifier {
  final FlutterTts _tts = FlutterTts();
  double _fontScale = 1.0;
  double _contrast = 1.0;
  double _readingSpeed = 0.25;
  bool _darkMode = false;
  bool _hapticVibration = true;
  bool _autoReadAloud = false;
  bool _signLanguage = false;

  double get fontScale => _fontScale;
  double get contrast => _contrast;
  double get readingSpeed => _readingSpeed;
  bool get darkMode => _darkMode;
  bool get hapticVibration => _hapticVibration;
  bool get autoReadAloud => _autoReadAloud;
  bool get signLanguage => _signLanguage;

  AccessibilityProvider() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage("es-ES");
  }

  void speak(String text) async {
    double ttsSpeed = 0.2 + (_readingSpeed * 0.8);
    await _tts.setSpeechRate(ttsSpeed);
    await _tts.speak(text);
  }

  void stopSpeak() async {
    await _tts.stop();
  }

  void setFontScale(double scale) {
    _fontScale = scale.clamp(0.8, 1.8);
    notifyListeners();
  }

  void setContrast(double value) {
    _contrast = value;
    notifyListeners();
  }

  void setReadingSpeed(double speed) {
    _readingSpeed = speed.clamp(0.0, 1.0);
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void toggleHapticVibration(bool value) {
    _hapticVibration = value;
    notifyListeners();
  }

  void toggleAutoReadAloud(bool value) {
    _autoReadAloud = value;
    notifyListeners();
  }

  void toggleSignLanguage(bool value) {
    _signLanguage = value;
    notifyListeners();
  }
}
