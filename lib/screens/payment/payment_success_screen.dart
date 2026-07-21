import 'package:flutter/material.dart';
import '../../models/booking_item.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import '../home/main_navigation.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final BookingItem item;
  final double totalAmount;
  final String transactionId;

  const PaymentSuccessScreen({super.key, required this.item, required this.totalAmount, required this.transactionId});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
  late final Animation<double> _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scale,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 72),
                ),
              ),
              const SizedBox(height: 24),
              const Text('تم تأكيد حجزك بنجاح! 🎉', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primaryDark)),
              const SizedBox(height: 8),
              const Text('سيتم إرسال تفاصيل الحجز إلى بريدك الإلكتروني', textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textGrey)),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                child: Column(
                  children: [
                    _row('العنصر', widget.item.title),
                    const Divider(height: 20),
                    _row('رقم العملية', widget.transactionId),
                    const Divider(height: 20),
                    _row('المبلغ المدفوع', '${widget.totalAmount.toStringAsFixed(0)}\$'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'عرض حجوزاتي',
                icon: Icons.receipt_long_outlined,
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MainNavigation()),
                  (route) => false,
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MainNavigation()),
                  (route) => false,
                ),
                child: const Text('العودة للرئيسية', style: TextStyle(color: AppColors.textGrey)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
        Flexible(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.end)),
      ],
    );
  }
}
