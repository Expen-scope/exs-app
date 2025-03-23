import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../model/Goal.dart';

class GoalController extends GetxController {
  final RxList<GoalModel> goals = <GoalModel>[].obs;
  final String _apiUrl = "https://abo-najib.test/api/";
  final RxBool isLoading = false.obs;

  String get _token => "YOUR_TOKEN_HERE";

  @override
  void onInit() {
    fetchGoals();
    super.onInit();
  }

  Future<void> fetchGoals() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse("${_apiUrl}goal"),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // تحقق من الهيكل الحقيقي للاستجابة
        final data = responseData['data'] as List;

        goals.assignAll(data.map((e) => GoalModel.fromJson(e)));
      } else {
        Get.snackbar('Error', 'Failed to load goals: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection Error: $e');
      print('Error details: $e');
    } finally {
      isLoading.value = false;
    }
  }
  // Future<void> fetchGoals() async {
  //   isLoading.value = true;
  //   try {
  //     final response = await http.get(
  //       Uri.parse("${_apiUrl}goal"),
  //       headers: {'Authorization': 'Bearer $_token'},
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body)['data'] as List;
  //       goals.assignAll(data.map((e) => GoalModel.fromJson(e)));
  //     } else {
  //       Get.snackbar('Error', 'Failed to load goals: ${response.body}');
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', 'Connection Error: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> addGoal(GoalModel goal) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("${_apiUrl}addgoal"),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': goal.name,
          'time': goal.time.toIso8601String(),
          'price': goal.price,
          'category': goal.category,
          'collectedmoney': goal.collectedmoney,
        }),
      );

      if (response.statusCode == 201) {
        await fetchGoals();
        Get.back();
      } else {
        Get.snackbar('Error', 'Add failed: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Add Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateGoal(int id, GoalModel goal) async {
    isLoading.value = true;
    try {
      final response = await http.put(
        Uri.parse("${_apiUrl}updategoal/$id"),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(goal.toJson()),
      );

      if (response.statusCode == 200) {
        await fetchGoals();
        Get.back();
      } else {
        Get.snackbar('Error', 'Update failed: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Update Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteGoal(int id) async {
    isLoading.value = true;
    try {
      final response = await http.delete(
        Uri.parse("${_apiUrl}deletegoal/$id"),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        await fetchGoals();
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
