import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class AppDataProvider extends ChangeNotifier {
  final ApiService _api;

  List<Venue> _venues = [];
  List<Event> _events = [];
  List<Offer> _offers = [];
  List<Job> _jobs = [];
  List<AppNotification> _notifications = [];
  List<AppBanner> _banners = [];
  List<Poster> _posters = [];
  int _points = 0;
  bool _loading = false;
  String? _selectedCategory;

  AppDataProvider(this._api);

  List<Venue> get venues => _selectedCategory == null
      ? _venues
      : _venues.where((v) => v.category == _selectedCategory).toList();
  List<Event> get events => _events;
  List<Offer> get offers => _offers;
  List<Job> get jobs => _jobs;
  List<AppNotification> get notifications => _notifications;
  List<AppBanner> get banners => _banners;
  List<Poster> get posters => _posters;
  int get points => _points;
  bool get loading => _loading;
  String? get selectedCategory => _selectedCategory;

  void selectCategory(String? cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  void loadDemo() {
    _loadDemoData();
    notifyListeners();
  }

  Future<void> loadAll(String userId) async {
    _loading = true;
    notifyListeners();
    try {
      final results = await Future.wait([
        _api.getVenues(),
        _api.getEvents(),
        _api.getOffers(),
        _api.getJobs(),
        _api.getPoints(userId),
        _api.getNotifications(userId),
        _api.getBanners(),
        _api.getPosters(),
      ]);
      _venues = results[0] as List<Venue>;
      _events = results[1] as List<Event>;
      _offers = results[2] as List<Offer>;
      _jobs = results[3] as List<Job>;
      _points = results[4] as int;
      _notifications = results[5] as List<AppNotification>;
      _banners = results[6] as List<AppBanner>;
      _posters = results[7] as List<Poster>;
    } catch (_) {
      _loadDemoData();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> refreshBanners() async {
    try { _banners = await _api.getBanners(); notifyListeners(); } catch (_) {}
  }

  Future<void> refreshPosters({String? category}) async {
    try { _posters = await _api.getPosters(category: category); notifyListeners(); } catch (_) {}
  }

  Future<void> refreshVenues() async {
    try { _venues = await _api.getVenues(); notifyListeners(); } catch (_) {}
  }

  Future<void> refreshEvents() async {
    try { _events = await _api.getEvents(); notifyListeners(); } catch (_) {}
  }

  Future<void> refreshJobs() async {
    try { _jobs = await _api.getJobs(); notifyListeners(); } catch (_) {}
  }

  Future<void> refreshNotifications(String userId) async {
    try { _notifications = await _api.getNotifications(userId); notifyListeners(); } catch (_) {}
  }

  Future<void> applyJob(String jobId, String userId) async {
    try { await _api.applyJob(jobId, userId); } catch (_) {}
  }

  void _loadDemoData() {
    _banners = [
      AppBanner(id: '1', title: 'SUPPORT SAINTS\nAT HOME', subtitle: '10% OFF FOR SAINTS FANS\nExclusive discount with code SFC10', emoji: '🍺🍺', sortOrder: 0),
      AppBanner(id: '2', title: 'Zirkon Bar\nThe Raviz Calicut', subtitle: '5 Star experience tonight\nArayidathupalam, Kozhikode', emoji: '🌃', sortOrder: 1),
      AppBanner(id: '3', title: 'Beach Heritage\nSpecial Offer', subtitle: 'Beachside dining & bar\nKozhikode', emoji: '🌊', sortOrder: 2),
    ];
    _venues = [
      Venue(id: '1', name: 'Park Residency', rating: 3.5, category: '4 Star Bars', address: 'G.H.Road, Ramanattukara, Kozhikode 673001', phone: '+91 495 123456', website: 'https://parkresidency.com', starLevel: 4, description: 'Leading Luxury hotel near airport road Calicut. with Multicuisine Restaurant, Bar, Health Club, Banquets, Room Service etc'),
      Venue(id: '2', name: 'Zirkon Bar The Raviz Calicut', rating: 4.5, category: '5 Star Bars', address: 'Arayidathupalam, Kozhikode, Kerala 673004', phone: '+91 495 234567', website: 'https://raviz.com', starLevel: 5, description: '5 Star experience with premium bar and dining'),
      Venue(id: '3', name: 'Kovilakam Bar', rating: 4.0, category: '3 Star Bars', address: 'Near M.I.M.S Hospital, Govindapuram, Kozhikode 673016', phone: '+91 495 345678', starLevel: 3, description: 'Popular local bar with great ambiance'),
      Venue(id: '4', name: 'Maharani Hotel', rating: 4.0, category: '3 Star Bars', address: 'Op. Sahakarna Bhavan, Puthiyara, Kozhikode 673004', phone: '+91 495 456789', starLevel: 3, description: 'Well-known hotel with bar and restaurant'),
      Venue(id: '5', name: 'Beach Heritage', rating: 4.2, category: '4 Star Bars', address: 'Beach Rd, Near Gujarati School, Mananchira, Kozhikode 673032', phone: '+91 495 567890', starLevel: 4, description: 'Beachside dining and bar experience'),
      Venue(id: '6', name: 'Copperfolia', rating: 3.8, category: 'Pubs', address: 'Hilite Mall, Kozhikode', phone: '+91 495 678901', starLevel: 3, description: 'Modern pub with cocktail specials'),
    ];
    _events = [
      Event(id: '1', title: 'New Malabar Gold showroom Lunching Ramanttukara', eventDate: DateTime.now().add(const Duration(days: 5)), eventStatus: 'launching', organizer: 'Malabar Gold'),
      Event(id: '2', title: 'New Bride Collation Malabar Gold', eventDate: DateTime.now().add(const Duration(days: 3)), eventStatus: 'new', organizer: 'Malabar Gold'),
      Event(id: '3', title: 'New Dasra festivals offers Kalyan Jewelers', eventDate: DateTime.now().add(const Duration(days: 1)), eventStatus: 'join', organizer: 'Kalyan Jewelers'),
      Event(id: '4', title: 'New Malabar Gold Showroom inauguration Calicut', eventDate: DateTime.now(), eventStatus: 'live', organizer: 'Malabar Gold'),
      Event(id: '5', title: 'My-g Mega offers starting 11-october to 18-october enjoy offers', eventDate: DateTime.now().add(const Duration(days: 10)), eventStatus: 'coming', organizer: 'My-G'),
    ];
    _offers = [
      Offer(id: '1', venueId: '1', title: 'Happy Hour - Buy 1 Get 1', discountPercent: 50, validFrom: DateTime.now(), validTo: DateTime.now().add(const Duration(days: 30)), venueName: 'Park Residency', description: 'Buy one get one free on all cocktails'),
      Offer(id: '2', venueId: '6', title: 'Ladies Night - Free Entry', discountPercent: 100, validFrom: DateTime.now(), validTo: DateTime.now().add(const Duration(days: 7)), venueName: 'Copperfolia', description: 'Free entry and 20% off on drinks for ladies every Friday'),
      Offer(id: '3', venueId: '2', title: 'Peg Offer - ₹99 Specials', discountPercent: 40, validFrom: DateTime.now(), validTo: DateTime.now().add(const Duration(days: 14)), venueName: 'Zirkon Bar', description: 'Selected pegs at just ₹99'),
    ];
    _jobs = [
      Job(id: '1', title: 'House keeping Staff-Male', companyName: 'SASTHAPURI HOTEL', salaryMin: 12086, salaryMax: 17042, shift: 'Day', location: 'Calicut, Kerala'),
      Job(id: '2', title: 'Commi Chef', companyName: 'SASTHAPURI HOTEL', salaryMin: 12273, salaryMax: 22257, shift: 'Day', location: 'Calicut, Kerala', postedDate: DateTime.now().subtract(const Duration(days: 2))),
      Job(id: '3', title: 'Waitress/Bar Staff required in a star hotel', companyName: 'Heritage Hotel', salaryMin: 15000, salaryMax: 25000, shift: 'Evening', location: 'Kozhikode, Kerala', postedDate: DateTime.now().subtract(const Duration(days: 3))),
      Job(id: '4', title: 'Bartender', companyName: 'Zirkon Bar – The Raviz', salaryMin: 18000, salaryMax: 28000, shift: 'Night', location: 'Calicut, Kerala', postedDate: DateTime.now().subtract(const Duration(days: 5))),
    ];
    _notifications = [
      AppNotification(id: '1', title: 'New Bar Lunching at Calicut', body: 'A brand new bar is opening in Calicut. Check it out!', type: 'event', emoji: '🍺', bgColor: '0xFF1A2A3A', timeLabel: '2 hours ago'),
      AppNotification(id: '2', title: 'New Bevco outlet at Palazhi', body: 'New government beverage outlet now open near Palazhi.', type: 'offer', emoji: '🥃', bgColor: '0xFFFADBD8', timeLabel: '5 hours ago'),
      AppNotification(id: '3', title: 'BIRA New Beer Launching', body: 'Bira91 launches new beer – available at selected bars.', type: 'event', emoji: '🐒', bgColor: '0xFF111111', timeLabel: 'Yesterday'),
      AppNotification(id: '4', title: 'Peg Offer at Park Residancy Bar Ramanattukara', body: 'Special peg offer available today.', type: 'offer', emoji: '🍺', bgColor: '0xFFF39C12', timeLabel: '2 days ago'),
      AppNotification(id: '5', title: 'Pub DJ at GOVA Bar – Girls Free Liquor', body: 'Live DJ night this weekend. Ladies get free entry + drinks.', type: 'event', emoji: '🎵', bgColor: '0xFF2A0A3A', timeLabel: '3 days ago'),
    ];
    _posters = [];
    _points = 789;
  }
}
