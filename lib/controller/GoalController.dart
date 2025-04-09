import 'dart:convert';
import 'dart:ui';
import 'package:googleapis/calendar/v3.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/Goal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalController extends GetxController {
  final RxList<GoalModel> goals = <GoalModel>[].obs;
  final String _apiUrl = "http://10.0.2.2:8000/api/";
  final RxBool isLoading = false.obs;
  late String? authToken;

  @override
  void onInit() {
    _loadToken();
    fetchGoals();
    super.onInit();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    print('Auth Token Loaded: $authToken');
    if (authToken == null) {
      Get.snackbar("Error", "No authentication token found!");
    }
    await fetchGoals();
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
      'Accept': 'application/json',
    };
  }

  Future<void> fetchGoals() async {
    try {
      final response = await http.get(
        Uri.parse('${_apiUrl}goal'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        goals.assignAll(data.map((e) => GoalModel.fromJson(e)));
        goals.refresh();
      }
    } catch (e) {
      print('Fetch Error: $e');
      Get.snackbar("Error", "Failed to load reminders");
    }
  }

  Future<bool> addGoal(GoalModel goal) async {
    try {
      final response = await http.post(
        Uri.parse("${_apiUrl}addgoal"),
        headers: _headers,
        body: jsonEncode({
          'name': goal.name,
          'time': DateFormat('yyyy-MM-dd HH:mm:ss').format(goal.time),
          'price': goal.price,
          'category': goal.category,
          'collectedmoney': goal.collectedmoney,
        }),
      );

      if (response.statusCode == 201) {
        final newReminder =
            GoalModel.fromJson(json.decode(response.body)['data']);
        goals.insert(0, newReminder);
        update();
        return true;
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        return false;
      }
      return false;
    } catch (e) {
      print('Error adding reminder: $e');
      Get.snackbar("Error", "Failed to add reminder");
      return false;
    }
  }

  Future<bool> updateGoal(int id, GoalModel goal) async {
    try {
      final response = await http.put(
        Uri.parse('${_apiUrl}updategoal/$id'),
        headers: _headers,
        body: json.encode({
          'name': goal.name,
          'time': DateFormat('yyyy-MM-dd HH:mm:ss').format(goal.time!),
          'price': goal.price,
          'category': goal.category,
          'collectedmoney': goal.collectedmoney,
        }),
      );

      print('Update Status Code: ${response.statusCode}');
      print('Update Response: ${response.body}');

      if (response.statusCode == 200) {
        await fetchGoals();
        update();
        Get.snackbar(
          "Success",
          "Goal updated successfully",
          backgroundColor: Color(0xff309040),
          colorText: Color(0xFFffffff),
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to update: ${json.decode(response.body)['message']}",
          backgroundColor: Color(0xFFff0000),
          colorText: Color(0xFFffffff),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Connection Error",
        "Check your internet connection",
        backgroundColor: Color(0xFFFFA500),
        colorText: Color(0xFFffffff),
      );
      return false;
    }
  }

  Future<bool> deleteGoal(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${_apiUrl}deletegoal/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        await fetchGoals();
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
}
