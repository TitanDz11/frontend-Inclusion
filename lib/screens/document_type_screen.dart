import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/app_bottom_nav.dart';
import 'scanner_screen.dart';
import 'home_screen.dart';
import 'reader_screen.dart';
import 'settings_screen.dart';
import 'package:provider/provider.dart';
import '../services/accessibility_provider.dart';
import '../services/database_service.dart';
import '../models/document.dart';

class DocumentTypeScreen extends StatefulWidget {
  const DocumentTypeScreen({super.key});

  @override
  State<DocumentTypeScreen> createState() => _DocumentTypeScreenState();
}

class _DocumentTypeScreenState extends State<DocumentTypeScreen> {
  List<_DocItem> _allDocs = [];



  @override
  void initState() {
    super.initState();
    _loadDocs();
  }

  Future<void> _loadDocs() async {
    try {
      final isar = DatabaseService.instance;
      final savedDocs = await isar.collection<Document>().where().findAll();
      
      final mappedDocs = savedDocs.map((doc) => _DocItem(
        doc.id,
        doc.name,
        Icons.description_rounded,
        doc.extractedText ?? '',
      )).toList();

      if (mounted) {
        setState(() {
          _allDocs = mappedDocs;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _allDocs = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBase,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tipo de Documento', style: AppTheme.bodyLargeStyle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Large blue scan button
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScannerScreen()),
              ).then((_) => _loadDocs()), // Refresh docs when returning
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(AppTheme.spacingMD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.document_scanner_rounded, color: AppTheme.accentPrimary, size: 24),
                  ),
                  const SizedBox(width: AppTheme.spacingMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Escanear papel con cámara',
                          style: AppTheme.subheadingStyle.copyWith(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Procesa el texto sin conexión a internet',
                          style: AppTheme.captionStyle.copyWith(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingXL),
            Text(
              'Documentos Guardados',
              style: AppTheme.captionStyle.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppTheme.spacingMD),
            _allDocs.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: AppTheme.spacingMD),
                    child: Text('Aún no tienes documentos guardados.', style: TextStyle(color: AppTheme.textSecondary)),
                  )
                : GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: AppTheme.spacingMD,
                    crossAxisSpacing: AppTheme.spacingMD,
                    children: _allDocs.map((doc) => _buildDocCard(context, doc)).toList(),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1, // "Lector" is selected in Figma
        onTap: (index) => _navigateTo(context, index),
      ),
    );
  }

  Widget _buildDocCard(BuildContext context, _DocItem doc) {
    return AppCard(
      onTap: () {
        // Navigate to document reader
        Navigator.push(context, MaterialPageRoute(builder: (_) => ReaderScreen(scannedText: doc.content, documentId: doc.id))).then((_) => _loadDocs());
      },
      onLongPress: () {
        context.read<AccessibilityProvider>().speak(doc.name);
      },
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppTheme.accentPrimary,
              shape: BoxShape.circle,
            ),
            child: Icon(doc.icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: AppTheme.spacingSM),
          Text(
            doc.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.bodyStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, int index) {
    if (index == 1) return;
    
    Widget nextScreen = index == 0 ? const HomeScreen() : const SettingsScreen();
    
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => nextScreen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}

class _DocItem {
  final int id;
  final String name;
  final IconData icon;
  final String content;
  const _DocItem(this.id, this.name, this.icon, this.content);
}
