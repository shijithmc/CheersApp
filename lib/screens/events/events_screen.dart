import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/common_widgets.dart';
import '../profile/profile_screen.dart';
import '../profile/referral_screen.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  static const _statusEmojis = {
    'launching': '🏛', 'new': '👰', 'join': '🎁', 'live': '🏪', 'coming': '🎉', 'offers': '🎁',
  };
  static const _statusBgs = {
    'launching': 0xFF1A2A4A, 'new': 0xFFF5E6D0, 'join': 0xFF1A2A1A, 'live': 0xFFE0C060, 'coming': 0xFFE8C030, 'offers': 0xFF1A2A1A,
  };

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    final events = data.events;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          TopBar(
            leading: _backBtn(),
            points: data.points,
            onProfile: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            onPoints: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReferralScreen())),
          ),
          Expanded(
            child: events.isEmpty
                ? const Center(child: Text('No events yet', style: TextStyle(color: AppTheme.textHint)))
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: events.length,
                    itemBuilder: (_, i) {
                      final e = events[i];
                      final status = e.eventStatus.toLowerCase();
                      final emoji = _statusEmojis[status] ?? '🎉';
                      final bg = _statusBgs[status] ?? 0xFF1A2A4A;
                      return Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 1),
                        child: Row(
                          children: [
                            Container(
                              width: 118, height: 85,
                              color: Color(bg),
                              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 32))),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StatusBadge(status: e.eventStatus),
                                    const SizedBox(height: 5),
                                    Text(e.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textPrimary, height: 1.35), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _backBtn() {
    return Container(
      width: 32, height: 32,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.13)),
      child: const Icon(Icons.chevron_left, color: Colors.white, size: 18),
    );
  }
}
