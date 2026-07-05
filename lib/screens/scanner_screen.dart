import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'reader_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  Future<void> _processImage(ImageSource source) async {
    try {
      setState(() => _isProcessing = true);
      
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) {
        setState(() => _isProcessing = false);
        return;
      }

      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      final String extractedText = recognizedText.text;
      
      textRecognizer.close();

      if (!mounted) return;
      setState(() => _isProcessing = false);

      if (extractedText.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró texto en la imagen. Intente de nuevo.')),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ReaderScreen(scannedText: extractedText)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      
      String errorMsg = 'Error al procesar la imagen.';
      if (e is PlatformException && e.code == 'camera_access_denied') {
        errorMsg = 'No se ha concedido acceso a la cámara.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    }
  }

  void _showSourceOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundBase,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusCard)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded, color: AppTheme.accentPrimary),
                title: const Text('Cámara'),
                onTap: () {
                  Navigator.pop(context);
                  _processImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: AppTheme.accentPrimary),
                title: const Text('Galería'),
                onTap: () {
                  Navigator.pop(context);
                  _processImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141416), // Dark background from Figma
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD, vertical: AppTheme.spacingSM),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: AppTheme.spacingSM),
                  Text(
                    'Escanear Documento',
                    style: AppTheme.subheadingStyle.copyWith(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            // Camera preview area with focus frame
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXL, vertical: AppTheme.spacingXL),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                    ),
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: AppTheme.spacingLG),
                    child: Text(
                      'Encuadre el documento aquí',
                      style: AppTheme.captionStyle.copyWith(color: Colors.white, fontSize: 13),
                    ),
                  ),
                  // Focus frame corners
                  ..._buildFocusCorners(),
                  if (_isProcessing)
                    Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: const Center(
                        child: CircularProgressIndicator(color: AppTheme.accentPrimary),
                      ),
                    ),
                ],
              ),
            ),
            // Bottom Action Area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLG, vertical: AppTheme.spacingXL),
              decoration: const BoxDecoration(
                color: AppTheme.backgroundBase,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusCard)),
              ),
              child: SafeArea(
                top: false,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _showSourceOptions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.textPrimary,
                    padding: const EdgeInsets.all(AppTheme.spacingMD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusButton),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isProcessing ? Colors.grey : AppTheme.accentPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: AppTheme.spacingSM),
                      Text(
                        _isProcessing ? 'Procesando...' : 'Toque para fotografiar y leer',
                        style: AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFocusCorners() {
    const cornerSize = 40.0;
    const cornerColor = Colors.white;
    const cornerWidth = 4.0;
    const margin = AppTheme.spacingXL;

    return [
      Positioned(
        top: margin - 2, left: margin - 2,
        child: Container(
          width: cornerSize, height: cornerSize,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: cornerColor, width: cornerWidth),
              left: BorderSide(color: cornerColor, width: cornerWidth),
            ),
          ),
        ),
      ),
      Positioned(
        top: margin - 2, right: margin - 2,
        child: Container(
          width: cornerSize, height: cornerSize,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: cornerColor, width: cornerWidth),
              right: BorderSide(color: cornerColor, width: cornerWidth),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: margin - 2, left: margin - 2,
        child: Container(
          width: cornerSize, height: cornerSize,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: cornerColor, width: cornerWidth),
              left: BorderSide(color: cornerColor, width: cornerWidth),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: margin - 2, right: margin - 2,
        child: Container(
          width: cornerSize, height: cornerSize,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: cornerColor, width: cornerWidth),
              right: BorderSide(color: cornerColor, width: cornerWidth),
            ),
          ),
        ),
      ),
    ];
  }
}
