# Quick Start Guide

## Get the App Running in 3 Steps

### Step 1: Install Dependencies

```bash
cd /home/arffy/cproj/helm
flutter pub get
```

### Step 2: Run the App

```bash
flutter run -d chrome
```

### Step 3: Test It!

- **Register**: Create a new account with any email/password
- **Login**: Use your registered credentials
- **Add Tasks**: Click the "+" button to add tasks
- **Manage Tasks**: Check/uncheck to mark complete, edit, or delete

---

## Test the App

### Create Test User

1. Click "Register"
2. Fill in:
   - Full Name: `John Doe`
   - Email: `john@example.com`
   - Password: `password123`
   - Confirm Password: `password123`
3. Click "Register"

### Add Test Tasks

1. Click "+" button
2. Add tasks like:
   - "Buy groceries" - Description: "Milk, eggs, bread"
   - "Complete project" - Description: "Flutter app CRUD"
   - "Call mom" - Description: "Check if she's okay"

### Try Features

- ✅ Check tasks to mark as complete
- ✏️ Click menu → "Edit" to change task details
- 🗑️ Click menu → "Delete" to remove tasks
- 📊 See stats update in real-time
- 🚪 Click menu (top-right) → "Logout"

---

## Project Structure Overview

```
helm/
├── pubspec.yaml                 # Dependencies
├── lib/
│   ├── main.dart               # App entry point
│   ├── models/
│   │   └── models.dart        # Task & User models
│   ├── providers/
│   │   ├── auth_provider.dart  # Auth logic
│   │   └── task_provider.dart  # Task CRUD logic
│   └── screens/
│       ├── login_screen.dart    # Login page
│       ├── register_screen.dart # Register page
│       ├── tasks_screen.dart    # Main app page
│       └── widgets/
│           ├── add_task_dialog.dart
│           └── edit_task_dialog.dart
├── README.md                    # Full documentation
├── API_REQUIREMENTS.md          # API spec details
├── API_INTEGRATION.md          # Info to provide for API
└── .gitignore
```

---

## What's Included

✅ **Complete Flutter Web App**

- Clean UI with Material Design
- Responsive layout
- Form validation
- Error messages

✅ **User Management**

- Registration with validation
- Login system
- Session persistence
- Logout functionality

✅ **Task Management (CRUD)**

- Create tasks with title & description
- View all tasks with statistics
- Edit task details
- Delete tasks
- Mark tasks as complete/incomplete

✅ **State Management**

- Provider for state management
- SharedPreferences for local storage
- Automatic data persistence

---

## Next Steps

### To Run on Different Browsers

```bash
flutter run -d firefox   # Firefox
flutter run -d safari    # Safari (macOS only)
flutter run -d edge      # Edge
```

### To Build for Production

```bash
flutter build web --release
# Output in: build/web/
```

### To Integrate Your API

1. Provide your API endpoint details
2. Check `API_INTEGRATION.md` for what info you need to provide
3. I'll integrate it for you!

---

## Troubleshooting

**Issue**: "Package not found"
**Fix**: Run `flutter pub get`

**Issue**: "Port already in use"
**Fix**: Run `flutter run -d chrome --web-port=5000`

**Issue**: "Data not saving"
**Fix**: Check browser console for errors, clear cache

**Issue**: "App won't start"
**Fix**:

```bash
flutter clean
flutter pub get
flutter run -d chrome
```

---

## Features Demo

### Authentication Flow

1. Unregistered? → Click Register → Create account → Auto login
2. Registered? → Login with credentials → Access tasks

### Task Management

- Add tasks instantly
- Edit any task details
- Complete/incomplete toggle
- Delete with confirmation
- Real-time statistics

### Data Persistence

- All data saved locally
- Survives app restart
- Survives browser refresh

---

## Ready for API?

When you have your API ready:

1. Tell me the endpoints
2. Tell me the response format
3. I'll integrate it in 10 minutes!

See `API_INTEGRATION.md` for details on what to provide.

---

**Happy coding! 🚀**
