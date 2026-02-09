import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    final payload = response.payload;
    if (payload != null) {
      // Navigate to specific screen based on payload
      // This will be handled by NotificationProvider
    }
  }

  // Show simple notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'lumo_ai_channel',
      'Lumo AI Notifications',
      channelDescription: 'Notifications for Lumo AI app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Show notification with custom sound
  Future<void> showNotificationWithSound({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'lumo_ai_channel',
      'Lumo AI Notifications',
      channelDescription: 'Notifications for Lumo AI app',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'notification_sound.aiff',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Show big picture notification (for images)
  Future<void> showBigPictureNotification({
    required int id,
    required String title,
    required String body,
    required String imagePath,
    String? payload,
  }) async {
    final bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(imagePath),
      largeIcon: FilePathAndroidBitmap(imagePath),
      contentTitle: title,
      summaryText: body,
    );

    final androidDetails = AndroidNotificationDetails(
      'lumo_ai_channel',
      'Lumo AI Notifications',
      channelDescription: 'Notifications for Lumo AI app',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Schedule notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'lumo_ai_channel',
      'Lumo AI Notifications',
      channelDescription: 'Notifications for Lumo AI app',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _convertToTZDateTime(scheduledTime),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  // Cancel notification
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  // Request permissions (iOS)
  Future<bool> requestPermissions() async {
    final result = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    return result ?? false;
  }

  // Helper method to convert DateTime to TZDateTime
  TZDateTime _convertToTZDateTime(DateTime dateTime) {
    // This is a simplified version - in production, use timezone package
    return TZDateTime.from(dateTime, getLocation('UTC'));
  }

  // Predefined notification types
  Future<void> showNewMessageNotification({
    required String senderName,
    required String message,
    required String chatRoomId,
  }) async {
    await showNotification(
      id: chatRoomId.hashCode,
      title: 'رسالة جديدة من $senderName',
      body: message,
      payload: 'chat:$chatRoomId',
    );
  }

  Future<void> showNewPostLikeNotification({
    required String userName,
    required String postId,
  }) async {
    await showNotification(
      id: postId.hashCode,
      title: 'إعجاب جديد',
      body: 'أعجب $userName بمنشورك',
      payload: 'post:$postId',
    );
  }

  Future<void> showNewCommentNotification({
    required String userName,
    required String comment,
    required String postId,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'تعليق جديد من $userName',
      body: comment,
      payload: 'post:$postId',
    );
  }

  Future<void> showNewFollowerNotification({
    required String userName,
    required String userId,
  }) async {
    await showNotification(
      id: userId.hashCode,
      title: 'متابع جديد',
      body: 'بدأ $userName بمتابعتك',
      payload: 'profile:$userId',
    );
  }

  Future<void> showDoctorConnectionRequestNotification({
    required String doctorName,
    required String requestId,
  }) async {
    await showNotification(
      id: requestId.hashCode,
      title: 'طلب اتصال من طبيب',
      body: 'الدكتور $doctorName يريد الاتصال بك',
      payload: 'connection_request:$requestId',
    );
  }

  Future<void> showNewAnalysisNotification({
    required String doctorName,
    required String analysisId,
  }) async {
    await showNotification(
      id: analysisId.hashCode,
      title: 'تحليل جديد',
      body: 'قام الدكتور $doctorName بإضافة تحليل جديد',
      payload: 'analysis:$analysisId',
    );
  }
}

// Timezone helper class (simplified)
class TZDateTime {
  final DateTime dateTime;
  final Location location;

  TZDateTime(this.dateTime, this.location);

  static TZDateTime from(DateTime dateTime, Location location) {
    return TZDateTime(dateTime, location);
  }
}

class Location {
  final String name;
  Location(this.name);
}

Location getLocation(String name) {
  return Location(name);
}