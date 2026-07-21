enum BookingType { flight, hotel }

/// عنصر وسيط يحمل بيانات العنصر المختار (رحلة/فندق) من شاشة النتائج
/// إلى شاشة الحجز، دون الحاجة لتمرير الموديل الكامل في كل شاشة.
class BookingItem {
  final BookingType type;
  final String refId;
  final String title; // اسم شركة الطيران أو اسم الفندق
  final String subtitle; // مسار الرحلة أو موقع الفندق
  final String imageUrl;
  final double unitPrice; // سعر التذكرة أو سعر الليلة
  final String priceLabel; // "للتذكرة" أو "لليلة"
  final Map<String, String> details; // تفاصيل إضافية تُعرض كملخص

  BookingItem({
    required this.type,
    required this.refId,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.unitPrice,
    required this.priceLabel,
    required this.details,
  });
}
