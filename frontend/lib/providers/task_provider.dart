import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../config/app_config.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  String _errorMessage = '';
  final ApiService _apiService = ApiService();
  String? _authToken;

  List<Task> get tasks => _tasks;
  String get errorMessage => _errorMessage;

  void updateToken(String? token) {
    _authToken = token;
    if (_authToken != null) {
      fetchTasks();
    } else {
      _tasks = [];
      notifyListeners();
    }
  }

  Future<void> fetchTasks() async {
    if (_authToken == null) return;

    try {
      final response = await _apiService.get(
        endpoint: AppConfig.getTasksEndpoint,
        token: _authToken,
      );

      if (response['success'] == true) {
        final List<dynamic> taskData = response['tasks'] ?? response['body'] ?? (response is List ? response : []);
        
        // If ApiService returns List directly in 'body'
        if (response['body'] is List) {
           _tasks = (response['body'] as List).map((e) => Task.fromMap(e)).toList();
        } else if (response['tasks'] is List) {
           _tasks = (response['tasks'] as List).map((e) => Task.fromMap(e)).toList();
        } else {
           // Fallback for direct list if ApiService was modified
           _tasks = [];
        }
        
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to load tasks: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<bool> addTask({
    required String title,
    required String description,
  }) async {
    if (_authToken == null) return false;

    try {
      _errorMessage = '';
      notifyListeners();

      final response = await _apiService.post(
        endpoint: AppConfig.createTaskEndpoint,
        token: _authToken,
        body: {
          'title': title,
          'description': description,
        },
      );

      if (response['success'] == true) {
        await fetchTasks();
        return true;
      }
      
      _errorMessage = response['message'] ?? 'Failed to add task';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask({
    required String id,
    required String title,
    required String description,
  }) async {
    if (_authToken == null) return false;

    try {
      _errorMessage = '';
      notifyListeners();

      final response = await _apiService.put(
        endpoint: '${AppConfig.updateTaskEndpoint}/$id',
        token: _authToken,
        body: {
          'title': title,
          'description': description,
        },
      );

      if (response['success'] == true) {
        await fetchTasks();
        return true;
      }

      _errorMessage = response['message'] ?? 'Failed to update task';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTask({required String id}) async {
    if (_authToken == null) return false;

    try {
      _errorMessage = '';
      notifyListeners();

      final response = await _apiService.delete(
        endpoint: '${AppConfig.deleteTaskEndpoint}/$id',
        token: _authToken,
      );

      if (response['success'] == true) {
        await fetchTasks();
        return true;
      }

      _errorMessage = response['message'] ?? 'Failed to delete task';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleTaskCompletion({required String id}) async {
    if (_authToken == null) return false;

    try {
      _errorMessage = '';
      notifyListeners();

      final response = await _apiService.patch(
        endpoint: '${AppConfig.toggleTaskEndpoint}/$id/toggle',
        token: _authToken,
      );

      if (response['success'] == true) {
        await fetchTasks();
        return true;
      }

      _errorMessage = response['message'] ?? 'Failed to toggle task';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  int get completedTasksCount => _tasks.where((task) => task.isCompleted).length;
  int get pendingTasksCount => _tasks.where((task) => !task.isCompleted).length;
}
