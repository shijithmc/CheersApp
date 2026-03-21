import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_data_provider.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final offers = context.watch<AppDataProvider>().offers;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Offers & Promotions'), backgroundColor: AppTheme.topBarBg),
      body: offers.isEmpty
          ? const Center(child: Text('No offers available', style: TextStyle(color: AppTheme.textHint)))
          : ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: offers.length,
              itemBuilder: (_, i) {
                final o = offers[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.border)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: Text('${o.discountPercent}%\nOFF', textAlign: TextAlign.center,
                              style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(o.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                          const SizedBox(height: 4),
                          Text(o.venueName ?? '', style: const TextStyle(color: AppTheme.primary, fontSize: 12)),
                          Text('Valid till ${DateFormat('MMM dd').format(o.validTo)}', style: const TextStyle(color: AppTheme.textHint, fontSize: 11)),
                        ])),
                      ]),
                      if (o.description != null) ...[
                        const SizedBox(height: 10),
                        Text(o.description!, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      ],
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Offer redeemed! +20 points'))),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          ),
                          child: const Text('Redeem', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
