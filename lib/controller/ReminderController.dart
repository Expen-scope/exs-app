import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import '../model/Reminder.dart';

class ReminderController extends GetxController {
  final RxList<ReminderModel> reminders = <ReminderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Timer? _checkTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
    _startPeriodicChecking();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    _notificationsPlugin.initialize(initializationSettings);
  }

  void _startPeriodicChecking() {
    _checkTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      _checkRemindersCompletion();
    });
  }

  void _checkRemindersCompletion() {
    for (var reminder in reminders) {
      if (DateTime.now().isAfter(reminder.time)) {
        _showNotification(
            "You must remember ", "It's time to ${reminder.name} !");
      }
    }
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'goal_channel_id',
      'Goal Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(0, title, body, platformDetails);
  }

  Future<bool> addReminder(ReminderModel reminder) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (reminder.id == null) {
        reminder = ReminderModel(
          id: DateTime.now().millisecondsSinceEpoch,
          name: reminder.name,
          price: reminder.price,
          collectedoprice: reminder.collectedoprice,
          time: reminder.time,
        );
      }

      reminders.add(reminder);
      update();
      return true;
    } catch (e) {
      errorMessage.value = 'Error adding reminder: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteReminder(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      reminders.removeWhere((reminder) => reminder.id == id);
      update();
      return true;
    } catch (e) {
      errorMessage.value = 'Error deleting reminder: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateReminder(ReminderModel reminder) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final index = reminders.indexWhere((r) => r.id == reminder.id);
      if (index != -1) {
        reminders[index] = reminder;
        update();
        return true;
      }
      return false;
    } catch (e) {
      errorMessage.value = 'Error updating reminder: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _checkTimer?.cancel();
    super.onClose();
  }
}
