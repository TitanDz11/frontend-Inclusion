import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/accessibility_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/app_bottom_nav.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'home_screen.dart';
import 'document_type_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  final _phoneMask = MaskTextInputFormatter(
    mask: '+504 ####-####',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();
    final a11y = Provider.of<AccessibilityProvider>(context, listen: false);
    _nameController = TextEditingController(text: a11y.emergencyName ?? '');
    _phoneController = TextEditingController(text: a11y.emergencyPhone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
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
                        icon: Icons.vibration_rounded,
                        title: 'Vibración háptica',
                        subtitle: 'Retroalimentación táctil en acciones',
                        value: a11y.hapticVibration,
                        hapticsEnabled: a11y.hapticVibration,
                        onChanged: (val) => a11y.toggleHapticVibration(val),
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
                // EMERGENCIA SECTION
                Text(
                  'Contacto de Emergencia S.O.S',
                  style: AppTheme.captionStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMD),
                AppCard(
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre del contacto',
                          prefixIcon: const Icon(Icons.person_rounded),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingMD),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [_phoneMask],
                        decoration: InputDecoration(
                          labelText: 'Número de teléfono',
                          hintText: '+504 0000-0000',
                          prefixIcon: const Icon(Icons.phone_rounded),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingMD),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            a11y.saveEmergencyContact(_nameController.text, _phoneController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Contacto guardado correctamente')),
                            );
                            FocusScope.of(context).unfocus();
                          },
                          icon: const Icon(Icons.save_rounded, color: Colors.white),
                          label: const Text('Guardar Contacto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
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
                HapticFeedback.vibrate();
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
