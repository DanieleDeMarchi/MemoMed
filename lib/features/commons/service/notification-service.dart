import 'dart:math';

import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:memo_med/main.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  final _logger = Logger();
  final Random _random = Random();

  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  /// Pianifica una notifica che verrà visualizzata all'ora specificata.
  ///
  /// Restituisce l'ID della notifica pianificata. Se non è stato possibile
  /// pianificare la notifica, viene restituito null. Se l'utente ha rifiutato
  /// permanentemente i permessi di notifica, viene restituito null.
  ///
  /// Gli argomenti opzionali `id`, `channelName`, `channelId`, `title`, `body` e `payload`
  /// vengono utilizzati per impostare il contenuto della notifica. Se `id` non è specificato,
  /// verrà generato un ID univoco per la notifica.
  ///
  /// L'argomento obbligatorio `notificationTime` specifica l'ora a cui la notifica deve essere visualizzata.

  Future<int?> schedule(
      {int? id,
      String? title,
      String? body,
      String? payload,
      String? channelName,
      String? channelId,
      required DateTime notificationTime}) async {
    if (await Permission.notification.isPermanentlyDenied) {
      return null;
    }

    int notificationId = id ?? generateNotificationId();
    try {
      await notificationsPlugin.zonedSchedule(
          notificationId,
          title,
          body,
          tz.TZDateTime.from(notificationTime, tz.getLocation(notificationTime.timeZoneName)),
          _notificationsDetails(
              channelId ?? 'memomed_default', channelName ?? 'Notifiche preavviso'),
          payload: payload,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);

      return notificationId;
    } catch (e) {
      _logger.e("Error while scheduling notification", e);
    } finally {
      logPendingNotifications();
    }
    return null;
  }

  ///
  /// logPendingNotifications
  ///
  Future<void> logPendingNotifications() async {
    List<PendingNotificationRequest> pending =
        await notificationsPlugin.pendingNotificationRequests();
    _logger.i(pending.map((e) => "${e.id.toString()}: ${e.title}. ${e.body}").toList());
  }

  ///
  /// cancelNotification
  ///
  Future<void> cancelNotification(int id) async {
    List<PendingNotificationRequest> pending =
        await notificationsPlugin.pendingNotificationRequests();
    if (pending.any((element) => element.id == id)) {
      await notificationsPlugin.cancel(id);
    }
    logPendingNotifications();
  }

  ///
  /// askForNotificationPermission
  ///
  Future<PermissionStatus> askForNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    if (status.isDenied) {
      return Permission.notification.request();
    }
    return status;
  }

  ///
  /// getNotificationPermissionStatus
  ///
  Future<PermissionStatus> getNotificationPermissionStatus() async {
    return Permission.notification.status;
  }

  ///
  /// get notification details
  ///
  NotificationDetails _notificationsDetails(String channelId, String channelName) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: Importance.max,
        priority: Priority.high,
        color: Colors.teal,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        categoryIdentifier: channelName,
        threadIdentifier: channelId,
      ),
    );
  }

  int generateNotificationId() {
    final num = _random.nextInt(1 << 31) - 1;
    return num;
  }

  ///
  /// initializationSettings
  ///
  static const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/ic_stat_pills');
  static const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();
  static const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsDarwin);

  ///
  /// initialize plugin
  ///
  void initialize(
      {required Function(NotificationResponse notificationResponse)
          onDidReceiveBackgroundNotificationResponse,
      required Function(NotificationResponse notificationResponse)
          onDidReceiveNotificationResponse}) {
    cron.schedule(Schedule.parse('*/10 * * * * *'), () => logPendingNotifications());

    notificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  /// Gestisce l'apertura dell'app dalla notifica.
  ///
  /// La notifica viene gestita utilizzando la funzione [handleNotification] passata come parametro.
  handleNotificationAppLaunch(
      Function(NotificationResponse notificationResponse) handleNotification) async {
    NotificationAppLaunchDetails? details =
        await notificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      handleNotification(details.notificationResponse!);
    }
  }
}
