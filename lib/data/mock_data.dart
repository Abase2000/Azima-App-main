import '../models/flight.dart';
import '../models/hotel.dart';
import '../models/booking_item.dart';
import '../models/booking_record.dart';

/// بيانات تجريبية (Mock) — تُستخدم مؤقتًا لعرض الواجهة قبل ربطها
/// بالـ APIs الحقيقية من Person 1 (Auth) وPerson 2 (Flights) وPerson 3 (Hotels).
class MockData {
  static List<FlightModel> flights() {
    final now = DateTime.now();
    return [
      FlightModel(
        id: 'F1',
        airline: 'مصر للطيران',
        airlineLogo: '✈️',
        flightNumber: 'MS 785',
        originCity: 'القاهرة',
        originCode: 'CAI',
        destinationCity: 'دبي',
        destinationCode: 'DXB',
        departureTime: DateTime(now.year, now.month, now.day + 2, 8, 30),
        arrivalTime: DateTime(now.year, now.month, now.day + 2, 12, 45),
        stops: 0,
        price: 320,
        cabinClass: 'اقتصادية',
      ),
      FlightModel(
        id: 'F2',
        airline: 'الإمارات',
        airlineLogo: '🛫',
        flightNumber: 'EK 924',
        originCity: 'القاهرة',
        originCode: 'CAI',
        destinationCity: 'دبي',
        destinationCode: 'DXB',
        departureTime: DateTime(now.year, now.month, now.day + 2, 14, 0),
        arrivalTime: DateTime(now.year, now.month, now.day + 2, 18, 40),
        stops: 1,
        price: 410,
        cabinClass: 'اقتصادية',
      ),
      FlightModel(
        id: 'F3',
        airline: 'طيران الخليج',
        airlineLogo: '🛩️',
        flightNumber: 'GF 152',
        originCity: 'القاهرة',
        originCode: 'CAI',
        destinationCity: 'دبي',
        destinationCode: 'DXB',
        departureTime: DateTime(now.year, now.month, now.day + 2, 22, 15),
        arrivalTime: DateTime(now.year, now.month, now.day + 3, 3, 10),
        stops: 1,
        price: 275,
        cabinClass: 'اقتصادية',
      ),
      FlightModel(
        id: 'F4',
        airline: 'الاتحاد للطيران',
        airlineLogo: '✈️',
        flightNumber: 'EY 653',
        originCity: 'القاهرة',
        originCode: 'CAI',
        destinationCity: 'دبي',
        destinationCode: 'DXB',
        departureTime: DateTime(now.year, now.month, now.day + 2, 6, 0),
        arrivalTime: DateTime(now.year, now.month, now.day + 2, 10, 20),
        stops: 0,
        price: 355,
        cabinClass: 'رجال أعمال',
      ),
    ];
  }

  static List<HotelModel> hotels() {
    return [
      HotelModel(
        id: 'H1',
        name: 'فندق النخيل الذهبي',
        city: 'القاهرة',
        country: 'مصر',
        address: 'شارع النيل، القاهرة',
        description: 'فندق فاخر يطل على نهر النيل مع خدمات عالمية ومسبح على السطح.',
        rating: 4.7,
        reviewsCount: 812,
        pricePerNight: 120,
        imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
        amenities: ['واي فاي مجاني', 'مسبح', 'سبا', 'موقف سيارات'],
        roomType: 'غرفة مزدوجة ديلوكس',
      ),
      HotelModel(
        id: 'H2',
        name: 'منتجع اللؤلؤة الزرقاء',
        city: 'شرم الشيخ',
        country: 'مصر',
        address: 'خليج نعمة، شرم الشيخ',
        description: 'منتجع شاطئي هادئ مثالي للغطس والاسترخاء مع شاطئ خاص.',
        rating: 4.8,
        reviewsCount: 1204,
        pricePerNight: 180,
        imageUrl: 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=800',
        amenities: ['شاطئ خاص', 'غطس', 'مطعم', 'واي فاي'],
        roomType: 'غرفة مطلة على البحر',
      ),
      HotelModel(
        id: 'H3',
        name: 'فندق برج المدينة',
        city: 'دبي',
        country: 'الإمارات',
        address: 'شارع الشيخ زايد، دبي',
        description: 'فندق حديث في قلب دبي بإطلالات بانورامية على المدينة.',
        rating: 4.9,
        reviewsCount: 2130,
        pricePerNight: 250,
        imageUrl: 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=800',
        amenities: ['صالة رياضية', 'مطاعم فاخرة', 'خدمة كونسيرج'],
        roomType: 'جناح تنفيذي',
      ),
      HotelModel(
        id: 'H4',
        name: 'نزل الياسمين',
        city: 'إسطنبول',
        country: 'تركيا',
        address: 'منطقة السلطان أحمد، إسطنبول',
        description: 'نزل تقليدي بأجواء عثمانية أصيلة بالقرب من المعالم التاريخية.',
        rating: 4.5,
        reviewsCount: 540,
        pricePerNight: 90,
        imageUrl: 'https://images.unsplash.com/photo-1541971875076-8f970d573be6?w=800',
        amenities: ['إفطار مجاني', 'واي فاي', 'إطلالة على المدينة'],
        roomType: 'غرفة كلاسيكية',
      ),
    ];
  }

  static List<BookingRecord> bookingHistory() {
    final now = DateTime.now();
    return [
      BookingRecord(
        id: 'BK1001',
        type: BookingType.flight,
        title: 'مصر للطيران — MS 785',
        subtitle: 'القاهرة → دبي',
        imageUrl: '',
        date: now.add(const Duration(days: 5)),
        totalPrice: 320,
        status: BookingStatus.upcoming,
        referenceCode: 'RH-8841',
      ),
      BookingRecord(
        id: 'BK1002',
        type: BookingType.hotel,
        title: 'منتجع اللؤلؤة الزرقاء',
        subtitle: 'شرم الشيخ، مصر',
        imageUrl: 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=800',
        date: now.add(const Duration(days: 10)),
        endDate: now.add(const Duration(days: 14)),
        totalPrice: 720,
        status: BookingStatus.upcoming,
        referenceCode: 'RH-7723',
      ),
      BookingRecord(
        id: 'BK0987',
        type: BookingType.hotel,
        title: 'فندق برج المدينة',
        subtitle: 'دبي، الإمارات',
        imageUrl: 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=800',
        date: now.subtract(const Duration(days: 40)),
        endDate: now.subtract(const Duration(days: 36)),
        totalPrice: 1000,
        status: BookingStatus.completed,
        referenceCode: 'RH-5510',
      ),
      BookingRecord(
        id: 'BK0954',
        type: BookingType.flight,
        title: 'الإمارات — EK 924',
        subtitle: 'دبي → القاهرة',
        imageUrl: '',
        date: now.subtract(const Duration(days: 60)),
        totalPrice: 410,
        status: BookingStatus.cancelled,
        referenceCode: 'RH-4402',
      ),
    ];
  }
}
