import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../config/app_config.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;
  String? _token;
  String _errorMessage = '';
  final ApiService _apiService = ApiService();

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  String get errorMessage => _errorMessage;

  AuthProvider() {
    _initializeFromStorage();
  }

  Future<void> _initializeFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');
      _token = prefs.getString('auth_token');
      
      if (userJson != null && _token != null) {
        _currentUser = User.fromMap(jsonDecode(userJson));
        _isLoggedIn = true;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to load user data';
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      _errorMessage = '';
      notifyListeners();

      final response = await _apiService.post(
        endpoint: AppConfig.registerEndpoint,
        body: {
          'email': email,
          'password': password,
          'fullName': fullName,
        },
      );

      if (response['success'] == true) {
        // After registration, we usually ask user to login or auto-login
        // For now, let's just return true and let the UI handle the next step
        return true;
      }
      
      _errorMessage = response['message'] ?? 'Registration failed';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _errorMessage = '';
      notifyListeners();

      final response = await _apiService.post(
        endpoint: AppConfig.loginEndpoint,
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response['success'] == true) {
        _token = response['token'];
        _currentUser = User(
          id: response['id'].toString(),
          email: response['email'],
          fullName: response['fullName'],
        );
        _isLoggedIn = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('current_user', jsonEncode(_currentUser!.toMap()));

        notifyListeners();
        return true;
      }

      _errorMessage = response['message'] ?? 'Login failed';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user');
      await prefs.remove('auth_token');
      
      _currentUser = null;
      _token = null;
      _isLoggedIn = false;
      _errorMessage = '';
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Logout failed: ${e.toString()}';
      notifyListeners();
    }
  }
}
