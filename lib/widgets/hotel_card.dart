import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../theme/app_theme.dart';

class HotelCard extends StatelessWidget {
  final HotelModel hotel;
  final VoidCallback onTap;
  final bool horizontal;

  const HotelCard({super.key, required this.hotel, required this.onTap, this.horizontal = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: horizontal ? _horizontalLayout() : _verticalLayout(),
      ),
    );
  }

  Widget _image() {
    return Image.network(
      hotel.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (c, e, s) => Container(color: Colors.grey.shade200, child: const Icon(Icons.image_not_supported_outlined)),
      loadingBuilder: (c, child, progress) {
        if (progress == null) return child;
        return Container(color: Colors.grey.shade100, child: const Center(child: CircularProgressIndicator(strokeWidth: 2)));
      },
    );
  }

  Widget _ratingBadge() {
    return Positioned(
      top: 10, right: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.95), borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.star, size: 12, color: AppColors.accentDark),
          const SizedBox(width: 3),
          Text('${hotel.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
        ]),
      ),
    );
  }

  Widget _verticalLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(children: [SizedBox(height: 150, width: double.infinity, child: _image()), _ratingBadge()]),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(hotel.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textGrey),
                Expanded(child: Text(' ${hotel.city}, ${hotel.country}', style: const TextStyle(color: AppColors.textGrey, fontSize: 11), overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height: 8),
              Text('${hotel.pricePerNight.toStringAsFixed(0)}\$ / ليلة', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _horizontalLayout() {
    return SizedBox(
      height: 120,
      child: Row(
        children: [
          Stack(children: [SizedBox(height: 120, width: 110, child: _image()), _ratingBadge()]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(hotel.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('${hotel.city}, ${hotel.country}', style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                  const SizedBox(height: 8),
                  Text('${hotel.pricePerNight.toStringAsFixed(0)}\$ / ليلة', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary, fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
