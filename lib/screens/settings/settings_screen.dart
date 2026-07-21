import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _darkMode = false;
  String _language = 'العربية';

  Future<void> _logout() async {
    await SessionService.clear();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
  }

  void _pickLanguage() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(padding: EdgeInsets.all(16), child: Text('اختر اللغة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            ListTile(
              title: const Text('العربية'),
              trailing: _language == 'العربية' ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () { setState(() => _language = 'العربية'); Navigator.pop(ctx); },
            ),
            ListTile(
              title: const Text('English'),
              trailing: _language == 'English' ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () { setState(() => _language = 'English'); Navigator.pop(ctx); },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionLabel('التفضيلات العامة'),
          _switchTile(Icons.dark_mode_outlined, 'الوضع الليلي', _darkMode, (v) => setState(() => _darkMode = v)),
          _navTile(Icons.language_outlined, 'اللغة', _language, _pickLanguage),

          const SizedBox(height: 20),
          _sectionLabel('الإشعارات'),
          _switchTile(Icons.notifications_active_outlined, 'إشعارات التطبيق', _pushNotifications, (v) => setState(() => _pushNotifications = v)),
          _switchTile(Icons.email_outlined, 'إشعارات البريد الإلكتروني', _emailNotifications, (v) => setState(() => _emailNotifications = v)),

          const SizedBox(height: 20),
          _sectionLabel('عن التطبيق'),
          _navTile(Icons.info_outline, 'عن رحلاتي', 'الإصدار 1.0.0', () {}),
          _navTile(Icons.privacy_tip_outlined, 'سياسة الخصوصية', '', () {}),
          _navTile(Icons.description_outlined, 'الشروط والأحكام', '', () {}),
          _navTile(Icons.star_outline_rounded, 'قيّم التطبيق', '', () {}),

          const SizedBox(height: 26),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, color: AppColors.danger),
              label: const Text('تسجيل الخروج', style: TextStyle(color: AppColors.danger)),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.danger), padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textGrey, fontSize: 13)),
      );

  Widget _switchTile(IconData icon, String label, bool value, ValueChanged<bool> onChanged) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.primary),
        title: Text(label, style: const TextStyle(fontSize: 14)),
        value: value,
        activeThumbColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }

  Widget _navTile(IconData icon, String label, String trailingText, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: const TextStyle(fontSize: 14)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText.isNotEmpty) Text(trailingText, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_back_ios_new, size: 13, color: AppColors.textGrey),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
