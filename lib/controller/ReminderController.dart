import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/Reminder.dart';

class ReminderController extends GetxController {
  var reminders = <ReminderModel>[].obs;
  final String apiUrl = "https://your-laravel-api.com/api/reminders";

  @override
  void onInit() {
    fetchReminders();
    super.onInit();
  }

  Future<void> fetchReminders() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        reminders.value = data.map((e) => ReminderModel.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load reminders");
    }
  }

  Future<void> addReminder(ReminderModel reminder) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(reminder.toJson()),
      );

      if (response.statusCode == 201) {
        fetchReminders(); // تحديث القائمة بعد الإضافة
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل في إضافة التذكير");
    }
  }

  Future<void> deleteReminder(int id) async {
    try {
      final response = await http.delete(Uri.parse("$apiUrl/$id"));
      if (response.statusCode == 200) {
        fetchReminders(); // إعادة تحميل القائمة بعد الحذف
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to delete reminder");
    }
  }

  Future<void> updateReminder(ReminderModel reminder) async {
    try {
      final response = await http.put(
        Uri.parse("$apiUrl/${reminder.id}"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(reminder.toJson()),
      );

      if (response.statusCode == 200) {
        fetchReminders(); // تحديث القائمة بعد التعديل
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update reminder");
    }
  }
}
