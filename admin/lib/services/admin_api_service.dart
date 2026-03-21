import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminApiService {
  // TODO: Replace with your API Gateway endpoint after CDK deploy
  // TODO: Replace with your Web API URL after deployment
  static const _baseUrl = 'http://localhost:5062';

  final http.Client _client;
  String? _adminToken;

  AdminApiService({http.Client? client}) : _client = client ?? http.Client();

  bool get isAuthenticated => _adminToken != null;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_adminToken != null) 'Authorization': 'Bearer $_adminToken',
        'X-Admin': 'true',
      };

  Future<bool> login(String email, String password) async {
    try {
      final res = await _client.post(Uri.parse('$_baseUrl/admin/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _adminToken = data['token'];
        return true;
      }
    } catch (_) {}
    return false;
  }

  void logout() => _adminToken = null;

  // Venues
  Future<List<Map<String, dynamic>>> getVenues() async {
    final res = await _client.get(Uri.parse('$_baseUrl/venues'), headers: _headers);
    return List<Map<String, dynamic>>.from(jsonDecode(res.body));
  }

  Future<void> addVenue(Map<String, dynamic> venue) async {
    await _client.post(Uri.parse('$_baseUrl/venues'),
        headers: _headers, body: jsonEncode(venue));
  }

  Future<void> deleteVenue(String id) async {
    await _client.delete(Uri.parse('$_baseUrl/venues/$id'), headers: _headers);
  }

  // Events
  Future<List<Map<String, dynamic>>> getEvents() async {
    final res = await _client.get(Uri.parse('$_baseUrl/events'), headers: _headers);
    return List<Map<String, dynamic>>.from(jsonDecode(res.body));
  }

  Future<void> addEvent(Map<String, dynamic> event) async {
    await _client.post(Uri.parse('$_baseUrl/events'),
        headers: _headers, body: jsonEncode(event));
  }

  Future<void> deleteEvent(String id) async {
    await _client.delete(Uri.parse('$_baseUrl/events/$id'), headers: _headers);
  }

  // Offers
  Future<List<Map<String, dynamic>>> getOffers() async {
    final res = await _client.get(Uri.parse('$_baseUrl/offers'), headers: _headers);
    return List<Map<String, dynamic>>.from(jsonDecode(res.body));
  }

  Future<void> addOffer(Map<String, dynamic> offer) async {
    await _client.post(Uri.parse('$_baseUrl/offers'),
        headers: _headers, body: jsonEncode(offer));
  }

  Future<void> deleteOffer(String id) async {
    await _client.delete(Uri.parse('$_baseUrl/offers/$id'), headers: _headers);
  }

  // Jobs
  Future<List<Map<String, dynamic>>> getJobs() async {
    final res = await _client.get(Uri.parse('$_baseUrl/jobs'), headers: _headers);
    return List<Map<String, dynamic>>.from(jsonDecode(res.body));
  }

  Future<void> addJob(Map<String, dynamic> job) async {
    await _client.post(Uri.parse('$_baseUrl/jobs'),
        headers: _headers, body: jsonEncode(job));
  }

  Future<void> deleteJob(String id) async {
    await _client.delete(Uri.parse('$_baseUrl/jobs/$id'), headers: _headers);
  }

  // Analytics
  Future<Map<String, dynamic>> getAnalytics() async {
    final res = await _client.get(Uri.parse('$_baseUrl/admin/analytics'), headers: _headers);
    return jsonDecode(res.body);
  }
}
