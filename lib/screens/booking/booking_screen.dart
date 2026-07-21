import 'package:flutter/material.dart';
import '../../models/booking_item.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../payment/payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final BookingItem item;
  const BookingScreen({super.key, required this.item});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  int _quantity = 1; // عدد المسافرين أو عدد الليالي حسب النوع
  DateTime? _checkIn;
  DateTime? _checkOut;

  bool get _isHotel => widget.item.type == BookingType.hotel;

  int get _units {
    if (_isHotel) {
      if (_checkIn == null || _checkOut == null) return 0;
      final n = _checkOut!.difference(_checkIn!).inDays;
      return n < 1 ? 1 : n;
    }
    return _quantity;
  }

  double get _total => widget.item.unitPrice * (_units == 0 ? 1 : _units);

  Future<void> _pickDate({required bool isCheckIn}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() {
      if (isCheckIn) {
        _checkIn = picked;
        if (_checkOut != null && !_checkOut!.isAfter(_checkIn!)) _checkOut = null;
      } else {
        _checkOut = picked;
      }
    });
  }

  void _continueToPayment() {
    if (!_formKey.currentState!.validate()) return;
    if (_isHotel && (_checkIn == null || _checkOut == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار تاريخ الوصول والمغادرة'), backgroundColor: AppColors.warning),
      );
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PaymentScreen(
        item: widget.item,
        totalAmount: _total,
        summary: {
          'الاسم': _nameCtrl.text,
          if (_isHotel) 'المدة': '$_units ليالي' else 'عدد المسافرين': '$_quantity',
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الحجز')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ملخص العنصر
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 54, height: 54,
                      decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                      child: Icon(_isHotel ? Icons.apartment_rounded : Icons.flight_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(item.subtitle, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text('${item.unitPrice.toStringAsFixed(0)}\$', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ...item.details.entries.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.key, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                        Text(e.value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                  )),

              const SizedBox(height: 26),
              const Text('بيانات المسافر', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 14),
              CustomTextField(
                controller: _nameCtrl, label: 'الاسم الكامل', icon: Icons.person_outline,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'أدخل الاسم' : null,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: _emailCtrl, label: 'البريد الإلكتروني', icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => (v == null || !v.contains('@')) ? 'أدخل بريدًا صحيحًا' : null,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: _phoneCtrl, label: 'رقم الهاتف', icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'أدخل رقم الهاتف' : null,
              ),

              const SizedBox(height: 26),
              if (_isHotel) ...[
                const Text('تواريخ الإقامة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _dateBox('تاريخ الوصول', _checkIn, () => _pickDate(isCheckIn: true))),
                    const SizedBox(width: 10),
                    Expanded(child: _dateBox('تاريخ المغادرة', _checkOut, () => _pickDate(isCheckIn: false))),
                  ],
                ),
              ] else ...[
                const Text('عدد المسافرين', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    children: [
                      const Icon(Icons.people_outline, color: AppColors.textGrey),
                      const SizedBox(width: 10),
                      Expanded(child: Text('$_quantity مسافر')),
                      IconButton(onPressed: () => setState(() => _quantity = _quantity > 1 ? _quantity - 1 : 1), icon: const Icon(Icons.remove_circle_outline)),
                      IconButton(onPressed: () => setState(() => _quantity++), icon: const Icon(Icons.add_circle_outline)),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFF5F0E8), borderRadius: BorderRadius.circular(14)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('${_total.toStringAsFixed(0)}\$', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.primaryDark)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(label: 'المتابعة إلى الدفع', icon: Icons.arrow_back, onPressed: _continueToPayment),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateBox(String label, DateTime? date, VoidCallback onTap) {
    final text = date == null ? 'اختر التاريخ' : '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
            const SizedBox(height: 4),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
