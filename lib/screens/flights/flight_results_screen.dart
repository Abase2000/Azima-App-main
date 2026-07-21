import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/flight.dart';
import '../../models/booking_item.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/flight_card.dart';
import '../booking/booking_screen.dart';

class FlightResultsScreen extends StatefulWidget {
  final String origin;
  final String destination;
  const FlightResultsScreen({super.key, this.origin = '', this.destination = ''});

  @override
  State<FlightResultsScreen> createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends State<FlightResultsScreen> {
  late Future<List<FlightModel>> _future;
  String _sortBy = 'price';

  @override
  void initState() {
    super.initState();
    _future = ApiService.searchFlights(origin: widget.origin, destination: widget.destination);
  }

  void _openBooking(FlightModel f) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BookingScreen(
        item: BookingItem(
          type: BookingType.flight,
          refId: f.id,
          title: '${f.airline} — ${f.flightNumber}',
          subtitle: '${f.originCity} → ${f.destinationCity}',
          imageUrl: '',
          unitPrice: f.price,
          priceLabel: 'للتذكرة',
          details: {
            'موعد المغادرة': '${f.departureTime.hour}:${f.departureTime.minute.toString().padLeft(2, '0')}',
            'الدرجة': f.cabinClass,
            'التوقفات': f.stopsLabel,
          },
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.origin.isEmpty ? 'نتائج البحث' : '${widget.origin} → ${widget.destination}';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.sort, size: 18, color: AppColors.textGrey),
                const SizedBox(width: 6),
                const Text('ترتيب حسب:', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('السعر'),
                  selected: _sortBy == 'price',
                  onSelected: (_) => setState(() => _sortBy = 'price'),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('المدة'),
                  selected: _sortBy == 'duration',
                  onSelected: (_) => setState(() => _sortBy = 'duration'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<FlightModel>>(
              future: _future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: List.generate(3, (i) => Container(
                        height: 150, margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      )),
                    ),
                  );
                }
                var flights = List<FlightModel>.from(snapshot.data!);
                if (_sortBy == 'price') {
                  flights.sort((a, b) => a.price.compareTo(b.price));
                } else {
                  flights.sort((a, b) => a.duration.compareTo(b.duration));
                }
                if (flights.isEmpty) {
                  return const EmptyState(icon: Icons.flight_outlined, message: 'لا توجد رحلات مطابقة لبحثك');
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: flights.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) => FlightCard(flight: flights[index], onTap: () => _openBooking(flights[index])),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
