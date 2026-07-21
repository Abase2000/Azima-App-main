import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  bool _agree = true;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى الموافقة على الشروط والأحكام'), backgroundColor: AppColors.warning),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      // TODO(Person 1): استبدل هذا باستدعاء ApiService.register الحقيقي
      final result = await ApiService.register(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      if (!mounted) return;
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إنشاء الحساب بنجاح! يمكنك تسجيل الدخول الآن'), backgroundColor: AppColors.success),
        );
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب جديد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _nameCtrl, label: 'الاسم الكامل', icon: Icons.person_outline,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'أدخل اسمك' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailCtrl, label: 'البريد الإلكتروني', icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => (v == null || !v.contains('@')) ? 'أدخل بريدًا إلكترونيًا صحيحًا' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _phoneCtrl, label: 'رقم الهاتف', icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordCtrl, label: 'كلمة المرور', icon: Icons.lock_outline, obscure: true,
                validator: (v) => (v == null || v.length < 4) ? 'كلمة المرور قصيرة جدًا' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(value: _agree, activeColor: AppColors.primary, onChanged: (v) => setState(() => _agree = v ?? false)),
                  const Expanded(child: Text('أوافق على الشروط والأحكام وسياسة الخصوصية', style: TextStyle(fontSize: 12, color: AppColors.textGrey))),
                ],
              ),
              const SizedBox(height: 18),
              PrimaryButton(label: 'إنشاء الحساب', onPressed: _register, loading: _loading),
            ],
          ),
        ),
      ),
    );
  }
}
