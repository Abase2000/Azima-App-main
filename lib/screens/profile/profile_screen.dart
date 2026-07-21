import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/session_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../auth/login_screen.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppUser? _user;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = await SessionService.getUser();
    if (mounted) setState(() => _user = user);
  }

  Future<void> _logout() async {
    await SessionService.clear();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
  }

  void _openEditSheet() {
    final nameCtrl = TextEditingController(text: _user?.name);
    final phoneCtrl = TextEditingController(text: _user?.phone);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('تعديل البيانات الشخصية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            CustomTextField(controller: nameCtrl, label: 'الاسم الكامل', icon: Icons.person_outline),
            const SizedBox(height: 14),
            CustomTextField(controller: phoneCtrl, label: 'رقم الهاتف', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 18),
            PrimaryButton(
              label: 'حفظ التغييرات',
              onPressed: () async {
                if (_user != null) {
                  final updated = AppUser(id: _user!.id, name: nameCtrl.text, email: _user!.email, phone: phoneCtrl.text);
                  // TODO(Person 1): استبدل هذا باستدعاء ApiService.updateProfile الحقيقي
                  await SessionService.saveUser(updated);
                  setState(() => _user = updated);
                }
                if (mounted) Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حسابي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: _user == null
          ? Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())),
                child: const Text('تسجيل الدخول'),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: AppColors.primary,
                        child: Text(_user!.name.isNotEmpty ? _user!.name[0].toUpperCase() : '؟',
                            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                      ),
                      Positioned(
                        bottom: 0, left: 0,
                        child: GestureDetector(
                          onTap: _openEditSheet,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                            child: const Icon(Icons.edit, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Center(child: Text(_user!.name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                Center(child: Text(_user!.email, style: const TextStyle(color: AppColors.textGrey))),
                const SizedBox(height: 28),
                _tile(Icons.person_outline, 'تعديل البيانات الشخصية', _openEditSheet),
                _tile(Icons.lock_outline, 'تغيير كلمة المرور', () {}),
                _tile(Icons.credit_card_outlined, 'وسائل الدفع', () {}),
                _tile(Icons.notifications_none_rounded, 'الإشعارات', () {}),
                _tile(Icons.settings_outlined, 'الإعدادات', () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()))),
                _tile(Icons.help_outline_rounded, 'المساعدة والدعم', () {}),
                const SizedBox(height: 16),
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

  Widget _tile(IconData icon, String label, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: const TextStyle(fontSize: 14)),
        trailing: const Icon(Icons.arrow_back_ios_new, size: 14, color: AppColors.textGrey),
        onTap: onTap,
      ),
    );
  }
}
