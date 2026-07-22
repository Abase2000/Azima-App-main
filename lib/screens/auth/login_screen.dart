import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import '../../services/session_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../home/main_navigation.dart';
import 'register_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
            final result = await ApiService.login(email: _emailCtrl.text.trim(), password: _passwordCtrl.text);
      if (result['success'] == true) {
        await SessionService.saveUser(AppUser.fromJson(result['user']));
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainNavigation()),
          (route) => false,
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'فشل تسجيل الدخول. يرجى المحاولة مرة أخرى.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Hero(tag: 'app-logo', child: Icon(Icons.flight_takeoff_rounded, size: 66, color: AppColors.primary)),
                  const SizedBox(height: 12),
                  const Text('تسجيل الدخول', textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primaryDark)),
                  const SizedBox(height: 6),
                  const Text('سجّل الدخول لمتابعة رحلاتك وحجوزاتك',
                      textAlign: TextAlign.center, style: TextStyle(color: AppColors.textGrey)),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: _emailCtrl,
                    label: 'البريد الإلكتروني',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => (v == null || !v.contains('@')) ? 'أدخل بريدًا إلكترونيًا صحيحًا' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordCtrl,
                    label: 'كلمة المرور',
                    icon: Icons.lock_outline,
                    obscure: _obscure,
                    suffix: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                    validator: (v) => (v == null || v.length < 4) ? 'كلمة المرور قصيرة جدًا' : null,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => _showForgotPasswordSheet(context),
                      child: const Text('نسيت كلمة المرور؟', style: TextStyle(color: AppColors.textGrey)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  PrimaryButton(label: 'دخول', onPressed: _login, loading: _loading),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('ليس لديك حساب؟', style: TextStyle(color: AppColors.textGrey)),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen())),
                        child: const Text('أنشئ حسابًا جديدًا', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _showForgotPasswordSheet(BuildContext context) {
    final emailCtrl = TextEditingController();
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
            const Text('استعادة كلمة المرور', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 6),
            const Text('أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة التعيين', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
            const SizedBox(height: 16),
            CustomTextField(controller: emailCtrl, label: 'البريد الإلكتروني', icon: Icons.email_outlined),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'إرسال رابط الاستعادة',
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إرسال رابط استعادة كلمة المرور إلى بريدك')),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
