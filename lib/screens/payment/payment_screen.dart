import 'package:flutter/material.dart';
import '../../models/booking_item.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import 'payment_success_screen.dart';

enum PaymentMethod { card, wallet, cashOnArrival }

class PaymentScreen extends StatefulWidget {
  final BookingItem item;
  final double totalAmount;
  final Map<String, String> summary;

  const PaymentScreen({super.key, required this.item, required this.totalAmount, required this.summary});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod _method = PaymentMethod.card;
  final _cardNumberCtrl = TextEditingController();
  final _cardNameCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  bool _processing = false;

  Future<void> _pay() async {
    setState(() => _processing = true);
    try {
      // TODO(Payment Integration): استبدل هذا باستدعاء بوابة الدفع الحقيقية
      final result = await ApiService.processPayment({
        'booking_ref': widget.item.refId,
        'amount': widget.totalAmount,
        'method': _method.name,
      });
      if (!mounted) return;
      if (result['success'] == true) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(
            item: widget.item,
            totalAmount: widget.totalAmount,
            transactionId: result['transaction_id'],
          ),
        ));
      }
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدفع')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(14)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('المبلغ الإجمالي', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                Text('${widget.totalAmount.toStringAsFixed(0)}\$', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: AppColors.primaryDark)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('اختر طريقة الدفع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          _paymentOption(PaymentMethod.card, Icons.credit_card, 'بطاقة ائتمان / خصم'),
          const SizedBox(height: 10),
          _paymentOption(PaymentMethod.wallet, Icons.account_balance_wallet_outlined, 'محفظة إلكترونية'),
          const SizedBox(height: 10),
          _paymentOption(PaymentMethod.cashOnArrival, Icons.payments_outlined, 'الدفع عند الوصول'),

          if (_method == PaymentMethod.card) ...[
            const SizedBox(height: 24),
            const Text('بيانات البطاقة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 14),
            CustomTextField(
              controller: _cardNumberCtrl, label: 'رقم البطاقة', icon: Icons.credit_card,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
            CustomTextField(controller: _cardNameCtrl, label: 'الاسم كما يظهر على البطاقة', icon: Icons.badge_outlined),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: CustomTextField(controller: _expiryCtrl, label: 'MM/YY', icon: Icons.calendar_month_outlined)),
                const SizedBox(width: 12),
                Expanded(child: CustomTextField(controller: _cvvCtrl, label: 'CVV', icon: Icons.lock_outline, obscure: true, keyboardType: TextInputType.number)),
              ],
            ),
          ],

          if (_method == PaymentMethod.wallet) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
              child: const Row(children: [
                Icon(Icons.info_outline, color: AppColors.textGrey, size: 18),
                SizedBox(width: 8),
                Expanded(child: Text('سيتم تحويلك لتطبيق المحفظة الإلكترونية لإتمام الدفع بأمان', style: TextStyle(fontSize: 12, color: AppColors.textGrey))),
              ]),
            ),
          ],

          if (_method == PaymentMethod.cashOnArrival) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
              child: const Row(children: [
                Icon(Icons.info_outline, color: AppColors.textGrey, size: 18),
                SizedBox(width: 8),
                Expanded(child: Text('يمكنك الدفع نقدًا عند الوصول أو تسجيل الدخول للفندق', style: TextStyle(fontSize: 12, color: AppColors.textGrey))),
              ]),
            ),
          ],

          const SizedBox(height: 30),
          PrimaryButton(
            label: 'تأكيد الدفع (${widget.totalAmount.toStringAsFixed(0)}\$)',
            icon: Icons.lock_outline,
            loading: _processing,
            onPressed: _pay,
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user_outlined, size: 14, color: AppColors.textGrey),
              SizedBox(width: 6),
              Text('معاملة آمنة ومشفرة بالكامل', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _paymentOption(PaymentMethod method, IconData icon, String label) {
    final selected = _method == method;
    return GestureDetector(
      onTap: () => setState(() => _method = method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: selected ? 1.6 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? AppColors.primary : AppColors.textGrey),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal))),
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? AppColors.primary : AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
