import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/common_widgets.dart';
import '../profile/profile_screen.dart';
import '../profile/referral_screen.dart';
import 'venue_detail_screen.dart';

class BarLocationsScreen extends StatefulWidget {
  const BarLocationsScreen({super.key});
  @override
  State<BarLocationsScreen> createState() => _BarLocationsScreenState();
}

class _BarLocationsScreenState extends State<BarLocationsScreen> {
  int _selectedFilter = 0;
  static const _filters = ['All', '5 Star', '4 Star', '3 Star', 'Pubs', 'Family'];

  // Demo bar data matching HTML
  static const _bars = [
    {'name': 'Park Residency Ramanattukara', 'star': '4 Star', 'starColor': 0xFFE07A3A, 'rating': 4, 'safe': true,
      'addr': 'G.H.Road, Ramanattukara, Kozhikode 673001', 'emoji': '🏨', 'bg1': 0xFFFAD7A0, 'bg2': 0xFFE59866},
    {'name': 'Zirkon Bar The Raviz Calicut', 'star': '5 Star Bar', 'starColor': 0xFF7D3C98, 'rating': 5, 'safe': true,
      'addr': 'Arayidathupalam, Kozhikode, Kerala 673004', 'emoji': '🌃', 'bg1': 0xFFA9CCE3, 'bg2': 0xFF2C3E50},
    {'name': 'Kovilakam Bar', 'star': '3 Star Bar', 'starColor': 0xFF1E8449, 'rating': 4, 'safe': false,
      'addr': 'Near M.I.M.S Hospital, Govindapuram, Kozhikode 673016', 'emoji': '🏡', 'bg1': 0xFFA9DFBF, 'bg2': 0xFF1E8449},
    {'name': 'Maharani Hotel', 'star': '3 Star Bar', 'starColor': 0xFF2980B9, 'rating': 4, 'safe': true,
      'addr': 'Op. Sahakarna Bhavan, Puthiyara, Kozhikode 673004', 'emoji': '🏢', 'bg1': 0xFFD6EAF8, 'bg2': 0xFF2980B9},
    {'name': 'Beach Heritage', 'star': '4 Star Bar', 'starColor': 0xFFE07A3A, 'rating': 4, 'safe': false,
      'addr': 'Beach Rd, Near Gujarati School, Mananchira, Kozhikode 673032', 'emoji': '🌴', 'bg1': 0xFFA9DFBF, 'bg2': 0xFF117A65},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TopBar(
            leading: _backBtn(context),
            onProfile: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            onPoints: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReferralScreen())),
            points: context.watch<AppDataProvider>().points,
          ),
          _filterRow(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ..._bars.map((b) => _barCard(context, b)),
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(50)),
                  child: const Center(child: Text('Loading.......', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _backBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.13)),
        child: const Icon(Icons.chevron_left, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _filterRow() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: AppTheme.border))),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: List.generate(_filters.length, (i) => GestureDetector(
            onTap: () => setState(() => _selectedFilter = i),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _selectedFilter == i ? AppTheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: _selectedFilter == i ? AppTheme.primary : const Color(0xFFDDDDDD)),
              ),
              child: Text(_filters[i], style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w500,
                color: _selectedFilter == i ? Colors.white : AppTheme.textSecondary,
              )),
            ),
          )),
        ),
      ),
    );
  }

  Widget _barCard(BuildContext context, Map<String, Object> bar) {
    final data = context.read<AppDataProvider>();
    return GestureDetector(
      onTap: () {
        if (data.venues.isNotEmpty) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => VenueDetailScreen(venue: data.venues.first)));
        }
      },
      child: Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppTheme.border))),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120, height: 130,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(bar['bg1'] as int), Color(bar['bg2'] as int)]),
                  ),
                  child: Center(child: Text(bar['emoji'] as String, style: const TextStyle(fontSize: 36))),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                          decoration: BoxDecoration(color: Color(bar['starColor'] as int), borderRadius: BorderRadius.circular(4)),
                          child: Text(bar['star'] as String, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(height: 4),
                        Text(bar['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                        const SizedBox(height: 3),
                        Row(children: [
                          Text('★' * (bar['rating'] as int) + '☆' * (5 - (bar['rating'] as int)),
                              style: const TextStyle(color: Color(0xFFF39C12), fontSize: 13)),
                          const SizedBox(width: 4),
                          const Text('Cheers Review', style: TextStyle(fontSize: 10, color: AppTheme.textHint)),
                        ]),
                        const SizedBox(height: 5),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Icon(Icons.location_on_outlined, size: 11, color: AppTheme.textHint),
                          const SizedBox(width: 3),
                          Expanded(child: Text(bar['addr'] as String, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary, height: 1.4))),
                        ]),
                        const SizedBox(height: 8),
                        Row(children: [
                          _smallBtn('🌐 Website'), const SizedBox(width: 5),
                          _smallBtn('🗺 Map'), const SizedBox(width: 5),
                          _smallBtn('📞 Call'),
                        ]),
                        const SizedBox(height: 5),
                        Row(children: [
                          _colorBtn('Rooms', AppTheme.primary),
                          const SizedBox(width: 5),
                          _colorBtn('Foods', AppTheme.primary),
                          const SizedBox(width: 5),
                          _colorBtn('Bar', AppTheme.topBarBg),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (bar['safe'] == true)
              Positioned(
                top: 8, right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
                  child: const Text('100% Safty', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _smallBtn(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFDDDDDD))),
      child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppTheme.textSecondary)),
    );
  }

  Widget _colorBtn(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white)),
    );
  }
}
