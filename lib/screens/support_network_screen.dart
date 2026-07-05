import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/app_bottom_nav.dart';
import 'home_screen.dart';
import 'document_type_screen.dart';
import 'settings_screen.dart';

class SupportNetworkScreen extends StatelessWidget {
  const SupportNetworkScreen({super.key});

  static const List<_SupportContact> _contacts = [
    _SupportContact(
      name: 'Asociación de Ciegos',
      description: 'Acompañamiento presencial para trámites municipales en La Ceiba.',
      buttonText: 'Llamar Asesor',
      icon: Icons.groups_rounded,
    ),
    _SupportContact(
      name: 'Voluntarios Universitarios',
      description: 'Jóvenes capacitadores en uso de tecnología asistiva para adultos mayores.',
      buttonText: 'Solicitar Visita',
      icon: Icons.volunteer_activism_rounded,
    ),
  ];

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Red de Apoyo',
              style: AppTheme.headingStyle.copyWith(fontSize: 20),
            ),
            Text(
              'Asistencia presencial en tu comunidad',
              style: AppTheme.captionStyle,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppTheme.spacingLG),
                itemCount: _contacts.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingMD),
                itemBuilder: (context, index) => _buildSupportCard(_contacts[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMD),
              child: Text(
                'Contacto local · Sin conexión a internet',
                style: AppTheme.captionStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onTap: (index) => _navigateTo(context, index),
      ),
    );
  }

  Widget _buildSupportCard(_SupportContact contact) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.accentPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  contact.icon,
                  color: AppTheme.accentPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMD),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(contact.description, style: AppTheme.captionStyle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMD),
          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                contact.buttonText,
                style: AppTheme.bodyStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false,
        );
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const DocumentTypeScreen()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
        break;
    }
  }
}

class _SupportContact {
  final String name;
  final String description;
  final String buttonText;
  final IconData icon;

  const _SupportContact({
    required this.name,
    required this.description,
    required this.buttonText,
    required this.icon,
  });
}
