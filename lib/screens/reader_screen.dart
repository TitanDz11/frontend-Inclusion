import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../services/accessibility_provider.dart';
import '../services/database_service.dart';
import '../models/document.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

class ReaderScreen extends StatefulWidget {
  final String? scannedText;
  final String? imagePath;
  final int? documentId;

  const ReaderScreen({super.key, this.scannedText, this.imagePath, this.documentId});

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
    // Decreased default speed by 20%
    final speechRate = (0.3 + (a11y.readingSpeed * 0.7)) * 0.8; 
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
        actions: [
          if (widget.documentId != null)
            IconButton(
              icon: const Icon(Icons.delete_rounded),
              tooltip: 'Eliminar Documento',
              onPressed: _showDeleteDialog,
            )
          else if (widget.imagePath != null)
            IconButton(
              icon: const Icon(Icons.save_rounded),
              tooltip: 'Guardar Documento',
              onPressed: _showSaveDialog,
            ),
        ],
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

  Future<void> _showDeleteDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.backgroundBase,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusCard)),
          title: Text('Eliminar Documento', style: AppTheme.subheadingStyle),
          content: Text('¿Está seguro de que desea eliminar este documento? Esta acción no se puede deshacer.', style: AppTheme.bodyStyle.copyWith(color: AppTheme.textSecondary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.alertRed, foregroundColor: Colors.white),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirm == true && widget.documentId != null) {
      try {
        final isar = DatabaseService.instance;
        await isar.writeTxn(() async {
          await isar.collection<Document>().delete(widget.documentId!);
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Documento eliminado')));
        Navigator.pop(context); // Pop back to previous screen
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al eliminar')));
      }
    }
  }

  Future<void> _showSaveDialog() async {
    final TextEditingController nameController = TextEditingController();
    bool isSaving = false;
    bool isListening = false;
    final stt.SpeechToText speechToText = stt.SpeechToText();

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: AppTheme.backgroundBase,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusCard)),
              title: Text('Guardar Documento', style: AppTheme.subheadingStyle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('¿Con qué nombre desea guardar este documento?', style: AppTheme.bodyStyle.copyWith(color: AppTheme.textSecondary)),
                  const SizedBox(height: AppTheme.spacingMD),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          style: AppTheme.bodyStyle,
                          decoration: InputDecoration(
                            hintText: 'Nombre del documento',
                            hintStyle: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.6)),
                            filled: true,
                            fillColor: Colors.grey.withValues(alpha: 0.1),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusButton), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: isListening ? Colors.red.withValues(alpha: 0.2) : AppTheme.accentPrimary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(isListening ? Icons.mic : Icons.mic_none, color: isListening ? Colors.red : AppTheme.accentPrimary),
                          onPressed: () async {
                            if (!isListening) {
                              bool available = await speechToText.initialize();
                              if (available) {
                                setStateDialog(() => isListening = true);
                                speechToText.listen(
                                  onResult: (result) {
                                    setStateDialog(() {
                                      nameController.text = result.recognizedWords;
                                    });
                                  },
                                  // ignore: deprecated_member_use
                                  localeId: 'es_ES',
                                );
                              }
                            } else {
                              setStateDialog(() => isListening = false);
                              speechToText.stop();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                if (isSaving)
                  const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(color: AppTheme.accentPrimary))
                else ...[
                  TextButton(
                    onPressed: () {
                      speechToText.stop();
                      Navigator.pop(dialogContext);
                    },
                    child: Text('Cancelar', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPrimary, foregroundColor: Colors.white),
                    onPressed: () async {
                      if (nameController.text.trim().isEmpty) return;
                      speechToText.stop();
                      setStateDialog(() => isSaving = true);
                      
                      try {
                        final appDir = await getApplicationDocumentsDirectory();
                        final fileName = 'doc_${DateTime.now().millisecondsSinceEpoch}.jpg';
                        final savedImage = await File(widget.imagePath!).copy('${appDir.path}/$fileName');
                        
                        final newDoc = Document()
                          ..name = nameController.text.trim()
                          ..category = 'General'
                          ..scannedImagePath = savedImage.path
                          ..extractedText = widget.scannedText
                          ..createdAt = DateTime.now()
                          ..updatedAt = DateTime.now()
                          ..isProcessed = true;
                          
                        final isar = DatabaseService.instance;
                        await isar.writeTxn(() async {
                          await isar.collection<Document>().put(newDoc);
                        });
                        
                        if (!mounted || !dialogContext.mounted) return;
                        Navigator.pop(dialogContext); // Close modal
                        ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text('Guardado correctamente')));
                        Navigator.pop(this.context); // Go back automatically
                      } catch (e) {
                        setStateDialog(() => isSaving = false);
                        ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text('Error al guardar')));
                      }
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
