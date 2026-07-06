import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/app_bottom_nav.dart';
import 'home_screen.dart';
import 'document_type_screen.dart';
import 'settings_screen.dart';

class HealthDirectoryScreen extends StatelessWidget {
  const HealthDirectoryScreen({super.key});

  static const List<_HealthContact> _contacts = [
    _HealthContact(
      name: 'Hospital General Atlántida',
      description: 'Emergencias generales',
      phone: '444-2200',
      icon: Icons.local_hospital_rounded,
    ),
    _HealthContact(
      name: 'Cruz Roja Hondureña',
      description: 'Ambulancias',
      phone: '195',
      icon: Icons.emergency_rounded,
    ),
    _HealthContact(
      name: 'Centro de Salud Regional',
      description: 'Consultas externas',
      phone: '444-0850',
      icon: Icons.medical_services_rounded,
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
              'Centros de Salud',
              style: AppTheme.headingStyle.copyWith(fontSize: 20),
            ),
            Text(
              'Llamadas normales, no requiere internet',
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
                itemBuilder: (context, index) => _buildContactCard(_contacts[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMD),
              child: Text(
                'Base de datos local · Sin conexión a internet',
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

  Widget _buildContactCard(_HealthContact contact) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(height: 2),
                Text(contact.description, style: AppTheme.captionStyle),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacingSM),
          // Action (Phone + Button)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                contact.phone,
                style: AppTheme.bodyStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentPrimary,
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () async {
                  final cleanPhone = contact.phone.replaceAll(RegExp(r'[^\d+]'), '');
                  final url = Uri.parse('tel:$cleanPhone');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPrimary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Llamar',
                    style: AppTheme.captionStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
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

class _HealthContact {
  final String name;
  final String description;
  final String phone;
  final IconData icon;

  const _HealthContact({
    required this.name,
    required this.description,
    required this.phone,
    required this.icon,
  });
}
