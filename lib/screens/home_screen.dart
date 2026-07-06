import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/app_bottom_nav.dart';
import 'health_directory_screen.dart';
import 'document_type_screen.dart';
import 'settings_screen.dart';
import 'support_network_screen.dart';
import 'package:provider/provider.dart';
import '../services/accessibility_provider.dart';
import 'sos_emergency_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Buenos días';
    } else if (hour < 19) {
      return 'Buenas tardes';
    } else {
      return 'Buenas noches';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBase,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLG, vertical: AppTheme.spacingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Inclusión Atlántida',
                          style: AppTheme.captionStyle.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: AppTheme.spacingXS),
                        Text(
                          '${_getGreeting()},\n¿en qué te ayudamos?',
                          style: AppTheme.headingStyle,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => _navigateTo(context, const SOSEmergencyScreen()),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.sos_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingXL),
              
              // Card 1: Lector Asistido
              AppCard(
                onTap: () => _navigateTo(context, const DocumentTypeScreen()),
                onLongPress: () => context.read<AccessibilityProvider>().speak('Lector Asistido, Textos con narración de voz'),
                child: Row(
                  children: [
                    _buildIconCircle(Icons.menu_book_rounded),
                    const SizedBox(width: AppTheme.spacingMD),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lector Asistido', style: AppTheme.subheadingStyle),
                          const SizedBox(height: 4),
                          Text('Textos con narración de voz', style: AppTheme.captionStyle),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, size: 28, color: AppTheme.textSecondary),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingSM),
              
              // Card 2: Directorio de Salud
              AppCard(
                onTap: () => _navigateTo(context, const HealthDirectoryScreen()),
                onLongPress: () => context.read<AccessibilityProvider>().speak('Directorio de Salud, Centros y contactos locales'),
                child: Row(
                  children: [
                    _buildIconCircle(Icons.local_hospital_rounded),
                    const SizedBox(width: AppTheme.spacingMD),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Directorio de Salud', style: AppTheme.subheadingStyle),
                          const SizedBox(height: 4),
                          Text('Centros y contactos locales', style: AppTheme.captionStyle),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, size: 28, color: AppTheme.textSecondary),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingSM),
              
              // Card 3: Red de Apoyo
              AppCard(
                onTap: () => _navigateTo(context, const SupportNetworkScreen()),
                onLongPress: () => context.read<AccessibilityProvider>().speak('Red de Apoyo, ONGs y voluntarios comunitarios'),
                child: Row(
                  children: [
                    _buildIconCircle(Icons.group_rounded),
                    const SizedBox(width: AppTheme.spacingMD),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Red de Apoyo', style: AppTheme.subheadingStyle),
                          const SizedBox(height: 4),
                          Text('ONGs y voluntarios comunitarios', style: AppTheme.captionStyle),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, size: 28, color: AppTheme.textSecondary),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingSM),
              
              // Card 4: Accesibilidad
              AppCard(
                onTap: () => _navigateTo(context, const SettingsScreen()),
                onLongPress: () => context.read<AccessibilityProvider>().speak('Accesibilidad, Ajustes personalizados'),
                child: Row(
                  children: [
                    _buildIconCircle(Icons.settings_rounded),
                    const SizedBox(width: AppTheme.spacingMD),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Accesibilidad', style: AppTheme.subheadingStyle),
                          const SizedBox(height: 4),
                          Text('Ajustes personalizados', style: AppTheme.captionStyle),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, size: 28, color: AppTheme.textSecondary),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingXL),

              // Info Card: Modo de voz disponible
              AppCard(
                onTap: () {},
                onLongPress: () => context.read<AccessibilityProvider>().speak('Modo de voz disponible. Mantén presionado cualquier opción para activar la lectura en voz alta.'),
                child: Row(
                  children: [
                    _buildIconCircle(Icons.volume_up_rounded),
                    const SizedBox(width: AppTheme.spacingMD),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Modo de voz disponible',
                            style: AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mantén presionado cualquier opción para activar la lectura en voz alta.',
                            style: AppTheme.captionStyle.copyWith(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onTap: (index) => _handleBottomNav(context, index),
      ),
    );
  }

  Widget _buildIconCircle(IconData icon) {
    return Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(
        color: AppTheme.accentPrimary,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  void _handleBottomNav(BuildContext context, int index) {
    if (index == 0) return;
    
    Widget nextScreen = index == 1 ? const DocumentTypeScreen() : const SettingsScreen();
    
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
