import 'package:flutter/material.dart';
import 'dart:convert';
import '../config/app_config.dart';
import '../services/api_service.dart';
import '../models/models.dart';

/// EXAMPLE: How to use AppConfig with API Service
/// 
/// This file shows how you can integrate API calls with the configuration
/// Replace the local storage implementation with these API calls

class AuthProviderAPIExample extends ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;
  String _errorMessage = '';
  String? _token;

  // Initialize API service
  final apiService = ApiService();

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  String get errorMessage => _errorMessage;

  /// EXAMPLE: Register with API
  /// 
  /// Instead of local storage, this calls your backend API
  /// The endpoint is defined in AppConfig.registerEndpoint
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      _errorMessage = '';

      if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
        _errorMessage = 'All fields are required';
        notifyListeners();
        return false;
      }

      // Call API using config endpoint
      final response = await apiService.post(
        endpoint: AppConfig.registerEndpoint,  // /api/auth/register
        body: {
          'email': email,
          'password': password,
          'fullName': fullName,
        },
      );

      if (response['success']) {
        // Extract user data from response
        final userData = response['user'] as Map<String, dynamic>;
        _currentUser = User(
          id: userData['id'] ?? '',
          email: userData['email'] ?? '',
          fullName: userData['fullName'] ?? '',
        );

        // Store token if provided
        if (response['token'] != null) {
          _token = response['token'];
        }

        _isLoggedIn = true;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Registration failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Registration error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// EXAMPLE: Login with API
  /// 
  /// Calls the login endpoint from AppConfig
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _errorMessage = '';

      if (email.isEmpty || password.isEmpty) {
        _errorMessage = 'Email and password are required';
        notifyListeners();
        return false;
      }

      // Call API using config endpoint
      final response = await apiService.post(
        endpoint: AppConfig.loginEndpoint,  // /api/auth/login
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response['success']) {
        final userData = response['user'] as Map<String, dynamic>;
        _currentUser = User(
          id: userData['id'] ?? '',
          email: userData['email'] ?? '',
          fullName: userData['fullName'] ?? '',
        );

        // Store token for future requests
        if (response['token'] != null) {
          _token = response['token'];
          // TODO: Save token securely (not in SharedPreferences)
          // await secureStorage.write(key: 'auth_token', value: _token);
        }

        _isLoggedIn = true;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Login failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// EXAMPLE: Logout with API
  Future<void> logout() async {
    try {
      // Optional: Call logout endpoint
      if (_token != null) {
        try {
          await apiService.post(
            endpoint: AppConfig.logoutEndpoint,  // /api/auth/logout
            token: _token,
            body: {},
          );
        } catch (e) {
          // Continue with logout even if API call fails
        }
      }

      // Clear local data
      _currentUser = null;
      _isLoggedIn = false;
      _token = null;
      _errorMessage = '';
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Logout error: ${e.toString()}';
      notifyListeners();
    }
  }
}

/// EXAMPLE: Task Provider with API calls
class TaskProviderAPIExample extends ChangeNotifier {
  List<Task> _tasks = [];
  String _errorMessage = '';
  String? _token;

  final apiService = ApiService();

  List<Task> get tasks => _tasks;
  String get errorMessage => _errorMessage;

  /// EXAMPLE: Fetch all tasks from API
  /// 
  /// Calls GET endpoint to retrieve user's tasks
  Future<bool> fetchTasks({required String token}) async {
    try {
      _errorMessage = '';
      _token = token;

      // Call API using config endpoint
      final response = await apiService.get(
        endpoint: AppConfig.getTasksEndpoint,  // /api/tasks
        token: token,
      );

      if (response['success']) {
        final taskList = response['data'] as List<dynamic>;
        _tasks = taskList
            .map((task) => Task.fromMap(task as Map<String, dynamic>))
            .toList();
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to fetch tasks';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Fetch error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// EXAMPLE: Add task via API
  /// 
  /// POST to create a new task
  Future<bool> addTask({
    required String title,
    required String description,
  }) async {
    try {
      _errorMessage = '';

      if (title.isEmpty) {
        _errorMessage = 'Title is required';
        notifyListeners();
        return false;
      }

      // Call API using config endpoint
      final response = await apiService.post(
        endpoint: AppConfig.createTaskEndpoint,  // /api/tasks
        body: {
          'title': title,
          'description': description,
        },
        token: _token,
      );

      if (response['success']) {
        final taskData = response['data'] as Map<String, dynamic>;
        final task = Task.fromMap(taskData);
        _tasks.add(task);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to add task';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Add task error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// EXAMPLE: Update task via API
  /// 
  /// PUT to update task details
  Future<bool> updateTask({
    required String id,
    required String title,
    required String description,
  }) async {
    try {
      _errorMessage = '';

      if (title.isEmpty) {
        _errorMessage = 'Title is required';
        notifyListeners();
        return false;
      }

      // Call API using config endpoint
      final response = await apiService.put(
        endpoint: '${AppConfig.updateTaskEndpoint}/$id',  // /api/tasks/{id}
        body: {
          'title': title,
          'description': description,
        },
        token: _token,
      );

      if (response['success']) {
        final taskData = response['data'] as Map<String, dynamic>;
        final index = _tasks.indexWhere((task) => task.id == id);
        if (index != -1) {
          _tasks[index] = Task.fromMap(taskData);
          notifyListeners();
          return true;
        }
        throw Exception('Task not found locally');
      } else {
        _errorMessage = response['message'] ?? 'Failed to update task';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Update error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// EXAMPLE: Delete task via API
  /// 
  /// DELETE to remove a task
  Future<bool> deleteTask({required String id}) async {
    try {
      _errorMessage = '';

      // Call API using config endpoint
      final response = await apiService.delete(
        endpoint: '${AppConfig.deleteTaskEndpoint}/$id',  // /api/tasks/{id}
        token: _token,
      );

      if (response['success']) {
        _tasks.removeWhere((task) => task.id == id);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to delete task';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Delete error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// EXAMPLE: Toggle task completion via API
  /// 
  /// PATCH to toggle completion status
  Future<bool> toggleTaskCompletion({required String id}) async {
    try {
      _errorMessage = '';

      // Call API using config endpoint
      final response = await apiService.patch(
        endpoint: '${AppConfig.toggleTaskEndpoint}/$id/toggle',  // /api/tasks/{id}/toggle
        token: _token,
      );

      if (response['success']) {
        final taskData = response['data'] as Map<String, dynamic>;
        final index = _tasks.indexWhere((task) => task.id == id);
        if (index != -1) {
          _tasks[index] = Task.fromMap(taskData);
          notifyListeners();
          return true;
        }
        throw Exception('Task not found locally');
      } else {
        _errorMessage = response['message'] ?? 'Failed to update task';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Toggle error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}

/// KEY POINTS:
/// 
/// 1. All endpoints come from AppConfig:
///    - AppConfig.loginEndpoint
///    - AppConfig.registerEndpoint
///    - AppConfig.getTasksEndpoint
///    - etc.
///
/// 2. API calls use ApiService:
///    - apiService.post(endpoint: ..., body: ..., token: ...)
///    - apiService.get(endpoint: ..., token: ...)
///    - apiService.put(endpoint: ..., body: ..., token: ...)
///    - apiService.delete(endpoint: ..., token: ...)
///
/// 3. Full URL is built automatically:
///    - AppConfig.apiBaseUrl + endpoint
///    - Example: https://api.yoursite.com + /api/tasks = https://api.yoursite.com/api/tasks
///
/// 4. Tokens are passed for authenticated requests:
///    - token: _token (stored from login response)
///
/// 5. Error handling from API:
///    - response['success'] tells if request succeeded
///    - response['message'] contains error messages
///    - response['data'] contains the returned object
