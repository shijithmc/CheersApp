import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.topBarBg,
      body: Column(
        children: [
          // Back row
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, left: 16, right: 16),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.12)),
                  child: const Icon(Icons.arrow_back, size: 17, color: Colors.white),
                ),
              ),
              const Expanded(
                child: Text('Refer your friends\nand Earn', textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, height: 1.2)),
              ),
              const SizedBox(width: 32),
            ]),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 24),
                const Center(child: Text('⭐', style: TextStyle(fontSize: 82))),
                const SizedBox(height: 12),
                Center(child: Text('Your Points', style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6)))),
                const Center(
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('⭐ ', style: TextStyle(fontSize: 28)),
                    Text('1000', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Color(0xFFF39C12))),
                  ]),
                ),
                const SizedBox(height: 22),
                // Invite card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                  child: Column(children: [
                    RichText(text: const TextSpan(
                      style: TextStyle(fontSize: 16, color: Color(0xFFE74C3C), fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(text: 'Invite friends to get '),
                        TextSpan(text: '101', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700)),
                        TextSpan(text: ' Points'),
                      ],
                    )),
                    const SizedBox(height: 13),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFF2E1106), borderRadius: BorderRadius.circular(9)),
                      child: Row(children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Your Share Link', style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.4))),
                          const SizedBox(height: 2),
                          Text('https://cheers.app/ref/demo', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.75))),
                        ])),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(const ClipboardData(text: 'https://cheers.app/ref/demo'));
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link copied! ✓'), duration: Duration(seconds: 1)));
                          },
                          child: Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(color: AppTheme.green, borderRadius: BorderRadius.circular(7)),
                            child: const Center(child: Text('📋', style: TextStyle(fontSize: 14))),
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
