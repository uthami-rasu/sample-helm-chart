# Project File Structure

## Complete Directory Layout

```
helm/
│
├── lib/
│   ├── main.dart                                # App entry point
│   │
│   ├── config/
│   │   └── app_config.dart                     # ⭐ Configuration (change API URL here)
│   │
│   ├── services/
│   │   └── api_service.dart                    # ⭐ API Service (makes HTTP calls)
│   │
│   ├── models/
│   │   └── models.dart                         # Task & User models
│   │
│   ├── providers/
│   │   ├── auth_provider.dart                  # Auth logic (uses local storage)
│   │   └── task_provider.dart                  # Task CRUD logic (uses local storage)
│   │
│   ├── screens/
│   │   ├── login_screen.dart                   # Login page
│   │   ├── register_screen.dart                # Registration page
│   │   ├── tasks_screen.dart                   # Main tasks page
│   │   └── widgets/
│   │       ├── add_task_dialog.dart            # Add task dialog
│   │       └── edit_task_dialog.dart           # Edit task dialog
│   │
│   └── examples/
│       └── api_integration_example.dart        # ⭐ Example: How to integrate API
│
├── pubspec.yaml                                 # Dependencies (updated with http)
├── pubspec.lock                                 # Lock file (auto-generated)
├── .gitignore                                   # Git ignore rules
│
├── README.md                                    # Main documentation
├── QUICK_START.md                               # How to run app
├── CONFIG_GUIDE.md                              # ⭐ How to configure
├── ARCHITECTURE.md                              # ⭐ How architecture works
├── API_REQUIREMENTS.md                          # What API format to use
└── API_INTEGRATION.md                           # How to provide API details

```

---

## 📍 Key Files & Their Purpose

### Configuration Files (⭐ START HERE)

1. **lib/config/app_config.dart**
   - Location of all API configuration
   - Change API URL here
   - Define endpoints
   - Set environment (dev/staging/prod)
   - Control logging/debug settings

   ```dart
   AppConfig.apiBaseUrl = 'https://api.yoursite.com'
   ```

2. **lib/services/api_service.dart**
   - Singleton API client
   - Makes HTTP requests (GET, POST, PUT, PATCH, DELETE)
   - Uses AppConfig for base URL
   - Handles responses & errors
   - Logs requests/responses

   ```dart
   ApiService().post(endpoint, body, token)
   ```

3. **lib/examples/api_integration_example.dart**
   - Shows how to integrate API with providers
   - Copy/paste patterns for your implementation
   - Commented explanations of each step

### Core Business Logic

4. **lib/providers/auth_provider.dart**
   - Currently uses: SharedPreferences (local storage)
   - Will use: ApiService (when you provide API)
   - Handles: Register, Login, Logout, Sessions
   - Should call: `ApiService().post(endpoint: AppConfig.loginEndpoint, ...)`

5. **lib/providers/task_provider.dart**
   - Currently uses: SharedPreferences (local storage)
   - Will use: ApiService (when you provide API)
   - Handles: Create, Read, Update, Delete, Toggle tasks
   - Should call: `ApiService().get/post/put/delete(...)`

### UI/Screens

6. **lib/screens/login_screen.dart**
   - Users enter email/password
   - Calls: `authProvider.login(email, password)`
   - App navigates to TasksScreen on success

7. **lib/screens/register_screen.dart**
   - Users create new account
   - Calls: `authProvider.register(email, password, fullName)`
   - Auto-logs in after successful registration

8. **lib/screens/tasks_screen.dart**
   - Main app screen after login
   - Shows list of tasks with stats
   - Buttons to add/edit/delete tasks
   - Logout option in menu

### Models

9. **lib/models/models.dart**
   - Task model with fromMap/toMap
   - User model with fromMap/toMap
   - Used throughout the app for type safety

---

## 🔄 How Files Work Together

### Current Flow (Local Storage)

```
login_screen.dart (UI)
    ↓
authProvider.login() (Business Logic - SharedPreferences)
    ↓
Stored in SharedPreferences
    ↓
tasks_screen.dart (UI shows data)
```

### Future Flow (With Your API)

```
login_screen.dart (UI)
    ↓
authProvider.login() (Business Logic - calls API)
    ↓
apiService.post(endpoint: AppConfig.loginEndpoint, ...)
    ↓
HTTP request to: AppConfig.apiBaseUrl + endpoint
    ↓
Your API server
    ↓
Response returned
    ↓
authProvider updates state
    ↓
tasks_screen.dart (UI shows data)
```

---

## 📝 What You Need to Change

### Minimal Changes Needed

1. **Update appConfig.dart** (1 file)

   ```dart
   static const String apiBaseUrl = 'YOUR_API_URL_HERE';
   ```

2. **Update auth_provider.dart** (1 file)
   - Replace SharedPreferences calls with ApiService calls
   - Use AppConfig endpoints

3. **Update task_provider.dart** (1 file)
   - Replace SharedPreferences calls with ApiService calls
   - Use AppConfig endpoints

4. **Update pubspec.yaml** (Already done ✅)
   - Added `http: ^1.1.0` package

---

## 📚 Documentation Files

1. **README.md** - Full documentation with features & setup
2. **QUICK_START.md** - 3 steps to run the app
3. **CONFIG_GUIDE.md** - How to use configuration system
4. **ARCHITECTURE.md** - How different parts work together
5. **API_REQUIREMENTS.md** - Expected API response format
6. **API_INTEGRATION.md** - What info to provide for API

---

## ✅ Current Status

### ✅ Complete

- [x] User authentication UI (login/register)
- [x] Task management UI (add/edit/delete)
- [x] Local storage implementation
- [x] Provider-based state management
- [x] Configuration system (`app_config.dart`)
- [x] API service (`api_service.dart`)
- [x] Example integration code
- [x] Documentation

### ⏳ Waiting For

- [ ] Your API base URL
- [ ] Your API endpoint paths
- [ ] Your API response format

---

## 🎯 Next Steps

### Option 1: Test Local App

```bash
cd /home/arffy/cproj/helm
flutter pub get
flutter run -d chrome
```

### Option 2: Provide API Details

When ready, give me:

1. Your API base URL (e.g., `https://api.yoursite.com`)
2. Exact endpoint paths
3. Response format

Then I'll:

1. Update `config/app_config.dart`
2. Update `providers/auth_provider.dart`
3. Update `providers/task_provider.dart`
4. Test everything works

---

## 🚀 Quick Reference

| Need                    | File                                        | Action                     |
| ----------------------- | ------------------------------------------- | -------------------------- |
| Change API URL          | `lib/config/app_config.dart`                | Update `apiBaseUrl`        |
| Add new endpoint        | `lib/config/app_config.dart`                | Add constant               |
| Make API call           | Use `ApiService()`                          | Call `post/get/put/delete` |
| See how to integrate    | `lib/examples/api_integration_example.dart` | Copy pattern               |
| Understand architecture | `ARCHITECTURE.md`                           | Read flow diagram          |
| Run the app             | Terminal                                    | `flutter run -d chrome`    |

---

## 💡 Tips

1. All endpoints defined in one place → Easy to manage
2. API service is reusable → Share across providers
3. Config can switch environments → Dev/Staging/Prod
4. Error handling centralized → Consistent error messages
5. Logging can be toggled → Debug easily

---

**Ready to provide your API details?** 🚀
