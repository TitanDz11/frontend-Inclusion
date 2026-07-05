import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../services/accessibility_provider.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

class ReaderScreen extends StatefulWidget {
  final String? scannedText;

  const ReaderScreen({super.key, this.scannedText});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;
  
  late String _textToRead;

  final String _sampleText = '''La accesibilidad digital garantiza que todas las personas, independientemente de sus capacidades, puedan usar la tecnología de forma plena y autónoma. Cada herramienta que diseñamos con inclusión en mente representa un paso hacia una sociedad más justa y equitativa para todos.''';

  @override
  void initState() {
    super.initState();
    _textToRead = widget.scannedText ?? _sampleText;
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("es-ES");
    await _flutterTts.setSharedInstance(true);
    await _flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
      ],
      IosTextToSpeechAudioMode.defaultMode,
    );
    
    _flutterTts.setStartHandler(() {
      if (mounted) setState(() => _isPlaying = true);
    });

    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => _isPlaying = false);
    });

    _flutterTts.setCancelHandler(() {
      if (mounted) setState(() => _isPlaying = false);
    });

    // Auto read aloud if enabled in settings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final a11y = Provider.of<AccessibilityProvider>(context, listen: false);
      if (a11y.autoReadAloud) {
        _speak();
      }
    });
  }

  Future<void> _speak() async {
    final a11y = Provider.of<AccessibilityProvider>(context, listen: false);
    // mapping 0.0-1.0 from our settings to tts speed (0.1 to 1.0)
    final speechRate = 0.3 + (a11y.readingSpeed * 0.7); 
    await _flutterTts.setSpeechRate(speechRate);
    await _flutterTts.speak(_textToRead);
  }

  Future<void> _stop() async {
    await _flutterTts.stop();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBase,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text('Lector Asistido', style: AppTheme.captionStyle.copyWith(fontSize: 12)),
            const SizedBox(height: 2),
            Text('Guía de Accesibilidad', style: AppTheme.bodyLargeStyle.copyWith(fontSize: 16)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLG),
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacingLG),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _textToRead,
                      style: AppTheme.bodyLargeStyle.copyWith(height: 1.8, fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // TTS Controls inside blue container
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLG),
            decoration: const BoxDecoration(
              color: AppTheme.accentPrimary,
            ),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.stop_rounded, color: Colors.white, size: 36),
                    onPressed: () {
                      _stop();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                      color: Colors.white,
                      size: 64,
                    ),
                    onPressed: () {
                      if (_isPlaying) {
                        _stop();
                      } else {
                        _speak();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.replay_rounded, color: Colors.white, size: 36),
                    onPressed: () {
                      _stop();
                      _speak();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onTap: (index) => _navigateTo(context, index),
      ),
    );
  }

  void _navigateTo(BuildContext context, int index) {
    if (index == 1) return;
    _stop();
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
        break;
    }
  }
}
