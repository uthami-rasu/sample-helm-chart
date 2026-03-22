import 'dart:js' as js;

/// App Configuration
///
/// Backend URL is injected at build time via --dart-define=BACKEND_URL=...
/// Example:
///   flutter build web --dart-define=BACKEND_URL=https://api.example.com
///
/// In Docker:
///   docker build --build-arg BACKEND_URL=https://api.example.com .

class AppConfig {
  // --- Backend URL ---
  // Read from window.APP_CONFIG at runtime. 
  // This allows the same Docker image to be used for multiple environments.
  static String get apiBaseUrl =>
      js.context['APP_CONFIG']['BACKEND_URL'] ?? '/api';

  // API Endpoints
  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';
  static const String getTasksEndpoint = '/tasks';
  static const String createTaskEndpoint = '/tasks';
  static const String updateTaskEndpoint = '/tasks'; // PUT /tasks/{id}
  static const String deleteTaskEndpoint = '/tasks'; // DELETE /tasks/{id}
  static const String toggleTaskEndpoint = '/tasks'; // PATCH /tasks/{id}/toggle

  // App Settings
  static const String appName = 'Task Manager';
  static const String appVersion = '1.0.0';
  static const int requestTimeoutSeconds = 30;

  // Feature Flags
  static const bool enableLogging = bool.fromEnvironment('ENABLE_LOGGING', defaultValue: true);
  static const bool enableDebugMode = bool.fromEnvironment('DEBUG_MODE', defaultValue: false);

  // Get Full URL for an endpoint
  static String getFullUrl(String endpoint) {
    return '$apiBaseUrl$endpoint';
  }
}
