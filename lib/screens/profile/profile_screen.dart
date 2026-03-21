import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // Top bar
          Container(
            color: AppTheme.topBarBg,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, left: 16, right: 16, bottom: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.13)),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 18),
                  ),
                ),
                const Expanded(child: Center(child: Text('My Profile', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)))),
                const SizedBox(width: 32),
              ],
            ),
          ),
          // Profile header
          Container(
            color: AppTheme.topBarBg,
            padding: const EdgeInsets.only(bottom: 18),
            child: Stack(
              children: [
                Center(child: Column(children: [
                  Container(
                    width: 74, height: 74,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFC0392B),
                      border: Border.all(color: AppTheme.primary, width: 3),
                    ),
                    child: const Center(child: Text('A', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700))),
                  ),
                  const SizedBox(height: 10),
                  Text(user?.name ?? 'Your Name', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 3),
                  Text(user?.phone ?? '+91 XXXXXXXXXX', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.5))),
                ])),
                Positioned(
                  top: 0, right: 16,
                  child: GestureDetector(
                    onTap: () => _confirmSignOut(context, auth),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white.withOpacity(0.12),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.logout, size: 14, color: Colors.white),
                        const SizedBox(width: 5),
                        const Text('Sign Out', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Form
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _field('Name'),
                _field('Mobile Number', type: TextInputType.phone),
                Row(children: [Expanded(child: _field('Age')), const SizedBox(width: 9), Expanded(child: _field('Blood Group'))]),
                _field('Location'),
                _field('Adders'),
                _field('Mail Id', type: TextInputType.emailAddress),
                _field('Pin code', type: TextInputType.number),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved!'))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
                const SizedBox(height: 12),
                _statutoryWarning(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String hint, {TextInputType? type}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: TextField(
        keyboardType: type,
        style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppTheme.textSecondary),
          filled: true, fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: AppTheme.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: AppTheme.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: AppTheme.primary)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
        ),
      ),
    );
  }

  Widget _statutoryWarning() {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        const Text('🚭🍺', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text.rich(TextSpan(children: [
          const TextSpan(text: 'STATUTORY WARNING\n', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
          TextSpan(text: 'SMOKING AND ALCOHOL CONSUMPTION IS INJURIOUS TO HEALTH', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10)),
        ]), textAlign: TextAlign.center),
      ]),
    );
  }

  void _confirmSignOut(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('👋', style: TextStyle(fontSize: 38)),
            const SizedBox(height: 10),
            const Text('Sign Out?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            const SizedBox(height: 6),
            const Text('Are you sure you want to sign out of Cherse?', style: TextStyle(fontSize: 13, color: Color(0xFF888888), height: 1.5), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  side: const BorderSide(color: AppTheme.border, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF555555))),
              )),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  auth.logout();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Sign Out', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
              )),
            ]),
          ]),
        ),
      ),
    );
  }
}
