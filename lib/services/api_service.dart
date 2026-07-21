import 'dart:async';
import '../models/user.dart';
import '../models/flight.dart';
import '../models/hotel.dart';
import '../models/booking_record.dart';
import '../data/mock_data.dart';

/// =====================================================================
/// طبقة الاتصال بالـ API — مسؤولية التكامل فقط (بدون منطق Backend).
/// كل دالة هنا تعيد حاليًا بيانات وهمية (Mock) مع تأخير بسيط لمحاكاة الشبكة،
/// بحيث تعمل الواجهة بشكل كامل الآن. عند جاهزية الـ Endpoints الحقيقية من:
///   - Person 1 (Auth & Users)
///   - Person 2 (Flights & Bookings)
///   - Person 3 (Hotels & Reservations)
/// استبدل جسم كل دالة باستدعاء http الحقيقي (راظر التعليق TODO أعلى كل دالة).
/// عنوان الخادم الأساسي يوضع هنا مرة واحدة فقط.
/// =====================================================================
class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000'; // TODO: عدّله حسب بيئة التشغيل

  // ------------------ Auth (Person 1) ------------------
  // TODO: POST $baseUrl/api/login  { email, password } -> { success, user, token }
  static Future<Map<String, dynamic>> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return {
      'success': true,
      'user': AppUser(id: 'U1', name: 'محمد أحمد', email: email, phone: '+20 100 000 0000').toJson(),
    };
  }

  // TODO: POST $baseUrl/api/register { name, email, phone, password } -> { success, user, token }
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return {
      'success': true,
      'user': AppUser(id: 'U1', name: name, email: email, phone: phone).toJson(),
    };
  }

  // TODO: POST $baseUrl/api/password-reset { email }
  static Future<bool> requestPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }

  // TODO: PUT $baseUrl/api/users/me { name, phone, avatar }
  static Future<bool> updateProfile(AppUser user) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }

  // ------------------ Flights (Person 2) ------------------
  // TODO: GET $baseUrl/api/flights?origin=&destination=&date=
  static Future<List<FlightModel>> searchFlights({
    String origin = '',
    String destination = '',
    DateTime? date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return MockData.flights();
  }

  // TODO: POST $baseUrl/api/bookings/flight { flight_id, passengers, seat_class }
  static Future<Map<String, dynamic>> bookFlight(Map<String, dynamic> payload) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return {'success': true, 'booking_id': 'BK${DateTime.now().millisecondsSinceEpoch}'};
  }

  // ------------------ Hotels (Person 3) ------------------
  // TODO: GET $baseUrl/api/hotels?city=&max_price=
  static Future<List<HotelModel>> searchHotels({String city = '', double? maxPrice}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return MockData.hotels();
  }

  // TODO: POST $baseUrl/api/bookings/hotel { hotel_id, room_id, check_in, check_out, guests }
  static Future<Map<String, dynamic>> bookHotel(Map<String, dynamic> payload) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return {'success': true, 'booking_id': 'BK${DateTime.now().millisecondsSinceEpoch}'};
  }

  // ------------------ Bookings / History (Person 2 + 3) ------------------
  // TODO: GET $baseUrl/api/bookings?user_id=
  static Future<List<BookingRecord>> getBookingHistory() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return MockData.bookingHistory();
  }

  // TODO: POST $baseUrl/api/bookings/{id}/cancel
  static Future<bool> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // ------------------ Payment ------------------
  // TODO: POST $baseUrl/api/payments { booking_id, method, card_token }
  static Future<Map<String, dynamic>> processPayment(Map<String, dynamic> payload) async {
    await Future.delayed(const Duration(seconds: 1));
    return {'success': true, 'transaction_id': 'TX${DateTime.now().millisecondsSinceEpoch}'};
  }

  // ------------------ AI Support Chat (Person 6) ------------------
  // TODO(Person 6): POST $baseUrl/api/chat { message, user_id, session_id }
  // من المتوقع أن يعيد Backend الذكاء الاصطناعي حقل "reply" بالرد النصي،
  // وقد يضيف لاحقًا حقل "suggestions" لاقتراحات ذكية (مثال: توصية فندق/رحلة).
  static Future<String> sendChatMessage({
    required String message,
    String? userId,
    String? sessionId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));
    // رد وهمي مؤقت لعرض الواجهة قبل تكامل الذكاء الاصطناعي الحقيقي
    if (message.contains('حجز') || message.contains('إلغاء')) {
      return 'يمكنك مراجعة وإلغاء حجوزاتك من قسم "حجوزاتي" في التطبيق. هل تريد مساعدة في حجز معين؟';
    }
    if (message.contains('دفع') || message.contains('فلوس') || message.contains('سعر')) {
      return 'نوفر الدفع عبر البطاقات الائتمانية، المحافظ الإلكترونية، أو الدفع عند الوصول. هل تواجه مشكلة في عملية دفع معينة؟';
    }
    return 'شكرًا لتواصلك! هذا رد تجريبي حاليًا — سيتم ربط هذه الشاشة بخدمة الذكاء الاصطناعي الحقيقية من فريق الدعم قريبًا.';
  }
}
