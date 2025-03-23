import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as Dio;
import '../model/Incomes.dart';

class IncomesController extends GetxController {
  var incomes = <Income>[].obs;
  var isLoading = false.obs;
  final Dio.Dio dio = Dio.Dio();
  final String apiUrl = 'http://10.0.2.2:8000/api';

  RxString selectedCategory = ''.obs;
  final incomeCategories = ['salary', 'bonus', 'investment'].obs;
  final incomeCategoriesData = {
    'salary': IncomeInfo(color: Colors.blue, icon: Icon(Icons.work)),
    'bonus': IncomeInfo(color: Colors.green, icon: Icon(Icons.code)),
    'investment':
        IncomeInfo(color: Colors.orange, icon: Icon(Icons.trending_up)),
  }.obs;

  @override
  void onInit() {
    selectedCategory.value = incomeCategories.first;
    fetchIncomes();
    super.onInit();
  }

  Future<void> fetchIncomes() async {
    try {
      isLoading.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      if (token == null) {
        Get.snackbar('Error', 'No token found');
        return;
      }

      Dio.Response response = await dio.get(
        '$apiUrl/incomes',
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        incomes.value = (response.data['data'] as List)
            .map((json) => Income.fromJson(json))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error fetching incomes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addIncome(
      double price,
      String category,
      String nameOfExpense,
      DateTime time,
      ) async {
    print("addIncome called!"); // تأكيد استدعاء الدالة
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      String? userId = prefs.getString('user_id');
      if (token == null || userId == null) {
        Get.snackbar('Error', 'Authentication required');
        print("No token or userId found!");
        return false;
      }

      Income newIncome = Income(
        id: 'temp_id',
        price: price,
        category: category,
        nameOfIncome: nameOfExpense,
        time: time,
        userId: userId,
      );

      Dio.Response response = await dio.post(
        '$apiUrl/incomes',
        data: newIncome.toJson(),
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 201) {
        incomes.add(Income.fromJson(response.data));
        Get.snackbar('Success', 'Income added');
        print("Income added successfully!");
        return true;
      } else {
        Get.snackbar('Error', 'Failed to add income');
        print("Failed to add income: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Error adding income: $e');
      print("Error: $e");
      return false;
    }
  }



  Future<void> deleteIncome(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        Get.snackbar('Error', 'Authentication required');
        return;
      }

      Dio.Response response = await dio.delete(
        '$apiUrl/incomes/$id',
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        incomes.removeWhere((income) => income.id == id);
        Get.snackbar('Success', 'Income deleted');
      } else {
        Get.snackbar('Error', 'Failed to delete income');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error deleting income: $e');
    }
  }
}

class IncomeInfo {
  final Color color;
  final Icon icon;
  IncomeInfo({required this.color, required this.icon});
}
