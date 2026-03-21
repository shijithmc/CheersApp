import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/common_widgets.dart';
import '../profile/profile_screen.dart';
import '../profile/referral_screen.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobs = context.watch<AppDataProvider>().jobs;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          TopBar(
            leading: _backBtn(),
            points: context.watch<AppDataProvider>().points,
            onProfile: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            onPoints: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReferralScreen())),
          ),
          Expanded(
            child: jobs.isEmpty
                ? const Center(child: Text('No jobs posted', style: TextStyle(color: AppTheme.textHint)))
                : ListView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: jobs.length,
                    itemBuilder: (_, i) {
                      final j = jobs[i];
                      final salary = '₹${_fmt(j.salaryMin)} – ₹${_fmt(j.salaryMax)} a month';
                      final daysAgo = DateTime.now().difference(j.postedDate).inDays;
                      final when = daysAgo == 0 ? 'Today' : 'Posted $daysAgo days ago';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(j.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                            const SizedBox(height: 2),
                            Text(j.companyName, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                            if (j.location != null) Text(j.location!, style: const TextStyle(fontSize: 11, color: AppTheme.textHint)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(6)),
                              child: Text(salary, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                            ),
                            const SizedBox(height: 8),
                            Wrap(spacing: 5, children: [
                              _tag('✓ Full-time +1', const Color(0xFFE8F5E9), const Color(0xFF1B5E20)),
                              if (j.shift != null) _tag('${j.shift} shift', const Color(0xFFFFF3E0), const Color(0xFFE65100)),
                            ]),
                            const SizedBox(height: 8),
                            const Row(children: [
                              Text('▶ ', style: TextStyle(color: AppTheme.primary, fontSize: 12)),
                              Text('Easily apply', style: TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                            ]),
                            const SizedBox(height: 3),
                            Text(when, style: const TextStyle(fontSize: 10, color: AppTheme.textHint)),
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

  Widget _tag(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(50)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: fg)),
    );
  }

  String _fmt(int n) => n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}
