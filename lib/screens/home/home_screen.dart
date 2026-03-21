import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../theme/app_theme.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/common_widgets.dart';
import '../venue/venue_detail_screen.dart';
import '../venue/bar_locations_screen.dart';
import '../profile/profile_screen.dart';
import '../profile/referral_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bannerCtrl = PageController();
  final _eventsCtrl = PageController();
  int _bannerPage = 0;
  int _eventsPage = 0;
  Timer? _bannerTimer;
  Timer? _eventsTimer;



  static const _quickAreas = [
    {'emoji': '🍾', 'label': '5 Star Bar', 'color': 0xFFFDEBD0},
    {'emoji': '🏨', 'label': '4 Star Bar', 'color': 0xFFFADBD8},
    {'emoji': '🍻', 'label': '3 Star Bar', 'color': 0xFFD5F5E3},
    {'emoji': '🥂', 'label': '2 Star Bar', 'color': 0xFFD6EAF8},
    {'emoji': '🍷', 'label': 'Beer Wine Parlour', 'color': 0xFFE8DAEF},
    {'emoji': '👨\u200D👩\u200D👧', 'label': 'Family Bar', 'color': 0xFFFDFEFE},
    {'emoji': '🎉', 'label': 'Pubs', 'color': 0xFFFEF9E7},
    {'emoji': '🥃', 'label': 'Beverages', 'color': 0xFFEAF2FF},
  ];

  static const _topFoodHotels = [
    {'emoji': '🏨', 'name': 'The Raviz Calicut', 'color': 0xFFFADBD8},
    {'emoji': '🍺', 'name': 'Kovilakam Bar', 'color': 0xFFD5F5E3},
    {'emoji': '🏢', 'name': 'Maharani Bar', 'color': 0xFFD6EAF8},
    {'emoji': '🌴', 'name': 'Beach Heritage Bar', 'color': 0xFFA9DFBF},
    {'emoji': '🏛', 'name': 'Alakapuri Hotel', 'color': 0xFFFDEBD0},
    {'emoji': '🌿', 'name': 'Park Residancy', 'color': 0xFFE8DAEF},
    {'emoji': '🍃', 'name': 'Copperfolia', 'color': 0xFFD6F5EA},
    {'emoji': '🌺', 'name': 'Hotel Amrutha', 'color': 0xFFFAD7A0},
  ];

  static const _topHotelRooms = [
    {'emoji': '🛏', 'name': 'Park Residancy', 'color': 0xFFFAD7A0},
    {'emoji': '🌴', 'name': 'Beach Heritage Bar', 'color': 0xFFA9DFBF},
    {'emoji': '🍃', 'name': 'Copperfolia', 'color': 0xFFD7BDE2},
    {'emoji': '🏰', 'name': 'Kovilakam Bar', 'color': 0xFFAED6F1},
  ];

  static const _yourSpace = [
    {'emoji': '🛏', 'label': 'Book Your Rooms'},
    {'emoji': '🍽', 'label': 'Book Your Foods'},
    {'emoji': '💆', 'label': 'Book Massage & Spa'},
    {'emoji': '🎪', 'label': 'Book Events'},
  ];

  static const _demoEvents = [
    {'title': 'Hananshaah Team MVR – New Year Live', 'sub': 'Calicut Trade Centre · Dec 31 · 9:00 PM', 'emoji': '🎤', 'colors': [0xFF1A1A2E, 0xFFC0392B]},
    {'title': 'Grand Tandoori Food Fest', 'sub': 'Park Residency · Dec 22 onwards', 'emoji': '🎊', 'colors': [0xFF8B2252, 0xFFFF6B35]},
    {'title': 'Cocktail Fest – Move the Beat', 'sub': 'Copperfolia · July 22 · 7:30 PM', 'emoji': '🍸', 'colors': [0xFF1A3A5C, 0xFF2980B9]},
  ];

  static const _helpPoints = [
    {'emoji': '🚒', 'label': 'Firefourse', 'color': 0xFFFFCCCC},
    {'emoji': '➕', 'label': 'Ambulanc', 'color': 0xFFFFCCCC},
    {'emoji': '👮', 'label': 'Police', 'color': 0xFFE8F4FF},
    {'emoji': '🏛', 'label': 'Excise', 'color': 0xFFE8FFE8},
  ];

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(milliseconds: 3500), (_) {
      if (_bannerCtrl.hasClients) {
        final count = context.read<AppDataProvider>().banners.length;
        if (count > 0) {
          _bannerCtrl.animateToPage((_bannerPage + 1) % count, duration: const Duration(milliseconds: 380), curve: Curves.easeOut);
        }
      }
    });
    _eventsTimer = Timer.periodic(const Duration(milliseconds: 4200), (_) {
      if (_eventsCtrl.hasClients) {
        _eventsCtrl.animateToPage((_eventsPage + 1) % _demoEvents.length, duration: const Duration(milliseconds: 380), curve: Curves.easeOut);
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _eventsTimer?.cancel();
    _bannerCtrl.dispose();
    _eventsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          TopBar(
            points: data.points,
            onProfile: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            onPoints: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReferralScreen())),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _bannerSlider(),
                const SectionHeader(title: 'Quick Area'),
                _quickAreaGrid(),
                _liveEventsSection(),
                _chipSection('Top Food Hotel in Your space', _topFoodHotels),
                _chipSection('Top Hotel Rooms in Your space', _topHotelRooms),
                const SectionHeader(title: 'Your Top Products'),
                _topProductsBanner(),
                _yourSpaceSection(),
                _yourEventsSection(data),
                _helpPointSection(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── BANNER SLIDER ──
  Widget _bannerSlider() {
    final data = context.watch<AppDataProvider>();
    final bannerList = data.banners;
    if (bannerList.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        Container(
          color: AppTheme.primaryDark,
          height: 100,
          child: PageView.builder(
            controller: _bannerCtrl,
            itemCount: bannerList.length,
            onPageChanged: (i) => setState(() => _bannerPage = i),
            itemBuilder: (_, i) {
              final b = bannerList[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(b.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2)),
                          const SizedBox(height: 3),
                          Text(b.subtitle, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8))),
                        ],
                      ),
                    ),
                    Text(b.emoji, style: const TextStyle(fontSize: 48)),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          color: AppTheme.primaryDark,
          padding: const EdgeInsets.only(bottom: 8, top: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(bannerList.length, (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _bannerPage == i ? 18 : 6, height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              decoration: BoxDecoration(
                color: _bannerPage == i ? Colors.white : Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(3),
              ),
            )),
          ),
        ),
      ],
    );
  }

  // ── QUICK AREA 2x4 GRID ──
  Widget _quickAreaGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.75,
        ),
        itemCount: _quickAreas.length,
        itemBuilder: (_, i) {
          final q = _quickAreas[i];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BarLocationsScreen())),
            child: Column(
              children: [
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    color: Color(q['color'] as int),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.border, width: 1.5),
                  ),
                  child: Center(child: Text(q['emoji'] as String, style: const TextStyle(fontSize: 28))),
                ),
                const SizedBox(height: 5),
                Text(q['label'] as String, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 2),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── LIVE EVENTS ──
  Widget _liveEventsSection() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Live Events'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppTheme.red, borderRadius: BorderRadius.circular(50)),
                  child: Row(children: [
                    _pulseDot(),
                    const SizedBox(width: 3),
                    const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                  ]),
                ),
                const SizedBox(width: 6),
                const Text('SinQ Night Club Night Dance', style: TextStyle(fontSize: 12, color: AppTheme.red, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              final data = context.read<AppDataProvider>();
              if (data.venues.isNotEmpty) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => VenueDetailScreen(venue: data.venues.first)));
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(colors: [Color(0xFF1A0A2E), Color(0xFF6C1A3A)]),
              ),
              child: Stack(
                children: [
                  const Center(child: Text('🎵', style: TextStyle(fontSize: 52))),
                  Positioned(
                    top: 10, left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(color: AppTheme.red, borderRadius: BorderRadius.circular(50)),
                      child: Row(children: [
                        _pulseDot(),
                        const SizedBox(width: 3),
                        const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  ),
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(14, 24, 14, 12),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.82)]),
                      ),
                      child: const Text('SinQ Night Club Night Dance', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const Positioned(bottom: -2, right: 10, child: Text('🍷', style: TextStyle(fontSize: 32))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _pulseDot() {
    return Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle));
  }

  // ── CHIP SECTION (Top Food Hotels / Top Hotel Rooms) ──
  Widget _chipSection(String title, List<Map<String, Object>> items) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                return GestureDetector(
                  onTap: () {
                    final data = context.read<AppDataProvider>();
                    if (data.venues.isNotEmpty) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => VenueDetailScreen(venue: data.venues[i % data.venues.length])));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(
                            color: Color(item['color'] as int),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.border, width: 1.5),
                          ),
                          child: Center(child: Text(item['emoji'] as String, style: const TextStyle(fontSize: 28))),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 74,
                          child: Text(item['name'] as String, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 2),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── YOUR TOP PRODUCTS BANNER ──
  Widget _topProductsBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppTheme.primaryDark, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('SUPPORT SAINTS AT HOME', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2)),
                      const SizedBox(height: 2),
                      Text('10% OFF FOR SAINTS FANS\nExclusive discount with code SFC10', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.75))),
                    ],
                  ),
                ),
                const Text('🍺🍺', style: TextStyle(fontSize: 40)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => Container(
                width: 5, height: 5, margin: const EdgeInsets.symmetric(horizontal: 2.5),
                decoration: BoxDecoration(
                  color: i == 0 ? Colors.white : Colors.white.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  // ── YOUR SPACE ──
  Widget _yourSpaceSection() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Your Space'),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _yourSpace.length,
              itemBuilder: (_, i) {
                final s = _yourSpace[i];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: 78,
                    child: Column(
                      children: [
                        Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.primary, width: 2),
                          ),
                          child: Center(child: Text(s['emoji']!, style: const TextStyle(fontSize: 28))),
                        ),
                        const SizedBox(height: 5),
                        Text(s['label']!, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── YOUR EVENTS SLIDER ──
  Widget _yourEventsSection(AppDataProvider data) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Your Events', actionText: 'More >', onAction: () {
            // Switch to events tab - find HomeShell ancestor
          }),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 190,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _eventsCtrl,
                    itemCount: _demoEvents.length,
                    onPageChanged: (i) => setState(() => _eventsPage = i),
                    itemBuilder: (_, i) {
                      final e = _demoEvents[i];
                      final colors = e['colors'] as List<int>;
                      return Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(colors[0]), Color(colors[1])])),
                              child: Center(child: Text(e['emoji'] as String, style: const TextStyle(fontSize: 42))),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e['title'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                                const SizedBox(height: 2),
                                Text(e['sub'] as String, style: const TextStyle(fontSize: 11, color: AppTheme.textHint)),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_demoEvents.length, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _eventsPage == i ? 15 : 5, height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 2.5),
                      decoration: BoxDecoration(
                        color: _eventsPage == i ? AppTheme.primary : const Color(0xFFDDDDDD),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ── HELP POINT ──
  Widget _helpPointSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Text('Help Point', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _helpPoints.map((h) => Column(
              children: [
                Container(
                  width: 58, height: 58,
                  decoration: BoxDecoration(
                    color: Color(h['color'] as int),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.border, width: 2),
                  ),
                  child: Center(child: Text(h['emoji'] as String, style: const TextStyle(fontSize: 28))),
                ),
                const SizedBox(height: 5),
                Text(h['label'] as String, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
              ],
            )).toList(),
          ),
        ),
      ],
    );
  }
}
