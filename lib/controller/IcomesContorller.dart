import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/Incomes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomesController extends GetxController {
  var incomes = <Income>[].obs;
  var selectedCategory = 'salary'.obs;
  final String baseUrl = "http://10.0.2.2:8000/api/";
  late String? authToken;

  final Map<String, IncomeInfo> incomeCategoriesData = {
    "Salary": IncomeInfo(
        color: Color(0xff2196F3FF),
        icon: Icon(Icons.work, color: Color(0xff2196F3FF))),
    "Bonus": IncomeInfo(
        color: Color(0xff4CAF50FF),
        icon: Icon(Icons.card_giftcard, color: Color(0xff4CAF50FF))),
    "Investment": IncomeInfo(
        color: Color(0xffFF9800FF),
        icon: Icon(Icons.trending_up, color: Color(0xffFF9800FF))),
    "Freelance": IncomeInfo(
        color: Color(0xff9C27B0FF),
        icon: Icon(Icons.computer, color: Color(0xff9C27B0FF))),
    "Other": IncomeInfo(
        color: Color(0xff9E9E9EFF),
        icon: Icon(Icons.category, color: Color(0xff9E9E9EFF))),
  };

  List<String> get incomeCategories =>
      incomeCategoriesData.keys.toList();

  @override
  void onInit() {
    super.onInit();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    await fetchIncomes();
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
  }

  Future<void> fetchIncomes() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}Income'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'] as List;
        incomes.value = data.map((e) => Income.fromJson(e)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load incomes: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load incomes: $e');
    }
  }

// مثال لتحسين دالة addIncome في الـController
  Future<void> addIncome(Income income) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}addIncome'),
        headers: _headers,
        body: json.encode({
          'nameinc': income.name,
          'price': income.price,
          'category': income.category,
          'time': income.time,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        // Option 1: Add manually + refresh
        final newIncome = Income.fromJson(responseData['data']);
        incomes.add(newIncome);
        incomes.refresh();

        // Option 2: Reload from server
        await fetchIncomes();

        Get.snackbar('Success', 'Income added successfully');
      } else {
        Get.snackbar('Error', responseData['message'] ?? 'Failed to add income');
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection failed: $e');
    }
  }
  Future<void> deleteIncome(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${baseUrl}deleteIncome/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        incomes.removeWhere((income) => income.id == id);
        update();
      } else {
        Get.snackbar('Error', 'Failed to delete income');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete income');
    }
  }
}

class IncomeInfo {
  final Color color;
  final Icon icon;

  IncomeInfo({required this.color, required this.icon});
}
