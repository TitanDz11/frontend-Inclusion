import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/app_bottom_nav.dart';
import 'scanner_screen.dart';
import 'home_screen.dart';
import 'reader_screen.dart';
import 'settings_screen.dart';
import 'package:provider/provider.dart';
import '../services/accessibility_provider.dart';

class DocumentTypeScreen extends StatelessWidget {
  const DocumentTypeScreen({super.key});

  static const List<_DocItem> _preloadedDocs = [
    _DocItem(
      'DNI (RNP)',
      Icons.badge_rounded,
      'Registro Nacional de las Personas.\nDocumento Nacional de Identidad.\nNúmero: 0801-1990-12345.\nNombre: Juan Pérez García.\nFecha de nacimiento: 15 de marzo de 1990.\nLugar de nacimiento: Tegucigalpa, Francisco Morazán.\nEstado Civil: Soltero.',
    ),
    _DocItem(
      'Bienes Inmuebles',
      Icons.home_rounded,
      'Alcaldía Municipal.\nRecibo por pago de bienes inmuebles.\nClave catastral: 0801-0001-0002-0003.\nPropietario: Juan Pérez García.\nDirección: Colonia Kennedy, Bloque 5, Casa 12.\nTotal a pagar: L. 1,500.00.\nFecha de vencimiento: 31 de agosto de 2026.',
    ),
    _DocItem(
      'Servicio de Agua',
      Icons.water_drop_rounded,
      'Servicio Autónomo Nacional de Acueductos y Alcantarillados (SANAA).\nFactura de consumo de agua potable.\nCliente: Juan Pérez García.\nMes facturado: Junio 2026.\nLectura anterior: 1542 m3. Lectura actual: 1560 m3.\nTotal a pagar: L. 350.00.\nFecha límite de pago: 15 de julio de 2026.',
    ),
    _DocItem(
      'Recibo de Luz',
      Icons.bolt_rounded,
      'Empresa Nacional de Energía Eléctrica (ENEE).\nFactura de consumo eléctrico.\nCódigo de cliente: 987654321.\nMes facturado: Junio 2026.\nConsumo: 250 kWh.\nTotal a pagar: L. 1,250.00.\nPor favor pague antes del 20 de julio de 2026 para evitar recargos.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBase,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
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
              ),
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
            // 2x2 Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: AppTheme.spacingMD,
              crossAxisSpacing: AppTheme.spacingMD,
              children: _preloadedDocs.map((doc) => _buildDocCard(context, doc)).toList(),
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
        Navigator.push(context, MaterialPageRoute(builder: (_) => ReaderScreen(scannedText: doc.content)));
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
  final String name;
  final IconData icon;
  final String content;
  const _DocItem(this.name, this.icon, this.content);
}
