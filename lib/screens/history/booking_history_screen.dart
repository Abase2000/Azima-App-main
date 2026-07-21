import 'package:flutter/material.dart';
import '../../models/booking_record.dart';
import '../../models/booking_item.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/status_chip.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);
  late Future<List<BookingRecord>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.getBookingHistory();
  }

  Future<void> _refresh() async {
    setState(() => _future = ApiService.getBookingHistory());
  }

  Future<void> _cancel(BookingRecord b) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الإلغاء'),
        content: Text('هل أنت متأكد من رغبتك في إلغاء حجز "${b.title}"؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('تراجع')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('نعم، إلغاء', style: TextStyle(color: AppColors.danger))),
        ],
      ),
    );
    if (confirmed == true) {
      // TODO(Person 2/3): استدعاء ApiService.cancelBooking(b.id) الحقيقي
      await ApiService.cancelBooking(b.id);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حجوزاتي'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textGrey,
          indicatorColor: AppColors.primary,
          tabs: const [Tab(text: 'القادمة'), Tab(text: 'المكتملة'), Tab(text: 'الملغاة')],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<BookingRecord>>(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final all = snapshot.data!;
            return TabBarView(
              controller: _tabController,
              children: [
                _list(all.where((b) => b.status == BookingStatus.upcoming).toList()),
                _list(all.where((b) => b.status == BookingStatus.completed).toList()),
                _list(all.where((b) => b.status == BookingStatus.cancelled).toList()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _list(List<BookingRecord> items) {
    if (items.isEmpty) {
      return const EmptyState(icon: Icons.receipt_long_outlined, message: 'لا توجد حجوزات هنا حاليًا');
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _bookingCard(items[index]),
    );
  }

  Widget _bookingCard(BookingRecord b) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                  child: Icon(b.type == BookingType.flight ? Icons.flight_rounded : Icons.apartment_rounded, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(b.subtitle, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                    ],
                  ),
                ),
                StatusChip(status: b.status),
              ],
            ),
            const Divider(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('رقم الحجز: ${b.referenceCode}', style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                Text('${b.totalPrice.toStringAsFixed(0)}\$', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary)),
              ],
            ),
            if (b.status == BookingStatus.upcoming) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _cancel(b),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.danger),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('إلغاء الحجز', style: TextStyle(color: AppColors.danger, fontSize: 13)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
