import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzl;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static final _localNotificationPlugin = FlutterLocalNotificationsPlugin();

  static bool notificationsEnabled = false;

  static Future<void> requestPermission() async {
    /// Birinchi dasturimiz qaysi qurilmada run bo'layotganini tekshiramiz
    if (Platform.isIOS || Platform.isMacOS) {
      /// Agar IOS bo'lsa unda
      /// shu kod orqali notification'ga ruxsat so'raymiz
      notificationsEnabled = await _localNotificationPlugin
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;

      /// Agar MacOS bo'lsa unda
      /// bu kod orqali notification'ga ruxsat so'raymiz
      await _localNotificationPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      /// Agar Android qurilma bo'lsa unda
      /// bu kod orqali android notification sozlamasini olamiz
      final androidImplementation =
          _localNotificationPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      /// va bu yerda darhol xabarnomasiga ruxsat so'raymiz
      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();

      /// bu yerda esa rejali xabarnomaga ruxsat so'raymiz
      final bool? grantedScheduledNotificationPermission =
          await androidImplementation?.requestExactAlarmsPermission();

      /// bu yerda o'zgaruvchiga belgilab qo'yapmiz foydalanuvchi ruxsat berdimi yoki yo'q
      notificationsEnabled = grantedNotificationPermission ?? false;
      notificationsEnabled = grantedScheduledNotificationPermission ?? false;
    }
  }

  static Future<void> start() async {
    /// hozirgi joylashuv (timezone) bilan vaqtni olamiz
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tzl.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    // android va IOS uchun sozlamalarni to'g'irlaymiz
    const androidInit = AndroidInitializationSettings("mipmap/ic_launcher");
    final iosInit = DarwinInitializationSettings(notificationCategories: [
      DarwinNotificationCategory(
        'iosCategory',
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            'id_3',
            'Action 3',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      ),
    ]);

    // umumiy sozlamalarga e'lon qilamiz
    final notificationInit = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotificationPlugin.initialize(notificationInit);
  }

  static void showNotification() async {
    // android va ios uchun qanday
    // turdagi xabarlarni ko'rsatish kerakligni aytamiz
    const androidDetails = AndroidNotificationDetails(
      "goodChannelId",
      "goodChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      //sound: RawResourceAndroidNotificationSound("notification"),
      // actions: [
      //   AndroidNotificationAction('id_1', 'Action 1'),
      //   AndroidNotificationAction('id_2', 'Action 2'),
      //   AndroidNotificationAction('id_3', 'Action 3'),
      // ],
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
      categoryIdentifier: "demoCategory",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // show funksiyasi orqali darhol xabarnoma ko'rsatamiz
    await _localNotificationPlugin.show(
      0,
      "Birinchi NOTIFICATION",
      "Salom sizga \$1,000,000 pul tushdi. SMS kodni ayting!",
      notificationDetails,
    );
  }

  /// Scheduled Notification --------------------------------------------------------------
  static void showTodoNotification({
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    // android va ios uchun qanday
    // turdagi xabarlarni ko'rsatish kerakligni aytamiz
    const androidDetails = AndroidNotificationDetails(
      "todoChannelId",
      "todoChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      //sound: RawResourceAndroidNotificationSound("notification"),
      ticker: "Ticker",
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // show funksiyasi orqali darhol xabarnoma ko'rsatamiz
    await _localNotificationPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.local(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
      ),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
