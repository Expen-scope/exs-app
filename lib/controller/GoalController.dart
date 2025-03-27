import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/Goal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalController extends GetxController {
  final RxList<GoalModel> goals = <GoalModel>[].obs;
  final String _apiUrl = "http://10.0.2.2:8000/api/";
  final RxBool isLoading = false.obs;
  late String? _token;

  @override
  void onInit() {
    _loadToken();
    super.onInit();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    print('Auth Token Loaded: $_token');
    if (_token == null) {
      Get.snackbar("Error", "No authentication token found!");
    }
    await fetchGoals();
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };
  }

  Future<void> fetchGoals() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse("${_apiUrl}goal"),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('data')) {
          final data = responseData['data'] as List;
          goals.assignAll(data.map((e) => GoalModel.fromJson(e)));
        }
      } else {
        Get.snackbar('Error', 'Failed to load goals: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection Error: $e');
      print('Error details: $e');
    } finally {
      isLoading.value = false;
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

  // تحديث هدف
  Future<void> updateGoal(int id, GoalModel goal) async {
    isLoading.value = true;
    try {
      final response = await http.put(
        Uri.parse("${_apiUrl}updategoal/$id"),
        headers: _headers,
        body: jsonEncode(goal.toJson()),
      );
      if (response.statusCode == 200) {
        await fetchGoals(); // جلب الأهداف بعد التحديث
        Get.back(); // إغلاق شاشة التحديث
      } else {
        Get.snackbar('Error', 'Update failed: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Update Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // حذف هدف
  Future<void> deleteGoal(int id) async {
    isLoading.value = true;
    try {
      final response = await http.delete(
        Uri.parse("${_apiUrl}deletegoal/$id"),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        await fetchGoals(); // جلب الأهداف بعد الحذف
      } else {
        Get.snackbar('Error', 'Delete failed: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Delete Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
