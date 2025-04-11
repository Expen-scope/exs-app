import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/Expenses.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpencesController extends GetxController {
  var listExpenses = <Expense>[].obs;
  final String baseUrl = "http://10.0.2.2:8000/api/";
  late String? authToken;

  final List<String> categories = [
    "Food & Drinks",
    "Shopping",
    "Housing",
    "Transportation",
    "Vehicle",
    "Others"
  ];

  final Map<String, ExpenseInfo> expenseData = {
    "Food & Drinks": ExpenseInfo(
        color: Color(0xffaa52ea),
        icon: Icon(
          Icons.fastfood,
          color: Color(0xffaa52ea),
        )),
    "Shopping": ExpenseInfo(
        color: Color(0xff75c79f),
        icon: Icon(
          Icons.shopping_cart,
          color: Color(0xff75c79f),
        )),
    "Housing": ExpenseInfo(
        color: Color(0xfffb4b41),
        icon: Icon(
          Icons.home,
          color: Color(0xfffb4b41),
        )),
    "Transportation": ExpenseInfo(
        color: Color(0xff4c62f0),
        icon: Icon(
          Icons.directions_bus,
          color: Color(0xff4c62f0),
        )),
    "Vehicle": ExpenseInfo(
        color: Color(0xffbcbf7d),
        icon: Icon(
          Icons.directions_car,
          color: Color(0xffbcbf7d),
        )),
    "Others": ExpenseInfo(
        color: Color(0xff61bbdb),
        icon: Icon(
          Icons.category,
          color: Color(0xff61bbdb),
        )),
  };

  @override
  void onInit() {
    super.onInit();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    if (authToken == null) {
      Get.offAllNamed('/Login');
      return;
    }
    await fetchExpenses();
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
  }

  Future<void> fetchExpenses() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}Expense'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'] as List;
        listExpenses.value = data.map((e) => Expense.fromJson(e)).toList();
        listExpenses.refresh();
      } else {
        Get.snackbar('Error', 'Failed to load expenses');
      }
    } catch (e) {
      print('Error details: $e');
      Get.snackbar('Error', 'Failed to load expenses');
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}addExpense'),
        headers: _headers,
        body: json.encode({
          'price': expense.value.toString(),
          'category': expense.type,
          'name_of_expense': expense.name,
          'time': expense.date,
        }),
      );

      if (response.statusCode == 201) {
        await fetchExpenses();
        print('Updated list: ${listExpenses.length} items');
      } else {
        Get.snackbar('Error', 'Failed to add expense');
      }
    } catch (e, stackTrace) {
      print('Error details: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar('Error', 'Failed to add expense');
    }
  }

  Future<void> removeExpense(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${baseUrl}deleteExpense/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        await fetchExpenses();
      } else {
        Get.snackbar('Error', 'Failed to remove expense');
      }
    } catch (e) {
      print('Error details: $e'); // أضف هذا السطر
      Get.snackbar('Error', 'Failed to load expenses');
    }
  }
}

class ExpenseInfo {
  final Color color;
  final Icon icon;

  ExpenseInfo({required this.color, required this.icon});
}
