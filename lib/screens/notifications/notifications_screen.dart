import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/common_widgets.dart';
import '../profile/profile_screen.dart';
import '../profile/referral_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  Color _parseColor(String c) {
    if (c.isEmpty) return const Color(0xFF333333);
    try { return Color(int.parse(c.replaceFirst('0x', ''), radix: 16)); } catch (_) { return const Color(0xFF333333); }
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    final notifs = data.notifications;
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
            child: notifs.isEmpty
                ? const Center(child: Text('No notifications', style: TextStyle(color: AppTheme.textHint)))
                : ListView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: notifs.length,
                    itemBuilder: (_, i) {
                      final n = notifs[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 9),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(color: _parseColor(n.bgColor), borderRadius: BorderRadius.circular(10)),
                              child: Center(child: Text(n.emoji.isNotEmpty ? n.emoji : '🔔', style: const TextStyle(fontSize: 20))),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(n.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                                const SizedBox(height: 2),
                                Text(n.body, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.4)),
                                const SizedBox(height: 3),
                                Text(n.timeLabel.isNotEmpty ? n.timeLabel : _timeAgo(n.createdAt),
                                    style: const TextStyle(fontSize: 10, color: AppTheme.textHint)),
                              ],
                            )),
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

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays} days ago';
    if (diff.inHours > 0) return '${diff.inHours} hours ago';
    return '${diff.inMinutes} min ago';
  }

  Widget _backBtn() {
    return Container(
      width: 32, height: 32,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.13)),
      child: const Icon(Icons.chevron_left, color: Colors.white, size: 18),
    );
  }
}
