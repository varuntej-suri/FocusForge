import 'package:flutter/material.dart';
import 'app.dart';
import 'services/notification_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

// void main() {
//   runApp(const FocusForgeApp());
// }
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Alarm Manager
  await AndroidAlarmManager.initialize();

  // Initialize Notifications
  await NotificationService.initialize();

  // Request Notification Permission
  await NotificationService.requestPermission();

  runApp(const FocusForgeApp());
}