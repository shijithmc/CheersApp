import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  static const _baseUrl = 'http://localhost:5000';

  final http.Client _client;
  String? _authToken;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  void setToken(String token) => _authToken = token;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  // Auth
  Future<Map<String, dynamic>> sendOtp(String phone) async {
    final res = await _client.post(Uri.parse('$_baseUrl/auth/otp'),
        headers: _headers, body: jsonEncode({'phone': phone}));
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final res = await _client.post(Uri.parse('$_baseUrl/auth/verify'),
        headers: _headers, body: jsonEncode({'phone': phone, 'otp': otp}));
    return jsonDecode(res.body);
  }

  // Users
  Future<UserModel> getProfile(String uid) async {
    final res = await _client.get(Uri.parse('$_baseUrl/users/$uid'), headers: _headers);
    return UserModel.fromJson(jsonDecode(res.body));
  }

  Future<void> updateProfile(UserModel user) async {
    await _client.put(Uri.parse('$_baseUrl/users/${user.uid}'),
        headers: _headers, body: jsonEncode(user.toJson()));
  }

  // Venues
  Future<List<Venue>> getVenues({String? category}) async {
    final query = category != null ? '?category=$category' : '';
    final res = await _client.get(Uri.parse('$_baseUrl/venues$query'), headers: _headers);
    final list = jsonDecode(res.body) as List;
    return list.map((e) => Venue.fromJson(e)).toList();
  }

  Future<Venue> getVenue(String id) async {
    final res = await _client.get(Uri.parse('$_baseUrl/venues/$id'), headers: _headers);
    return Venue.fromJson(jsonDecode(res.body));
  }

  // Events
  Future<List<Event>> getEvents() async {
    final res = await _client.get(Uri.parse('$_baseUrl/events'), headers: _headers);
    final list = jsonDecode(res.body) as List;
    return list.map((e) => Event.fromJson(e)).toList();
  }

  // Offers
  Future<List<Offer>> getOffers() async {
    final res = await _client.get(Uri.parse('$_baseUrl/offers'), headers: _headers);
    final list = jsonDecode(res.body) as List;
    return list.map((e) => Offer.fromJson(e)).toList();
  }

  // Jobs
  Future<List<Job>> getJobs() async {
    final res = await _client.get(Uri.parse('$_baseUrl/jobs'), headers: _headers);
    final list = jsonDecode(res.body) as List;
    return list.map((e) => Job.fromJson(e)).toList();
  }

  Future<void> applyJob(String jobId, String userId) async {
    await _client.post(Uri.parse('$_baseUrl/jobs/$jobId/apply'),
        headers: _headers, body: jsonEncode({'user_id': userId}));
  }

  // Points
  Future<int> getPoints(String userId) async {
    final res = await _client.get(Uri.parse('$_baseUrl/points/$userId'), headers: _headers);
    return jsonDecode(res.body)['total_points'] ?? 0;
  }

  // Referral
  Future<void> submitReferral(String userId, String referralCode) async {
    await _client.post(Uri.parse('$_baseUrl/referral'),
        headers: _headers,
        body: jsonEncode({'user_id': userId, 'referral_code': referralCode}));
  }

  // Notifications
  Future<List<AppNotification>> getNotifications(String userId) async {
    final res = await _client.get(Uri.parse('$_baseUrl/notifications/$userId'), headers: _headers);
    final list = jsonDecode(res.body) as List;
    return list.map((e) => AppNotification.fromJson(e)).toList();
  }

  // Banners
  Future<List<AppBanner>> getBanners() async {
    final res = await _client.get(Uri.parse('$_baseUrl/banners'), headers: _headers);
    final list = jsonDecode(res.body) as List;
    return list.map((e) => AppBanner.fromJson(e)).toList();
  }

  // Posters
  Future<List<Poster>> getPosters({String? category}) async {
    final query = category != null ? '?category=$category' : '';
    final res = await _client.get(Uri.parse('$_baseUrl/posters$query'), headers: _headers);
    final list = jsonDecode(res.body) as List;
    return list.map((e) => Poster.fromJson(e)).toList();
  }
}
