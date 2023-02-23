// ignore_for_file: file_names, unused_local_variable, unused_import, deprecated_member_use

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsServices {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings('sandolock');

  void initialiseNotifications() async {
    InitializationSettings initializationSettings =
        InitializationSettings(android: _androidInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void secheduleNotification(
    String title,
    String body,
    int hour,
    int minutes,
  ) async {
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    // await _flutterLocalNotificationsPlugin.zonedSchedule(0, title, body,
    //     _nextInstanceOfTenAM(currentTimeZone), notificationDetails,
    //     androidAllowWhileIdle: true,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime,
    //     matchDateTimeComponents: DateTimeComponents.time);

    await _flutterLocalNotificationsPlugin.showDailyAtTime(
        0, title, body, Time(hour, minutes, 0), notificationDetails);
  }

  void stopNotifications() async {
    _flutterLocalNotificationsPlugin.cancel(0);
  }
}

// tz.TZDateTime _nextInstanceOfTenAM(String locations) {
//   final tz.TZDateTime now = tz.TZDateTime.now(tz.getLocation(locations));
//   tz.TZDateTime scheduledDate = tz.TZDateTime(
//       tz.local, now.year, now.month, now.day, 17); //here 10 is for 10:00 AM
//   if (scheduledDate.isBefore(now)) {
//     scheduledDate = scheduledDate.add(const Duration(days: 1));
//   }
//   return scheduledDate;
// }
