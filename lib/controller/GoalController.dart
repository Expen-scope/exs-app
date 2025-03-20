import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/Goal.dart';

class GoalController extends GetxController {
  var goals = <GoalModel>[].obs;
  final String apiUrl = "http://10.0.2.2:8000/api/";
  final String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2Fiby1uYWppYi50ZXN0L2FwaS9hdXRoL2xvZ2luIiwiaWF0IjoxNzQxNzc2MzgzLCJleHAiOjE3NDE3Nzk5ODMsIm5iZiI6MTc0MTc3NjM4MywianRpIjoia1QyQXc3QnY0b016ZVFBdCIsInN1YiI6IjQiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.N8eolIisMFbUcQTLqdQtlEa8GNF2ylH29I69hljgeAU";
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchGoals();
    goals.addAll([
      GoalModel(
          name: "رحلة إلى سويسرا",
          savedAmount: 500,
          totalAmount: 2000,
          type: "سفر",
          id: 1,
          startDate: DateTime.now()),
      GoalModel(
          name: "شراء لابتوب",
          savedAmount: 800,
          totalAmount: 1500,
          type: "إلكترونيات",
          id: 2,
          startDate: DateTime.now()),
      GoalModel(
          name: "دراجة هوائية",
          savedAmount: 300,
          totalAmount: 1000,
          type: "رياضة",
          id: 3,
          startDate: DateTime.now()),
    ]);
    super.onInit();
  }

  // جلب الأهداف
  Future<void> fetchGoals() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse("$apiUrl/goal"));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        goals.value = data.map((e) => GoalModel.fromJson(e)).toList();
      } else {
        Get.snackbar("خطأ", "فشل في جلب الأهداف");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء الاتصال بالسيرفر");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addGoal(GoalModel goal) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse("$apiUrl/addgoal"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": goal.name,
          "time": goal.deadline?.toIso8601String() ?? '',
          "price": goal.totalAmount,
          "category": goal.type,
          "token": token,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchGoals(); // تحديث القائمة بعد الإضافة
      } else {
        // طباعة تفاصيل الخطأ من الخادم
        print('Failed to add goal. Response: ${response.body}');
        Get.snackbar("خطأ", "لم يتم إضافة الهدف: ${response.body}");
      }
    } catch (e) {
      // طباعة الخطأ الكامل في حال حدوث استثناء
      print('Error occurred while adding goal: $e');
      Get.snackbar("خطأ", "حدث خطأ أثناء إضافة الهدف: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // تحديث هدف
  Future<void> updateGoal(int id, GoalModel goal) async {
    try {
      isLoading.value = true;
      final response = await http.put(
        Uri.parse("$apiUrl/updategoal/$id"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(goal.toJson()),
      );

      if (response.statusCode == 200) {
        fetchGoals(); // تحديث القائمة بعد التعديل
      } else {
        Get.snackbar("خطأ", "فشل في تحديث الهدف");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء تحديث الهدف");
    } finally {
      isLoading.value = false;
    }
  }

  // حذف هدف
  Future<void> deleteGoal(int id) async {
    try {
      isLoading.value = true;
      final response = await http.delete(Uri.parse("$apiUrl/deletegoal/$id"));

      if (response.statusCode == 200) {
        fetchGoals(); // تحديث القائمة بعد الحذف
      } else {
        Get.snackbar("خطأ", "فشل في حذف الهدف");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء حذف الهدف");
    } finally {
      isLoading.value = false;
    }
  }
}
