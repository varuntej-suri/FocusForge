# 🚀 FocusForge

FocusForge is a productivity mobile application developed using **Flutter** and **FastAPI** that helps users stay focused, manage study sessions, and track their productivity. The application provides a distraction-free timer, session history, dashboard analytics, user authentication, and motivational notifications.

---

## ✨ Features

- 🔐 User Registration & Login
- 🔑 JWT Authentication
- ⏱️ Custom Focus Timer
- ⏸️ Pause & Resume Session
- ⏭️ Skip Session
- 🎉 Session Completion Screen
- 📊 Dashboard (Focus Time & Sessions)
- 📜 Session History
- 👤 User Profile
- 🔔 Daily Motivation Notifications
- 🌙 Do Not Disturb (DND) Support
- 📱 Responsive Flutter UI

---

## 🛠️ Tech Stack

### Frontend
- Flutter
- Dart

### Backend
- FastAPI
- Python

### Database
- SQLite
- SQLAlchemy ORM

### Authentication
- JWT (JSON Web Token)

### Notifications
- flutter_local_notifications

---

## 📂 Project Structure

```
FocusForge/
│
├── lib/
│   ├── api/
│   ├── models/
│   ├── screens/
│   ├── services/
│   ├── widgets/
│   ├── app.dart
│   └── main.dart
│
├── backend(FastAPI)/
│   ├── main.py
│   ├── crud.py
│   ├── models.py
│   ├── schemas.py
│   ├── security.py
│   ├── database.py
│   └── requirements.txt
│
├── android/
├── ios/
├── pubspec.yaml
└── README.md
```

---

## ⚙️ Installation

### 1. Clone Repository

```bash
git clone https://github.com/varuntej-suri/FocusForge.git
```

---

### 2. Flutter Setup

```bash
flutter pub get
```

---

### 3. Backend Setup

```bash
cd backend(FastAPI)

pip install -r requirements.txt

uvicorn main:app --reload
```

---

### 4. Update API Base URL

Open:

```
lib/api/auth_api.dart
lib/api/session_api.dart
```

Update the base URL to your local IP address.

Example:

```dart
http://192.168.x.x:8000
```

---

### 5. Run Flutter

```bash
flutter run
```

---

## 📱 Application Modules

- Authentication
- Focus Timer
- Dashboard
- Session History
- Profile
- Notifications

---

## 📊 Current Version

**FocusForge v1.0**

### Completed Features

- Authentication
- Focus Timer
- Dashboard
- Session History
- User Profile
- Notifications
- Release APK

---

## 🚀 Future Scope

- 🔥 Daily Streak System
- 📈 Weekly & Monthly Statistics
- 🏆 Achievement Badges
- ⚙️ Settings Page
- 🤖 AI Study Assistant
- 📊 AI Weekly Progress Report
- 🌙 Dark/Light Theme Support

---

## 👨‍💻 Developer

**Varun**

B.Tech 3rd Year Student

---

## 📜 License

This project is developed for educational purposes.