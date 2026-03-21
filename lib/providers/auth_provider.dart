import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api;
  UserModel? _user;
  bool _isLoading = false;
  bool _isLoggedIn = false;

  AuthProvider(this._api);

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    if (uid != null) {
      _isLoggedIn = true;
      try {
        _user = await _api.getProfile(uid);
      } catch (_) {}
      notifyListeners();
    }
  }

  Future<bool> sendOtp(String phone) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _api.sendOtp(phone);
      return true;
    } catch (_) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _api.verifyOtp(phone, otp);
      final token = res['token'] as String?;
      final uid = res['uid'] as String?;
      if (token != null && uid != null) {
        _api.setToken(token);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', uid);
        await prefs.setString('token', token);
        _isLoggedIn = true;
        _user = await _api.getProfile(uid);
        notifyListeners();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(UserModel updated) async {
    await _api.updateProfile(updated);
    _user = updated;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
