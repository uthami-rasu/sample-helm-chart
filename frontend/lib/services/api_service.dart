import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:js' as js;
import '../config/app_config.dart';

/// API Service for handling all HTTP requests
/// Uses AppConfig to get endpoints and base URL

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  /// Helper function for logging
  void _log(String message) {
    if (AppConfig.enableLogging) {
      if (kDebugMode) {
        print('[API] $message');
      }
    }
  }

  /// GET request
  Future<Map<String, dynamic>> get({
    required String endpoint,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
      _log('GET $url');

      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.get(url, headers: headers).timeout(
        Duration(seconds: AppConfig.requestTimeoutSeconds),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      _log('Response: ${response.statusCode} - ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      _log('GET Error: $e');
      rethrow;
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
      _log('POST $url with body: $body');

      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http
          .post(
            url,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(
            Duration(seconds: AppConfig.requestTimeoutSeconds),
            onTimeout: () {
              throw Exception('Request timeout');
            },
          );

      _log('Response: ${response.statusCode} - ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      _log('POST Error: $e');
      rethrow;
    }
  }

  /// PUT request
  Future<Map<String, dynamic>> put({
    required String endpoint,
    required Map<String, dynamic> body,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
      _log('PUT $url with body: $body');

      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http
          .put(
            url,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(
            Duration(seconds: AppConfig.requestTimeoutSeconds),
            onTimeout: () {
              throw Exception('Request timeout');
            },
          );

      _log('Response: ${response.statusCode} - ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      _log('PUT Error: $e');
      rethrow;
    }
  }

  /// PATCH request
  Future<Map<String, dynamic>> patch({
    required String endpoint,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
      _log('PATCH $url');

      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http
          .patch(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(
            Duration(seconds: AppConfig.requestTimeoutSeconds),
            onTimeout: () {
              throw Exception('Request timeout');
            },
          );

      _log('Response: ${response.statusCode} - ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      _log('PATCH Error: $e');
      rethrow;
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete({
    required String endpoint,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
      _log('DELETE $url');

      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.delete(url, headers: headers).timeout(
        Duration(seconds: AppConfig.requestTimeoutSeconds),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      _log('Response: ${response.statusCode} - ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      _log('DELETE Error: $e');
      rethrow;
    }
  }

  /// Handle API response
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final dynamic decoded = jsonDecode(response.body);
      Map<String, dynamic> jsonResponse;

      if (decoded is List) {
        jsonResponse = {'body': decoded};
      } else if (decoded is Map) {
        jsonResponse = Map<String, dynamic>.from(decoded);
      } else {
        jsonResponse = {'body': decoded};
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Success
        return {
          'success': true,
          'statusCode': response.statusCode,
          ...jsonResponse,
        };
      } else if (response.statusCode == 401) {
        // Unauthorized
        throw Exception('Unauthorized: ${jsonResponse['message'] ?? 'Invalid credentials'}');
      } else if (response.statusCode == 404) {
        // Not found
        throw Exception('Not found: ${jsonResponse['message'] ?? 'Resource not found'}');
      } else if (response.statusCode == 400) {
        // Bad request
        throw Exception('Bad request: ${jsonResponse['message'] ?? 'Invalid request'}');
      } else {
        // Other error
        throw Exception(jsonResponse['message'] ?? 'Server error (${response.statusCode})');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format: ${response.body}');
      }
      rethrow;
    }
  }
}
