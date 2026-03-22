# Configuration Architecture

## 🏗️ How App Config Works

```
┌─────────────────────────────────────────────────────────────────┐
│                     lib/config/app_config.dart                   │
│                                                                   │
│  - apiBaseUrl: "https://api.yoursite.com"                      │
│  - apiVersion: "v1"                                             │
│  - registerEndpoint: "/api/auth/register"                       │
│  - loginEndpoint: "/api/auth/login"                             │
│  - getTasksEndpoint: "/api/tasks"                               │
│  - etc...                                                        │
│                                                                   │
│  getConfig() → Returns environment-specific config               │
│  getFullUrl(endpoint) → Returns full API URL                    │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                  lib/services/api_service.dart                   │
│                                                                   │
│  - Uses AppConfig.apiBaseUrl                                    │
│  - Uses AppConfig.requestTimeoutSeconds                         │
│  - Uses AppConfig.enableLogging                                 │
│                                                                   │
│  Methods:                                                        │
│  - post(endpoint, body, token)                                  │
│  - get(endpoint, token)                                         │
│  - put(endpoint, body, token)                                   │
│  - patch(endpoint, body, token)                                 │
│  - delete(endpoint, token)                                      │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│          lib/providers/auth_provider.dart    (Example)           │
│          lib/providers/task_provider.dart    (Example)           │
│                                                                   │
│  Uses ApiService to make API calls:                             │
│                                                                   │
│  apiService.post(                                               │
│    endpoint: AppConfig.loginEndpoint,                           │
│    body: {...},                                                 │
│    token: token                                                 │
│  )                                                               │
│                                                                   │
│  Full URL becomes:                                              │
│  https://api.yoursite.com + /api/auth/login                   │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│               Your Flutter UI (Screens & Widgets)                │
│                                                                   │
│  Uses providers:                                                 │
│  - AuthProvider.login()                                         │
│  - TaskProvider.fetchTasks()                                    │
│  - etc...                                                        │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📊 Data Flow

### 1. **Request Flow with Config**

```
User clicks Login Button
         ↓
UI calls: authProvider.login(email, password)
         ↓
Adapter calls: apiService.post(
  endpoint: AppConfig.loginEndpoint,    ← /api/auth/login
  body: {...}
)
         ↓
ApiService constructs URL:
  AppConfig.apiBaseUrl + endpoint
  = https://api.yoursite.com + /api/auth/login
  = https://api.yoursite.com/api/auth/login
         ↓
HTTP POST request sent to your API
         ↓
Response received & parsed
         ↓
UI updated with results
```

### 2. **How Config Flows**

```
app_config.dart
└── apiBaseUrl = "https://api.yoursite.com"
    └── Used by api_service.dart
        └── Constructs full URLs for all endpoints
            └── Passed to auth_provider.dart
                └── Called by login_screen.dart
                    └── Displayed in UI
```

---

## 🔄 Request Cycle Example

### Step-by-step: User Login

```
1. User enters email & password in login_screen.dart

2. Clicks "Login" button
   └─→ Calls: context.read<AuthProvider>().login(email, password)

3. AuthProvider.login() executes:
   └─→ apiService.post(
       endpoint: AppConfig.loginEndpoint,  // "/api/auth/login"
       body: {email, password}
     )

4. ApiService.post() does:
   └─→ url = Uri.parse(AppConfig.apiBaseUrl + endpoint)
       // https://api.yoursite.com/api/auth/login
   └─→ http.post(url, headers, body)

5. Server responds with:
   {
     "success": true,
     "user": {...},
     "token": "token_string"
   }

6. AuthProvider receives response:
   └─→ _currentUser = User.fromMap(response['user'])
   └─→ _token = response['token']
   └─→ _isLoggedIn = true
   └─→ notifyListeners()

7. UI rebuilds:
   └─→ MainPage sees isLoggedIn = true
   └─→ Shows TasksScreen instead of LoginScreen
```

---

## 🎯 Configuration Reference

### Where Each Part Lives

```
Configuration (app_config.dart)
├── API Base URL
├── Endpoint Paths
├── Timeouts
├── Feature Flags
└── Environment Settings

API Service (api_service.dart)
├── Uses AppConfig values
├── Makes HTTP requests
├── Handles responses
└── Logs errors

Providers (Uses API Service)
├── auth_provider.dart
│   ├── Uses: AppConfig.loginEndpoint
│   ├── Uses: AppConfig.registerEndpoint
│   └── Uses: ApiService
├── task_provider.dart
│   ├── Uses: AppConfig.getTasksEndpoint
│   ├── Uses: AppConfig.createTaskEndpoint
│   └── Uses: ApiService
└── Stores tokens from responses
```

---

## 🔧 When You Provide API Details

### You Give Me

```
API Base URL: https://your-api.com
Endpoints:
  - POST /auth/register
  - POST /auth/login
  - GET /tasks
  - POST /tasks
  - PUT /tasks/{id}
  - DELETE /tasks/{id}
  - PATCH /tasks/{id}/toggle
Response format: {...}
```

### I Will Update

```
1. lib/config/app_config.dart
   └─ Update apiBaseUrl
   └─ Update endpoints if different

2. lib/providers/auth_provider.dart
   └─ Replace local storage with API calls
   └─ Use AppConfig.loginEndpoint

3. lib/providers/task_provider.dart
   └─ Replace local storage with API calls
   └─ Use AppConfig.getTasksEndpoint, etc.

4. Token management
   └─ Store securely
   └─ Pass to all authenticated requests
```

---

## 📋 Quick Integration Checklist

- [ ] Have your API base URL ready
- [ ] Know your endpoint paths
- [ ] Know your response format
- [ ] Know your authentication method (Bearer token?)
- [ ] Have error response format documented

Once you provide these, integration is fast!

---

## 💡 Key Takeaways

1. **Config File** = Single source of truth for all API settings
2. **API Service** = Reusable HTTP client that uses config
3. **Providers** = Business logic that uses API service
4. **UI** = Calls providers, doesn't know about API directly

This separation makes it easy to:

- ✅ Switch API URLs for different environments
- ✅ Change endpoints without touching UI code
- ✅ Add/remove logging easily
- ✅ Adjust timeouts globally
- ✅ Add new API features without UI changes
