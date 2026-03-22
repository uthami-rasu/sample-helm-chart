# App Configuration & How to Use It

## 📍 Configuration Location

```
lib/config/app_config.dart  ← Main configuration file
```

## 🔧 Current Configuration

The app uses a centralized configuration system in `lib/config/app_config.dart`:

```dart
AppConfig.apiBaseUrl      // Base API URL (change this!)
AppConfig.apiVersion      // API version
AppConfig.appName         // App name
AppConfig.enableLogging   // Debug logging
```

---

## 📝 How to Change Configuration

### Step 1: Update API Base URL

Edit `lib/config/app_config.dart`:

```dart
class AppConfig {
  // Change this to your API URL:
  static const String apiBaseUrl = 'https://api.yourbackend.com';

  // Or for local development:
  // static const String apiBaseUrl = 'http://localhost:3000';
}
```

### Step 2: Update Endpoints (if needed)

```dart
static const String registerEndpoint = '/api/auth/register';
static const String loginEndpoint = '/api/auth/login';
static const String getTasksEndpoint = '/api/tasks';
// etc...
```

---

## 📞 How to Call It

### In Your Code

```dart
// Import config
import 'package:your_app/config/app_config.dart';
import 'package:your_app/services/api_service.dart';

// Use it anywhere:
class MyProvider {
  final apiService = ApiService();

  void example() {
    // Get base URL
    print(AppConfig.apiBaseUrl);  // https://api.yourbackend.com

    // Get full endpoint URL
    String url = AppConfig.getFullUrl(AppConfig.loginEndpoint);
    // Result: https://api.yourbackend.com/api/auth/login

    // Make API call
    final response = await apiService.post(
      endpoint: AppConfig.loginEndpoint,
      body: {'email': 'user@test.com', 'password': 'pass123'},
    );
  }
}
```

---

## 🌍 Environment-Specific Configuration

The config supports multiple environments:

### Development

```dart
AppConfig.development
// Base URL: http://localhost:3000
// Logging: Enabled
// Debug Mode: Enabled
```

### Staging

```dart
AppConfig.staging
// Base URL: https://api-staging.yourbackend.com
// Logging: Enabled
// Debug Mode: Disabled
```

### Production

```dart
AppConfig.production
// Base URL: https://api.yourbackend.com
// Logging: Disabled
// Debug Mode: Disabled
```

**Switch Environment:**

```dart
// In app_config.dart
static const String environment = 'development'; // Change to 'staging' or 'production'
```

---

## 🚀 Real-World Example: Using Config in AuthProvider

```dart
import 'package:provider/provider.dart';
import '../config/app_config.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final apiService = ApiService();

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      // Call API using config endpoints
      final response = await apiService.post(
        endpoint: AppConfig.loginEndpoint,  // Uses /api/auth/login
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response['success']) {
        // Handle login success
        return true;
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
```

---

## 📌 Where Config is Used

### 1. In Providers

```dart
// auth_provider.dart
final apiService = ApiService();
await apiService.post(
  endpoint: AppConfig.loginEndpoint,
  body: body,
);
```

### 2. In Services

```dart
// api_service.dart
final url = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
```

### 3. In UI (Optional)

```dart
// In any screen/widget
print(AppConfig.appName);  // "Task Manager"
```

---

## ✅ Quick Reference

| What                 | Where                                    | How                                      |
| -------------------- | ---------------------------------------- | ---------------------------------------- |
| Change API URL       | `lib/config/app_config.dart` line 9      | `static const String apiBaseUrl = '...'` |
| Change endpoints     | `lib/config/app_config.dart` lines 12-18 | Update the endpoint constants            |
| Switch environment   | `lib/config/app_config.dart` line 5      | Change `environment` variable            |
| Make API calls       | Via `ApiService()`                       | Use `AppConfig` constants for endpoints  |
| Check config in logs | Enable `enableLogging`                   | Set to `true` in AppConfig               |

---

## 🔄 How Providers Will Use Config

### When You Provide API Details:

1. **AuthProvider** will use:

   ```dart
   endpoint: AppConfig.loginEndpoint
   endpoint: AppConfig.registerEndpoint
   ```

2. **TaskProvider** will use:

   ```dart
   endpoint: AppConfig.getTasksEndpoint
   endpoint: AppConfig.createTaskEndpoint
   endpoint: AppConfig.updateTaskEndpoint
   endpoint: AppConfig.deleteTaskEndpoint
   ```

3. **ApiService** will use:
   ```dart
   AppConfig.apiBaseUrl + endpoint
   AppConfig.requestTimeoutSeconds
   AppConfig.enableLogging
   ```

---

## 📋 TODO: When You Have API

1. Get these from your API provider:

   ```
   - Base API URL (https://api.yoursite.com)
   - Exact endpoint paths
   - Request/response format
   ```

2. Update `AppConfig`:

   ```dart
   static const String apiBaseUrl = 'YOUR_API_URL_HERE';
   ```

3. Update endpoints if different:

   ```dart
   static const String loginEndpoint = '/your/endpoint/path';
   ```

4. I'll update the providers to use API instead of local storage

---

## 🎯 Summary

- ✅ **Config File**: `lib/config/app_config.dart`
- ✅ **API Service**: `lib/services/api_service.dart`
- ✅ **How to Call**: Via `AppConfig` constants in your providers
- ✅ **When Ready**: Just give me your API URL and I'll integrate it!
