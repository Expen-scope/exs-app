import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../model/Reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderController extends GetxController {
  var reminders = <ReminderModel>[].obs;
  final String baseUrl = "http://10.0.2.2:8000/api/";
  late String? authToken;
  bool isLoading = false;

  @override
  void onInit() {
    _loadToken();
    fetchReminders();
    super.onInit();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print('Auth Token Loaded: $authToken');
    if (authToken == null) {
      Get.snackbar("Error", "No authentication token found!");
    }
    await fetchReminders();
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
  }

  Future<void> fetchReminders() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}Reminder'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        reminders.assignAll(data.map((e) => ReminderModel.fromJson(e)));
      }
    } catch (e) {
      print('Fetch Error: $e');
      Get.snackbar("Error", "Failed to load reminders");
    }
  }

  Future<bool> addReminder(ReminderModel reminder) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}addReminder'),
        headers: _headers,
        body: json.encode({
          'name': reminder.name,
          'time': DateFormat('yyyy-MM-dd HH:mm:ss').format(reminder.time),
          'price': reminder.price,
          'collectedoprice': reminder.collectedoprice,
        }),
      );

      if (response.statusCode == 201) {
        final newReminder =
            ReminderModel.fromJson(json.decode(response.body)['data']);
        reminders.insert(0, newReminder); // إضافة محلية فورية
        update();
        return true;
      } else {
        print('Error ${response.statusCode}: ${response.body}'); // هنا
        return false;
      }
      return false;
    } catch (e) {
      print('Error adding reminder: $e');
      Get.snackbar("Error", "Failed to add reminder");
      return false;
    }
  }
  Future<bool> deleteReminder(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${baseUrl}deleteReminder/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        await fetchReminders();
        return true;
      } else {
        print('Delete Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Delete Exception: $e');
      Get.snackbar("Error", "Failed to delete reminder");
      return false;
    }
  }


  Future<bool> updateReminder(ReminderModel reminder) async {
    try {
      final response = await http.put(
        Uri.parse('${baseUrl}updateReminder/${reminder.id}'),
        headers: _headers,
        body: json.encode({
          'name': reminder.name,
          'time': DateFormat('yyyy-MM-dd HH:mm:ss').format(reminder.time),
          'price': reminder.price,
          'collectedoprice': reminder.collectedoprice,
        }),
      );

      if (response.statusCode == 200) {
        fetchReminders();
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar("Error", "Failed to update reminder");
      return false;
    }
  }
}
