import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String timestamp;
  final String iconType; // 'session', 'mood', 'journal', 'premium'
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.iconType,
    this.isRead = false,
  });

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      timestamp: timestamp,
      iconType: iconType,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationController {
  static final ValueNotifier<List<NotificationModel>> notificationsNotifier = ValueNotifier([
    NotificationModel(
      id: '1',
      title: 'Welcome to Aakaa',
      body: 'Your mindfulness journey begins today. Take a deep breath and explore our sanctuaries.',
      timestamp: 'Just now',
      iconType: 'premium',
      isRead: false,
    ),
    NotificationModel(
      id: '2',
      title: 'Daily Check-in Active',
      body: 'Log how you are feeling today to build your emotional resilience streak.',
      timestamp: '2 hours ago',
      iconType: 'mood',
      isRead: true,
    ),
  ]);

  static int get unreadCount => notificationsNotifier.value.where((n) => !n.isRead).length;

  static void addNotification({
    required String title,
    required String body,
    required String iconType,
  }) {
    final now = DateTime.now();
    int hour = now.hour > 12 ? now.hour - 12 : now.hour;
    if (hour == 0) hour = 12;
    String period = now.hour >= 12 ? "PM" : "AM";
    String minute = now.minute.toString().padLeft(2, '0');
    final timeStr = "$hour:$minute $period";

    final newNotif = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      timestamp: timeStr,
      iconType: iconType,
      isRead: false,
    );

    final updated = List<NotificationModel>.from(notificationsNotifier.value);
    updated.insert(0, newNotif);
    notificationsNotifier.value = updated;
  }

  static void markAsRead(String id) {
    final updated = notificationsNotifier.value.map((n) {
      if (n.id == id) return n.copyWith(isRead: true);
      return n;
    }).toList();
    notificationsNotifier.value = updated;
  }

  static void markAllAsRead() {
    final updated = notificationsNotifier.value.map((n) => n.copyWith(isRead: true)).toList();
    notificationsNotifier.value = updated;
  }

  static void removeNotification(String id) {
    final updated = notificationsNotifier.value.where((n) => n.id != id).toList();
    notificationsNotifier.value = updated;
  }

  static void clearAll() {
    notificationsNotifier.value = [];
  }
}
