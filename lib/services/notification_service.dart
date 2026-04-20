import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('ic_notification');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
  }

  static Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showEpisodeNotification({
    required int id,
    required String seriesName,
    required String episodeTitle,
    required String seasonEpisode,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'episode_air_channel',
      'Episode Air Dates',
      channelDescription: 'Notifies when a favorited show airs today',
      importance: Importance.high,
      priority: Priority.high,
      icon: 'ic_notification',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id,
      seriesName,
      '$seasonEpisode — "$episodeTitle" airs today!',
      details,
    );
  }
}
