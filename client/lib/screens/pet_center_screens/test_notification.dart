import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('dog_banner');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        // Xử lý khi thông báo được nhấp vào
        // print('Thông báo được chọn với payload: $payload');
      },
    );
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      "Pet's Channel Response",
      'Channel for notifications about successful pet posts in our loving community',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('success'),
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'SUCCESSFUL ADDITION',
      'Great news! Your pet has been successfully added to our platform. Thank you for contributing to our pet-loving community.',
      platformChannelSpecifics,
      payload: 'custom_payload',
    );
  }
}
