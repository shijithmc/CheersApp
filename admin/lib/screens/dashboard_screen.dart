import 'package:flutter/material.dart';
import '../services/admin_api_service.dart';
import 'manage_venues_screen.dart';
import 'manage_events_screen.dart';
import 'manage_offers_screen.dart';
import 'manage_jobs_screen.dart';
import 'admin_login_screen.dart';

const _primary = Color(0xFFD35400);
const _bg = Color(0xFF2B1B17);
const _surface = Color(0xFF3D2B24);
const _accent = Color(0xFFF39C12);

class DashboardScreen extends StatefulWidget {
  final AdminApiService api;
  const DashboardScreen({super.key, required this.api});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final s = await widget.api.getAnalytics();
      setState(() => _stats = s);
    } catch (_) {
      setState(() => _stats = {'venues': 0, 'events': 0, 'offers': 0, 'jobs': 0, 'users': 0});
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _overviewPanel(),
      ManageVenuesScreen(api: widget.api),
      ManageEventsScreen(api: widget.api),
      ManageOffersScreen(api: widget.api),
      ManageJobsScreen(api: widget.api),
    ];

    return Scaffold(
      backgroundColor: _bg,
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 220,
            color: _surface,
            child: Column(
              children: [
                const SizedBox(height: 24),
                const Icon(Icons.local_bar, size: 40, color: _primary),
                const SizedBox(height: 8),
                const Text('Cheers Admin', style: TextStyle(color: _primary, fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 32),
                _navItem(Icons.dashboard, 'Dashboard', 0),
                _navItem(Icons.store, 'Venues', 1),
                _navItem(Icons.event, 'Events', 2),
                _navItem(Icons.local_offer, 'Offers', 3),
                _navItem(Icons.work, 'Jobs', 4),
                const Spacer(),
                _navItem(Icons.logout, 'Logout', -1),
                const SizedBox(height: 16),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int idx) {
    final selected = _selectedIndex == idx;
    return InkWell(
      onTap: () {
        if (idx == -1) {
          widget.api.logout();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => AdminLoginScreen(api: widget.api)));
          return;
        }
        setState(() => _selectedIndex = idx);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        color: selected ? _primary.withOpacity(0.15) : Colors.transparent,
        child: Row(children: [
          Icon(icon, color: selected ? _primary : Colors.white54, size: 20),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(
              color: selected ? _primary : Colors.white54, fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
        ]),
      ),
    );
  }

  Widget _overviewPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dashboard', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _statCard('Venues', _stats['venues'] ?? 0, Icons.store, _primary),
            _statCard('Events', _stats['events'] ?? 0, Icons.event, const Color(0xFF27AE60)),
            _statCard('Offers', _stats['offers'] ?? 0, Icons.local_offer, const Color(0xFF8E44AD)),
            _statCard('Jobs', _stats['jobs'] ?? 0, Icons.work, const Color(0xFF2980B9)),
            _statCard('Users', _stats['users'] ?? 0, Icons.people, _accent),
          ],
        ),
        const SizedBox(height: 32),
        const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          children: [
            _quickAction('Add Venue', Icons.add_business, () => setState(() => _selectedIndex = 1)),
            _quickAction('Add Event', Icons.add_circle, () => setState(() => _selectedIndex = 2)),
            _quickAction('Add Offer', Icons.card_giftcard, () => setState(() => _selectedIndex = 3)),
            _quickAction('Post Job', Icons.post_add, () => setState(() => _selectedIndex = 4)),
          ],
        ),
      ],
    );
  }

  Widget _statCard(String label, int count, IconData icon, Color color) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text('$count', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _quickAction(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }
}
