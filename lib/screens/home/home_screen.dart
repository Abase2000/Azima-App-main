import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/flight.dart';
import '../../models/hotel.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/flight_card.dart';
import '../../widgets/hotel_card.dart';
import '../../widgets/section_title.dart';
import '../booking/booking_screen.dart';
import '../hotels/hotel_results_screen.dart';
import '../search/search_screen.dart';
import '../support/support_screen.dart';
import '../../models/booking_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<FlightModel>> _flightsFuture;
  late Future<List<HotelModel>> _hotelsFuture;

  @override
  void initState() {
    super.initState();
    _flightsFuture = ApiService.searchFlights();
    _hotelsFuture = ApiService.searchHotels();
  }

  void _openFlightBooking(FlightModel f) {
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
            'التاريخ': '${f.departureTime.year}-${f.departureTime.month}-${f.departureTime.day}',
            'الدرجة': f.cabinClass,
            'التوقفات': f.stopsLabel,
          },
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _flightsFuture = ApiService.searchFlights();
              _hotelsFuture = ApiService.searchHotels();
            });
          },
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 22, backgroundColor: AppColors.primary, child: Icon(Icons.person, color: Colors.white)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('أهلًا بعودتك 👋', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                        Text('إلى أين رحلتك القادمة؟', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
                  IconButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SupportScreen())),
                    icon: const Icon(Icons.headset_mic_outlined),
                    tooltip: 'الدعم الفني الذكي',
                  ),
                ],
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen())),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: AppColors.textGrey),
                      SizedBox(width: 10),
                      Text('ابحث عن رحلة أو فندق...', style: TextStyle(color: AppColors.textGrey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('عروض الصيف 🌴', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 6),
                          Text('خصم يصل إلى 25% على حجوزات الفنادق', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 36),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              SectionTitle(
                title: 'رحلات مقترحة',
                actionLabel: 'عرض الكل',
                onAction: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen(initialTab: 0))),
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<FlightModel>>(
                future: _flightsFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return _shimmerList();
                  final flights = snapshot.data!.take(3).toList();
                  return Column(
                    children: flights
                        .map((f) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: FlightCard(flight: f, onTap: () => _openFlightBooking(f)),
                            ))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 14),
              SectionTitle(
                title: 'فنادق مميزة',
                actionLabel: 'عرض الكل',
                onAction: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HotelResultsScreen())),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: FutureBuilder<List<HotelModel>>(
                  future: _hotelsFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade200,
                        highlightColor: Colors.grey.shade100,
                        child: Row(children: List.generate(3, (i) => Container(
                          width: 160, margin: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        ))),
                      );
                    }
                    final hotels = snapshot.data!;
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: hotels.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final h = hotels[index];
                        return SizedBox(
                          width: 170,
                          child: HotelCard(
                            hotel: h,
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => BookingScreen(
                                item: BookingItem(
                                  type: BookingType.hotel,
                                  refId: h.id,
                                  title: h.name,
                                  subtitle: '${h.city}, ${h.country}',
                                  imageUrl: h.imageUrl,
                                  unitPrice: h.pricePerNight,
                                  priceLabel: 'لليلة',
                                  details: {'نوع الغرفة': h.roomType, 'التقييم': '${h.rating} ⭐'},
                                ),
                              ),
                            )),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(2, (i) => Container(
          height: 130,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        )),
      ),
    );
  }
}
