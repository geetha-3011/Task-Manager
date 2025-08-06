# Task Manager

*A cross-platform task management app with Google login, offline support, and full CRUD features built using Flutter for the Katomaran Mobile App Hackathon.*

---

## 📱 Features

- ✅ Google social login integration
- ✅ Error handling on login failure
- ✅ Full task CRUD support: Create, Read, Update, Complete, Delete
- ✅ Fields: title, description, due date, status (open/complete)
- ✅ Clean and responsive UI with animations
- ✅ In-app local state management
- ✅ Floating Action Button for quick task creation
- ✅ Task search, filter, and sort options
- ✅ "No tasks" empty state UI
- ✅ Swipe-to-delete and pull-to-refresh functionality
- ✅ Crash reporting integrated via Firebase Crashlytics

---

## 🛠 Tech Stack

- *Framework:* Flutter
- *Auth Provider:* Google (via Firebase Auth)
- *Database:* Firebase Firestore (cloud-based)
- *Crash Reporting:* Firebase Crashlytics
- *State Management:* setState (or Provider if applicable)
- *Animations:* Flutter Animated Widgets

---

## 🚀 Getting Started

### 1. Prerequisites

- Flutter SDK
- Dart SDK
- Firebase Project Setup (with Google Sign-In enabled)

### 2. Clone the Repository

bash
git clone https://github.com/yourusername/task_manager.git
cd task_manager


### 3. Install Dependencies

bash
flutter pub get


### 4. Run the App

bash
flutter run


> 📦 To generate the APK:
bash
flutter build apk --release


---

## 📂 Folder Structure

bash
lib/
 ┣ Model/
 ┣ View/
 ┣ Controller/
 ┗ main.dart


---

## 🧠 Assumptions

- Only *Google login* is implemented for simplicity, even though others were allowed.
- All tasks are stored on Firebase and also temporarily cached in session/local state.
- Firebase is assumed to be pre-configured before running the app.

---

## 📸 Screenshots

_Add your screenshots here or in the [/screenshots folder_](https://github.com/geetha-3011/Task-Manager/tree/main/Screenshots)

---

## 🎥 Demo Video

[👉 Click here to view the demo on Loom](https://loom.com/your-video-link)

---

## 🧭 Architecture Diagram




---

## 📦 APK File

You can download the working APK from the [`/apk`](https://github.com/geetha-3011/Task-Manager/tree/main/apk) folder, or [click here to download the latest release APK](https://github.com/geetha-3011/Task-Manager/releases/download/v1.0.1/app-release.apk).

Alternatively, you can generate it yourself using the following command:

```bash
flutter build apk --release

## 🏁 Final Note

This project is a part of a hackathon run by [https://www.katomaran.com](https://www.katomaran.com)

---
