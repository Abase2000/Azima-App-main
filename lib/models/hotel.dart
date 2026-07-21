class HotelModel {
  final String id;
  final String name;
  final String city;
  final String country;
  final String address;
  final String description;
  final double rating;
  final int reviewsCount;
  final double pricePerNight;
  final String imageUrl;
  final List<String> amenities;
  final String roomType;

  HotelModel({
    required this.id,
    required this.name,
    required this.city,
    required this.country,
    required this.address,
    required this.description,
    required this.rating,
    required this.reviewsCount,
    required this.pricePerNight,
    required this.imageUrl,
    required this.amenities,
    required this.roomType,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.0,
      reviewsCount: json['reviews_count'] ?? 0,
      pricePerNight: (json['price_per_night'] as num).toDouble(),
      imageUrl: json['image_url'] ?? '',
      amenities: (json['amenities'] as String? ?? '')
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      roomType: json['room_type'] ?? 'غرفة مزدوجة',
    );
  }
}
