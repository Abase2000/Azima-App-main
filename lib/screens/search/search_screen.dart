import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import '../flights/flight_results_screen.dart';
import '../hotels/hotel_results_screen.dart';

class SearchScreen extends StatefulWidget {
  final int initialTab;
  const SearchScreen({super.key, this.initialTab = 0});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTab);

  // بيانات نموذج البحث عن رحلة
  final _originCtrl = TextEditingController(text: 'القاهرة');
  final _destinationCtrl = TextEditingController(text: 'دبي');
  DateTime? _flightDate;

  // بيانات نموذج البحث عن فندق
  final _cityCtrl = TextEditingController();
  DateTimeRange? _stayRange;
  int _guests = 1;

  Future<void> _pickFlightDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _flightDate = picked);
  }

  Future<void> _pickStayRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _stayRange = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textGrey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(icon: Icon(Icons.flight_outlined), text: 'رحلات'),
            Tab(icon: Icon(Icons.apartment_outlined), text: 'فنادق'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildFlightForm(), _buildHotelForm()],
      ),
    );
  }

  Widget _buildFlightForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _fieldLabel('من'),
          _textField(_originCtrl, Icons.flight_takeoff_outlined, 'مدينة المغادرة'),
          const SizedBox(height: 14),
          Center(
            child: IconButton(
              onPressed: () {
                final tmp = _originCtrl.text;
                _originCtrl.text = _destinationCtrl.text;
                _destinationCtrl.text = tmp;
                setState(() {});
              },
              icon: const Icon(Icons.swap_vert_circle_rounded, color: AppColors.accent, size: 30),
            ),
          ),
          _fieldLabel('إلى'),
          _textField(_destinationCtrl, Icons.flight_land_outlined, 'مدينة الوصول'),
          const SizedBox(height: 18),
          _fieldLabel('تاريخ السفر'),
          _dateBox(_flightDate == null ? 'اختر التاريخ' : _fmt(_flightDate!), _pickFlightDate),
          const SizedBox(height: 28),
          PrimaryButton(
            label: 'ابحث عن رحلات',
            icon: Icons.search,
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => FlightResultsScreen(origin: _originCtrl.text, destination: _destinationCtrl.text),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _fieldLabel('الوجهة'),
          _textField(_cityCtrl, Icons.location_city_outlined, 'إلى أي مدينة تريد السفر؟'),
          const SizedBox(height: 18),
          _fieldLabel('مدة الإقامة'),
          _dateBox(
            _stayRange == null ? 'اختر تواريخ الوصول والمغادرة' : '${_fmt(_stayRange!.start)} → ${_fmt(_stayRange!.end)}',
            _pickStayRange,
          ),
          const SizedBox(height: 18),
          _fieldLabel('عدد الضيوف'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                const Icon(Icons.people_outline, color: AppColors.textGrey),
                const SizedBox(width: 10),
                Expanded(child: Text('$_guests ضيوف')),
                IconButton(onPressed: () => setState(() => _guests = _guests > 1 ? _guests - 1 : 1), icon: const Icon(Icons.remove_circle_outline)),
                IconButton(onPressed: () => setState(() => _guests++), icon: const Icon(Icons.add_circle_outline)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: 'ابحث عن فنادق',
            icon: Icons.search,
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => HotelResultsScreen(initialCity: _cityCtrl.text),
            )),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      );

  Widget _textField(TextEditingController ctrl, IconData icon, String hint) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(prefixIcon: Icon(icon), hintText: hint),
    );
  }

  Widget _dateBox(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          const Icon(Icons.calendar_today_outlined, color: AppColors.textGrey, size: 18),
          const SizedBox(width: 10),
          Text(label),
        ]),
      ),
    );
  }

  String _fmt(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
