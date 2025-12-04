import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agendafaciljp/models/notification.dart';

class NotificationService {
  static const String _storageKey = 'notifications';

  Future<List<AppNotification>> getAllNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_storageKey);

      if (data == null) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(data);
      return jsonList.map((json) => AppNotification.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      return [];
    }
  }

  Future<List<AppNotification>> getNotificationsByUser(String userId) async {
    final notifications = await getAllNotifications();
    return notifications.where((n) => n.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<int> getUnreadCount(String userId) async {
    final notifications = await getNotificationsByUser(userId);
    return notifications.where((n) => !n.isRead).length;
  }

  Future<void> addNotification(AppNotification notification) async {
    try {
      final notifications = await getAllNotifications();
      notifications.add(notification);
      await _saveNotifications(notifications);
    } catch (e) {
      debugPrint('Error adding notification: $e');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final notifications = await getAllNotifications();
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);
        await _saveNotifications(notifications);
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  Future<void> markAllAsRead(String userId) async {
    try {
      final notifications = await getAllNotifications();
      final updated = notifications.map((n) {
        if (n.userId == userId && !n.isRead) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();
      await _saveNotifications(updated);
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      final notifications = await getAllNotifications();
      notifications.removeWhere((n) => n.id == id);
      await _saveNotifications(notifications);
    } catch (e) {
      debugPrint('Error deleting notification: $e');
    }
  }

  Future<void> _saveNotifications(List<AppNotification> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = notifications.map((n) => n.toJson()).toList();
    await prefs.setString(_storageKey, json.encode(jsonList));
  }
}
