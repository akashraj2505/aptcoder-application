# Admin Student Management Module

This project implements an Admin Student Management feature using Flutter and BLoC architecture.  
The module allows admins to manage students and assign courses efficiently.

---

## 🚀 Features

- Create new students
- Assign multiple courses to students
- View all students
- Edit student details and courses
- Delete students
- State management using BLoC
- Firebase-based backend integration

---

## 🧩 Architecture

The project follows **Clean Architecture principles**:

- **UI Layer**: Flutter Widgets
- **State Management**: BLoC
- **Service Layer**: AuthService & UserService
- **Backend**: Firebase Auth & Firestore

---

## 🛠 Tech Stack

- Flutter
- Dart
- flutter_bloc
- Firebase Authentication
- Cloud Firestore

---

## 📂 Folder Structure

lib/
│
├── bloc/
│   ├── admin_student/
│   ├── course/
│
├── screens/
│   ├── admin_create_student_screen.dart
│   ├── admin_student_list_screen.dart
│
├── services/
│   ├── auth_service.dart
│   ├── user_service.dart
│
├── widgets/
│   ├── app_snackbar.dart
│
└── main.dart

---

## 🧪 State Handling

The application uses the following states:

- Initial
- Loading
- Loaded
- Success
- Error

This ensures proper UI updates and user feedback.

---

## ▶️ How to Run

1. Clone the repository  
2. Run `flutter pub get`  
3. Configure Firebase for Android/iOS  
4. Run the app using `flutter run`

---

## 📌 Notes

- Only admins can access student management features
- Course data is fetched dynamically
- Error handling is implemented for all async operations

---

## 🙌 Author

Developed by **Akash Raj**  
Flutter Developer | BLoC | Firebase

