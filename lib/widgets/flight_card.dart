import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/flight.dart';
import '../theme/app_theme.dart';

class FlightCard extends StatelessWidget {
  final FlightModel flight;
  final VoidCallback onTap;

  const FlightCard({super.key, required this.flight, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final timeFmt = DateFormat('hh:mm a');
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(flight.airlineLogo, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(flight.airline, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
                    child: Text(flight.cabinClass, style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(timeFmt.format(flight.departureTime), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                        Text(flight.originCode, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(flight.durationLabel, style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Expanded(child: Divider(thickness: 1)),
                            const Icon(Icons.flight, size: 14, color: AppColors.accent),
                            const Expanded(child: Divider(thickness: 1)),
                          ],
                        ),
                        Text(flight.stopsLabel, style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(timeFmt.format(flight.arrivalTime), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                        Text(flight.destinationCode, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(flight.flightNumber, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                  Text('${flight.price.toStringAsFixed(0)}\$',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.primary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
