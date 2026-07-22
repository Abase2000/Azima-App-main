import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/flight.dart';
import '../models/hotel.dart';
import '../models/booking_record.dart';
import '../data/mock_data.dart';
import 'session_service.dart';

class ChatResponse {
  final String reply;
  final int? conversationId;

  ChatResponse({required this.reply, this.conversationId});
}

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
  static const String baseUrl = kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000';

  // ------------------ Auth (Person 1) ------------------
  // TODO: POST $baseUrl/api/login  { email, password } -> { success, user, token }
  static Future<Map<String, dynamic>> login({required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        final token = data['data']['access_token'];
        if (token != null) {
          await SessionService.saveToken(token);
        }
        return {
          'success': true,
          'user': data['data']['user'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'فشل تسجيل الدخول',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'حدث خطأ في الاتصال بالخادم: $e',
      };
    }
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
  static Future<ChatResponse> sendChatMessage({
    required String message,
    String? userId,
    int? conversationId,
  }) async {
    try {
      final token = await SessionService.getToken();
      final headers = <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      };
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final bodyMap = <String, dynamic>{
        'message': message,
      };
      if (conversationId != null) {
        bodyMap['conversation_id'] = conversationId;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/chat'),
        headers: headers,
        body: jsonEncode(bodyMap),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        final replyText = data['data']['ai_response']['content'];
        final convId = data['data']['conversation_id'];
        return ChatResponse(reply: replyText, conversationId: convId);
      } else {
        return ChatResponse(reply: data['message'] ?? 'فشل الحصول على رد من المساعد.');
      }
    } catch (e) {
      return ChatResponse(reply: 'حدث خطأ في الاتصال بالخادم: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getChatHistory() async {
    try {
      final token = await SessionService.getToken();
      final headers = <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      };
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/chat-history'),
        headers: headers,
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    } catch (e) {
      print('Error fetching chat history: $e');
    }
    return [];
  }
}
