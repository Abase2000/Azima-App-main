import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/hotel.dart';
import '../../models/booking_item.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/hotel_card.dart';
import '../booking/booking_screen.dart';

class HotelResultsScreen extends StatefulWidget {
  final String initialCity;
  const HotelResultsScreen({super.key, this.initialCity = ''});

  @override
  State<HotelResultsScreen> createState() => _HotelResultsScreenState();
}

class _HotelResultsScreenState extends State<HotelResultsScreen> {
  late Future<List<HotelModel>> _future;
  late TextEditingController _cityCtrl;
  RangeValues _priceRange = const RangeValues(0, 400);

  @override
  void initState() {
    super.initState();
    _cityCtrl = TextEditingController(text: widget.initialCity);
    _future = ApiService.searchHotels(city: widget.initialCity);
  }

  void _openBooking(HotelModel h) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BookingScreen(
        item: BookingItem(
          type: BookingType.hotel,
          refId: h.id,
          title: h.name,
          subtitle: '${h.city}, ${h.country}',
          imageUrl: h.imageUrl,
          unitPrice: h.pricePerNight,
          priceLabel: 'لليلة',
          details: {'نوع الغرفة': h.roomType, 'التقييم': '${h.rating} ⭐ (${h.reviewsCount} تقييم)'},
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نتائج الفنادق')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: TextField(
              controller: _cityCtrl,
              decoration: InputDecoration(
                hintText: 'ابحث بالمدينة',
                prefixIcon: const Icon(Icons.location_city_outlined),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => setState(() => _future = ApiService.searchHotels(city: _cityCtrl.text)),
                ),
              ),
              onSubmitted: (v) => setState(() => _future = ApiService.searchHotels(city: v)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('نطاق السعر لليلة:', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                const Spacer(),
                Text('${_priceRange.start.toInt()}\$ - ${_priceRange.end.toInt()}\$',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          RangeSlider(
            values: _priceRange,
            min: 0, max: 400, divisions: 20,
            activeColor: AppColors.primary,
            labels: RangeLabels('${_priceRange.start.toInt()}\$', '${_priceRange.end.toInt()}\$'),
            onChanged: (v) => setState(() => _priceRange = v),
          ),
          Expanded(
            child: FutureBuilder<List<HotelModel>>(
              future: _future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 0.72),
                      itemCount: 4,
                      itemBuilder: (c, i) => Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
                    ),
                  );
                }
                final hotels = snapshot.data!
                    .where((h) => h.pricePerNight >= _priceRange.start && h.pricePerNight <= _priceRange.end)
                    .toList();
                if (hotels.isEmpty) {
                  return const EmptyState(icon: Icons.apartment_outlined, message: 'لا توجد فنادق مطابقة لبحثك');
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 0.68),
                  itemCount: hotels.length,
                  itemBuilder: (context, index) => HotelCard(hotel: hotels[index], onTap: () => _openBooking(hotels[index])),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
