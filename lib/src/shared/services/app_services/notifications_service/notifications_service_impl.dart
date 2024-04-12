import 'dart:io';

import 'package:bookify/src/shared/services/app_services/notifications_service/custom_notification.dart';
import 'package:bookify/src/shared/services/app_services/notifications_service/notification_navigator.dart';
import 'package:bookify/src/shared/services/app_services/notifications_service/notifications_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationsServiceImpl implements NotificationsService {
  late final FlutterLocalNotificationsPlugin _notifications;

  NotificationsServiceImpl() {
    _notifications = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  Future<void> _setupNotifications() async {
    await _setupNotificationPermission();
    await _setupTimezone();
    await _initializeNotifications();
  }

  Future<void> _setupNotificationPermission() async {
    if (Platform.isAndroid) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();

      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestExactAlarmsPermission();
    }
  }

  Future<void> _setupTimezone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation('America/Sao_Paulo'),
    );
  }

  Future<void> _initializeNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final iosSettings = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, _, __, payload) =>
          _navigateToNotificationPage(payload, id),
    );

    final initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onTapOnNotification,
    );
    tz.initializeTimeZones();
  }

  void _onTapOnNotification(
    NotificationResponse notificationResponse,
  ) {
    if (notificationResponse.notificationResponseType ==
        NotificationResponseType.selectedNotification) {
      final NotificationResponse(:id, :payload) = notificationResponse;
      _navigateToNotificationPage(payload, id);
    }
  }

  void _navigateToNotificationPage(String? payload, int? id) {
    if (payload != null && payload.isNotEmpty) {
      NotificationNavigator.navigateTo(
        payload,
        id,
      );
    }
  }

  NotificationDetails _getNotificationDetails(
      NotificationChannel channel, String bigText) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        icon: '@drawable/ic_stat_ic_notification',
        channel.channelId(),
        channel.toString(),
        channelDescription: channel.description(),
        styleInformation: BigTextStyleInformation(
          bigText,
        ),
        importance: Importance.high,
      ),
      iOS: DarwinNotificationDetails(
        categoryIdentifier: channel.toString(),
      ),
    );
  }

  @override
  Future<void> scheduleNotification(
    CustomNotification notification,
  ) async {
    await _notifications.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      tz.TZDateTime.from(
        notification.scheduledDate,
        tz.local,
      ),
      _getNotificationDetails(
        notification.notificationChannel,
        notification.body,
      ),
      payload: notification.payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> periodicallyShowNotification({
    required int id,
    required String title,
    required String body,
    required NotificationChannel notificationChannel,
  }) async {
    await _notifications.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.daily,
      _getNotificationDetails(
        notificationChannel,
        body,
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancelNotificationById({required int id}) async {
    await _notifications.cancel(id);
  }

  @override
  Future<void> checkForNotifications() async {
    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      if (details.notificationResponse != null) {
        _onTapOnNotification(details.notificationResponse!);
      }
    }
  }
}