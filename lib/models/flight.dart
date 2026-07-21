class FlightModel {
  final String id;
  final String airline;
  final String airlineLogo;
  final String flightNumber;
  final String originCity;
  final String originCode;
  final String destinationCity;
  final String destinationCode;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int stops;
  final double price;
  final String cabinClass;

  FlightModel({
    required this.id,
    required this.airline,
    required this.airlineLogo,
    required this.flightNumber,
    required this.originCity,
    required this.originCode,
    required this.destinationCity,
    required this.destinationCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.stops,
    required this.price,
    required this.cabinClass,
  });

  Duration get duration => arrivalTime.difference(departureTime);

  String get durationLabel {
    final h = duration.inHours;
    final m = duration.inMinutes % 60;
    return '$hس $mد';
  }

  String get stopsLabel => stops == 0 ? 'مباشرة' : '$stops توقف';

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json['id'].toString(),
      airline: json['airline'] ?? '',
      airlineLogo: json['airline_logo'] ?? '',
      flightNumber: json['flight_number'] ?? '',
      originCity: json['origin_city'] ?? '',
      originCode: json['origin_code'] ?? '',
      destinationCity: json['destination_city'] ?? '',
      destinationCode: json['destination_code'] ?? '',
      departureTime: DateTime.parse(json['departure_time']),
      arrivalTime: DateTime.parse(json['arrival_time']),
      stops: json['stops'] ?? 0,
      price: (json['price'] as num).toDouble(),
      cabinClass: json['cabin_class'] ?? 'اقتصادية',
    );
  }
}
