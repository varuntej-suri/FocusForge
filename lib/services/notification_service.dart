import 'dart:math';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const List<String> morningMessages = [
  "🌅 Wake up! Your future starts today.",
  "🚀 One focused session today changes tomorrow.",
  "💻 Future Data Scientist, it's time to study.",
  "📚 Small progress every day creates big success.",
  "🔥 Discipline beats motivation. Let's begin.",
];

const List<String> eveningMessages = [
  "🎯 Stop scrolling. Start learning.",
  "📈 Your dream career needs today's effort.",
  "🤖 Learn one new AI concept today.",
  "🐍 Open Python and build your future.",
  "💪 One more session before bed!",
];
const List<String> goodNightMessages = [
  "😴 Sleep well. Tomorrow is another chance to achieve your goals.",
  "🌙 Recharge today, conquer tomorrow.",
  "💙 Rest well, Future Data Scientist.",
  "⭐ Great work today! Sweet dreams.",
  "🚀 Dream big. Tomorrow you'll be even better.",
];

String randomMotivation() {
  final random = Random();

  final allMessages = [
    ...morningMessages,
    ...eveningMessages,
  ];

  return allMessages[random.nextInt(allMessages.length)];
}
String randomGoodNightMessage() {
  final random = Random();

  return goodNightMessages[
      random.nextInt(goodNightMessages.length)];
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> requestPermission() async {
    final status = await Permission.notification.status;

    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  static Future<void> initialize() async {

    tz.initializeTimeZones();

    final String currentTimeZone =
        await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(
      tz.getLocation(currentTimeZone),
    );

    const android =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: android,
    );

    await notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        
      },
    );
  }
    static Future<void> scheduleDailyNotification({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await notifications.zonedSchedule(
      id,
      title,
      body,
      _nextInstance(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'focus_channel',
          'Focus Reminders',
          channelDescription: 'Daily focus reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode:
          AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents:
          DateTimeComponents.time,
    );
   
  }

  static tz.TZDateTime _nextInstance(
      int hour,
      int minute,
      ) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled =
          scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  static Future<void> scheduleAllNotifications() async {
    
    await notifications.cancelAll();
    await scheduleDailyNotification(
      id: 1,
      hour: 6,
      minute: 0,
      title: "🌅 Good Morning",
      body: randomMotivation(),
    );

    await scheduleDailyNotification(
      id: 2,
      hour: 9,
      minute: 0,
      title: "🎯 Time to Focus",
      body: randomMotivation(),
    );

    await scheduleDailyNotification(
      id: 3,
      hour: 18,
      minute: 0,
      title: "💻 Evening Focus",
      body: randomMotivation(),
    );

    await scheduleDailyNotification(
      id: 4,
      hour: 21,
      minute: 0,
      title: "🌙 Finish Strong",
      body: randomMotivation(),
    );
    await scheduleDailyNotification(
  id: 5,
  hour: 23,
  minute: 53,
  title: "😴 Good Night",
  body: randomGoodNightMessage(),
);

  }
    static Future<void> showTestNotification() async {
    await notifications.show(
      100,
      "🎉 FocusForge Test",
      "Notifications are working successfully!",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'focus_channel',
          'Focus Reminders',
          channelDescription:
              'FocusForge notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  static Future<void> showSessionCompletedNotification(
      int duration) async {
    

    await notifications.show(
      101,
      "🎉 Session Completed",
      "Excellent! You completed your $duration-minute focus session.",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'focus_channel',
          'Focus Notifications',
          channelDescription:
              'Focus session notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  static Future<void> showBreakReminder() async {
    await notifications.show(
      102,
      "☕ Break Time",
      "Take a 10-minute break. Drink water and stretch.",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'focus_channel',
          'Focus Notifications',
          channelDescription:
              'Break reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}