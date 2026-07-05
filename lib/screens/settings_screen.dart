import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/accessibility_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/app_bottom_nav.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'document_type_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Configuración de accesibilidad',
          style: AppTheme.headingStyle.copyWith(fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: Consumer<AccessibilityProvider>(
        builder: (context, a11y, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // APARIENCIA SECTION
                Text(
                  'Apariencia',
                  style: AppTheme.captionStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMD),
                AppCard(
                  child: Column(
                    children: [
                      _buildSliderRow(
                        icon: Icons.text_fields_rounded,
                        title: 'Tamaño de fuente',
                        valueText: '${(a11y.fontScale * 100).toInt()}%',
                        value: a11y.fontScale,
                        min: 0.5,
                        max: 2.0,
                        onChanged: (val) => a11y.setFontScale(val),
                      ),
                      const SizedBox(height: AppTheme.spacingLG),
                      _buildSliderRow(
                        icon: Icons.contrast_rounded,
                        title: 'Contraste',
                        valueText: '${(a11y.contrast * 100).toInt()}%',
                        value: a11y.contrast,
                        min: 0.5,
                        max: 2.0,
                        onChanged: (val) {
                          a11y.setContrast(val);
                        },
                      ),
                      const SizedBox(height: AppTheme.spacingLG),
                      _buildSliderRow(
                        icon: Icons.speed_rounded,
                        title: 'Velocidad de lectura',
                        valueText: '${(a11y.readingSpeed * 100).toInt()}%',
                        value: a11y.readingSpeed,
                        min: 0.0,
                        max: 1.0,
                        onChanged: (val) => a11y.setReadingSpeed(val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXL),
                // FUNCIONES SECTION
                Text(
                  'Funciones',
                  style: AppTheme.captionStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMD),
                AppCard(
                  child: Column(
                    children: [
                      _buildToggleRow(
                        icon: Icons.text_increase_rounded,
                        title: 'Texto ampliado',
                        subtitle: 'Aumenta el tamaño base de fuente',
                        value: a11y.fontScale > 1.2,
                        hapticsEnabled: a11y.hapticVibration,
                        onChanged: (val) {
                          a11y.setFontScale(val ? 1.5 : 1.0);
                        },
                      ),
                      const Divider(height: 32),
                      _buildToggleRow(
                        icon: Icons.dark_mode_rounded,
                        title: 'Modo oscuro',
                        subtitle: 'Reduce el brillo de pantalla',
                        value: a11y.darkMode,
                        hapticsEnabled: a11y.hapticVibration,
                        onChanged: (val) => a11y.toggleDarkMode(val),
                      ),
                      const Divider(height: 32),
                      _buildToggleRow(
                        icon: Icons.vibration_rounded,
                        title: 'Vibración háptica',
                        subtitle: 'Retroalimentación táctil en acciones',
                        value: a11y.hapticVibration,
                        hapticsEnabled: a11y.hapticVibration,
                        onChanged: (val) => a11y.toggleHapticVibration(val),
                      ),
                      const Divider(height: 32),
                      _buildToggleRow(
                        icon: Icons.record_voice_over_rounded,
                        title: 'Lectura en voz alta',
                        subtitle: 'Narración automática al abrir textos',
                        value: a11y.autoReadAloud,
                        hapticsEnabled: a11y.hapticVibration,
                        onChanged: (val) => a11y.toggleAutoReadAloud(val),
                      ),
                      const Divider(height: 32),
                      _buildToggleRow(
                        icon: Icons.sign_language_rounded,
                        title: 'Traducción simultánea',
                        subtitle: 'Español / Lengua de señas',
                        value: a11y.signLanguage,
                        hapticsEnabled: a11y.hapticVibration,
                        onChanged: (val) => a11y.toggleSignLanguage(val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXL),
                Center(
                  child: Text(
                    'Inclusión Atlántida · v1.4.0 · Modo sin conexión activo',
                    style: AppTheme.captionStyle,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXL),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
        onTap: (index) => _navigateTo(context, index),
      ),
    );
  }

  Widget _buildSliderRow({
    required IconData icon,
    required String title,
    required String valueText,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.textPrimary, size: 24),
            const SizedBox(width: AppTheme.spacingSM),
            Expanded(
              child: Text(
                title,
                style: AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Text(valueText, style: AppTheme.captionStyle),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSM),
        SliderTheme(
          data: const SliderThemeData(
            trackHeight: 6,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
            activeTrackColor: AppTheme.accentPrimary,
            inactiveTrackColor: Color(0xFFEEECEA), // Based on figma
            thumbColor: AppTheme.accentPrimary,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required bool hapticsEnabled,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.backgroundBase,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.accentPrimary, size: 20),
        ),
        const SizedBox(width: AppTheme.spacingMD),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTheme.captionStyle,
              ),
            ],
          ),
        ),
        Transform.scale(
          scale: 0.85,
          child: Switch(
            value: value,
            onChanged: (val) {
              if (hapticsEnabled) {
                HapticFeedback.lightImpact();
              }
              onChanged(val);
            },
            activeThumbColor: Colors.white,
            activeTrackColor: AppTheme.accentPrimary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFD1D0CC), // Based on figma toggle
          ),
        ),
      ],
    );
  }

  void _navigateTo(BuildContext context, int index) {
    if (index == 2) return;
    
    Widget nextScreen = index == 0 ? const HomeScreen() : const DocumentTypeScreen();
    
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
