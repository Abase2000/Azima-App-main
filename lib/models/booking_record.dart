import 'booking_item.dart';

enum BookingStatus { upcoming, completed, cancelled }

class BookingRecord {
  final String id;
  final BookingType type;
  final String title;
  final String subtitle;
  final String imageUrl;
  final DateTime date;
  final DateTime? endDate;
  final double totalPrice;
  final BookingStatus status;
  final String referenceCode;

  BookingRecord({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.date,
    this.endDate,
    required this.totalPrice,
    required this.status,
    required this.referenceCode,
  });
}
