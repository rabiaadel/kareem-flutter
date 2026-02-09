import 'package:flutter/material.dart';

import '../../core/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService;

  NotificationProvider(this._notificationService);

  bool _notificationsEnabled = true;
  int _unreadCount = 0;

  bool get notificationsEnabled => _notificationsEnabled;
  int get unreadCount => _unreadCount;

  // Initialize notifications
  Future<void> init() async {
    await _notificationService.initialize();
    await _notificationService.requestPermissions();
  }

  // Toggle notifications
  void toggleNotifications(bool enabled) {
    _notificationsEnabled = enabled;
    notifyListeners();
  }

  // Update unread count
  void updateUnreadCount(int count) {
    _unreadCount = count;
    notifyListeners();
  }

  // Increment unread count
  void incrementUnreadCount() {
    _unreadCount++;
    notifyListeners();
  }

  // Clear unread count
  void clearUnreadCount() {
    _unreadCount = 0;
    notifyListeners();
  }

  // Show notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_notificationsEnabled) return;

    await _notificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      body: body,
      payload: payload,
    );
  }
}