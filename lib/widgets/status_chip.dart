import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/booking_record.dart';

class StatusChip extends StatelessWidget {
  final BookingStatus status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late Color color;
    late String label;
    switch (status) {
      case BookingStatus.upcoming:
        color = AppColors.primary;
        label = 'قادم';
        break;
      case BookingStatus.completed:
        color = AppColors.success;
        label = 'مكتمل';
        break;
      case BookingStatus.cancelled:
        color = AppColors.danger;
        label = 'ملغي';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}
