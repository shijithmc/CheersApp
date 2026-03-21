import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';

class VenueDetailScreen extends StatelessWidget {
  final Venue venue;
  const VenueDetailScreen({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              _hero(),
              _dotsRow(),
              _body(),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8, left: 13,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.92), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back, size: 17, color: Color(0xFF333333)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hero() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFF8B4513), const Color(0xFFD2691E)]),
      ),
      child: Stack(
        children: [
          if (venue.images.isNotEmpty)
            Positioned.fill(child: Image.network(venue.images.first, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(child: Text('🏨', style: TextStyle(fontSize: 60)))))
          else
            const Center(child: Text('🏨', style: TextStyle(fontSize: 60))),
          Positioned(
            bottom: 8, left: 12,
            child: Row(children: [
              const Icon(Icons.camera_alt_outlined, size: 14, color: Colors.white70),
              const SizedBox(width: 4),
              Text('69', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8))),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _dotsRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (i) => Container(
          width: i == 0 ? 14 : 5, height: 5,
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          decoration: BoxDecoration(
            color: i == 0 ? AppTheme.primary : const Color(0xFFDDDDDD),
            borderRadius: BorderRadius.circular(3),
          ),
        )),
      ),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Save
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(venue.name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: AppTheme.textPrimary))),
              Column(children: [
                Icon(Icons.favorite_border, size: 20, color: AppTheme.textSecondary),
                const Text('Save', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
              ]),
            ],
          ),
          const SizedBox(height: 4),
          // Rating dots
          Row(children: [
            ..._ratingDots(3.5),
            const SizedBox(width: 6),
            const Text('125 reviews', style: TextStyle(fontSize: 12, color: AppTheme.textHint)),
          ]),
          const SizedBox(height: 7),
          // Liquor tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(50)),
            child: const Text('LiquorAvaible', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppTheme.border),
          // About
          const Text('About', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          const SizedBox(height: 10),
          Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
            Text('${venue.rating}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            const SizedBox(width: 8),
            const Text('Very good', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
            const SizedBox(width: 4),
            ..._ratingDots(3.5),
            const SizedBox(width: 6),
            const Text('125 reviews', style: TextStyle(fontSize: 12, color: AppTheme.textHint)),
          ]),
          const SizedBox(height: 4),
          const Text('#19 of 132 hotels in Kozhikode', style: TextStyle(fontSize: 11, color: AppTheme.textHint)),
          const SizedBox(height: 10),
          // Rating rows
          _ratingRow('Location', 3.5),
          _ratingRow('Cleanliness', 3.5),
          _ratingRow('Service', 3.5),
          _ratingRow('Value', 2.5),
          const SizedBox(height: 12),
          // Description
          Text(venue.description ?? 'Leading Luxury hotel near airport road Calicut. with Multicuisine Restaurant, Bar, Health Club, Banquets, Room Service etc',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.65)),
          const SizedBox(height: 14),
          // Property amenities
          _amenitySection('Property amenities', [
            'Free parking', 'Free High Speed Internet (WiFi)', 'Free breakfast',
            'Business Centre with Internet Access', 'Conference facilities', 'Concierge',
            'Dry cleaning', 'Laundry service',
          ]),
          _amenitySection('Room features', [
            'Air conditioning', 'Room service', 'Minibar', 'Refrigerator', 'Flatscreen TV',
          ]),
          _amenitySection('Room types', [
            'Non-smoking rooms', 'Suites', 'Family rooms', 'Smoking rooms available',
          ]),
          // Reviews
          const Divider(color: AppTheme.border),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Reviews', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            Row(children: [
              _reviewBtn('Write a review'),
              const SizedBox(width: 6),
              _reviewBtn('▼'),
            ]),
          ]),
          const SizedBox(height: 12),
          const Text('Traveller rating', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          _reviewBar('Excellent', 0.70, 34),
          _reviewBar('Very Good', 0.85, 49),
          _reviewBar('Average', 0.40, 24),
          _reviewBar('Poor', 0.16, 9),
          _reviewBar('Terrible', 0.16, 9),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _ratingDots(double rating) {
    return List.generate(5, (i) {
      Color color;
      if (i < rating.floor()) {
        color = AppTheme.green;
      } else if (i < rating) {
        color = AppTheme.green.withOpacity(0.5);
      } else {
        color = const Color(0xFFDDDDDD);
      }
      return Container(width: 10, height: 10, margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(shape: BoxShape.circle, color: color));
    });
  }

  Widget _ratingRow(String label, double rating) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(children: [
        ..._ratingDots(rating),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      ]),
    );
  }

  Widget _amenitySection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 9, crossAxisSpacing: 9, childAspectRatio: 6,
          children: items.map((item) => Row(children: [
            Icon(Icons.check_circle_outline, size: 14, color: AppTheme.textHint),
            const SizedBox(width: 7),
            Expanded(child: Text(item, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary), overflow: TextOverflow.ellipsis)),
          ])).toList(),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _reviewBtn(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(color: AppTheme.textPrimary, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Widget _reviewBar(String label, double pct, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(children: [
        SizedBox(width: 60, child: Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary))),
        const SizedBox(width: 8),
        Expanded(child: Container(
          height: 7,
          decoration: BoxDecoration(color: const Color(0xFFEEEEEE), borderRadius: BorderRadius.circular(3)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: pct,
            child: Container(decoration: BoxDecoration(color: const Color(0xFF222222), borderRadius: BorderRadius.circular(3))),
          ),
        )),
        const SizedBox(width: 8),
        SizedBox(width: 20, child: Text('$count', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary), textAlign: TextAlign.right)),
      ]),
    );
  }
}
