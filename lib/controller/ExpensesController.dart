import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/Expenses.dart';
import 'package:flutter/material.dart';

class ExpencesController extends GetxController {
  var listExpenses = <Expense>[].obs;

  final Map<String, ExpenseInfo> expenseData = {
    "Food & Drinks": ExpenseInfo(
        color: Colors.blue, icon: Icon(Icons.fastfood, color: Colors.blue)),
    "Shopping": ExpenseInfo(
        color: Colors.purple,
        icon: Icon(Icons.shopping_cart, color: Colors.purple)),
    "Housing": ExpenseInfo(
        color: Colors.orange, icon: Icon(Icons.home, color: Colors.orange)),
    "Transportation": ExpenseInfo(
        color: Colors.green,
        icon: Icon(Icons.directions_bus, color: Colors.green)),
    "Vehicle": ExpenseInfo(
        color: Colors.red, icon: Icon(Icons.directions_car, color: Colors.red)),
    "Others": ExpenseInfo(
        color: Colors.grey, icon: Icon(Icons.category, color: Colors.grey)),
  };

  void _addFakeExpenses() {
    listExpenses.value = [
      Expense(type: "Food & Drinks", value: 50.0, date: ''),
      Expense(type: "Shopping", value: 120.0, date: ''),
      Expense(type: "Housing", value: 300.0, date: ''),
      Expense(type: "Transportation", value: 45.0, date: ''),
      Expense(type: "Vehicle", value: 70.0, date: ''),
      Expense(type: "Others", value: 20.0, date: ''),
    ];
  }

  // جلب المصروفات من API لارافيل
  Future<void> fetchExpenses() async {
    // try {
    //   final response = await http
    //       .get(Uri.parse('https://your-laravel-api.com/api/expenses'));
    //
    //   if (response.statusCode == 200) {
    //     var data = json.decode(response.body);
    //     listExpenses.value = List<Expense>.from(
    //         data.map((expense) => Expense.fromJson(expense)));
    //   } else {
    //     Get.snackbar('Error', 'Failed to load expenses');
    //   }
    // } catch (e) {
    //   Get.snackbar('Error', 'Failed to load expenses');
    // }
    if (kDebugMode) {
      listExpenses.value = [
        Expense(type: "Food & Drinks", value: 50.0, date: ''),
        Expense(type: "Shopping", value: 120.0, date: ''),
        Expense(type: "Housing", value: 300.0, date: ''),
      ];
      return;
    }

    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        listExpenses.value = List<Expense>.from(
            data.map((expense) => Expense.fromJson(expense)));
      } else {
        Get.snackbar('Error', 'Failed to load expenses');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load expenses');
    }
  }

  // إضافة مصروف جديد عبر API لارافيل
  Future<void> addExpense(Expense expense) async {
    try {
      final response = await http.post(
        Uri.parse('https://your-laravel-api.com/api/expenses'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(expense.toJson()),
      );

      if (response.statusCode == 201) {
        fetchExpenses(); // إعادة جلب المصروفات بعد الإضافة
      } else {
        Get.snackbar('Error', 'Failed to add expense');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add expense');
    }
  }

  // إزالة مصروف
  Future<void> removeExpense(int index) async {
    // try {
    //   final response = await http.delete(
    //     // Uri.parse('https://your-laravel-api.com/api/expenses/${listExpenses[index].id}'),
    //   // );
    //
    //   if (response.statusCode == 200) {
    //     fetchExpenses();  // إعادة جلب المصروفات بعد الحذف
    //   } else {
    //     Get.snackbar('Error', 'Failed to remove expense');
    //   }
    // } catch (e) {
    //   Get.snackbar('Error', 'Failed to remove expense');
    // }
  }
}

class ExpenseInfo {
  final Color color;
  final Icon icon;

  ExpenseInfo({required this.color, required this.icon});
}
