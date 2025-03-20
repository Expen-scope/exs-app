import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/Incomes.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:get/get_connect/http/src/response/response.dart' as getResponse;

class IncomesController extends GetxController {
  var incomes = <Income>[].obs;
  var isLoading = false.obs;
  var selectedType = "Salaries and Wages".obs;
  final Dio.Dio dio = Dio.Dio();
  final String apiUrl = 'http://10.0.2.2:8000/api/';

  void addFakeData() {
    incomes.addAll([
      Income(value: 1500, type: "Salary"),
      Income(value: 500, type: "Freelance"),
      Income(value: 300, type: "Investment"),
      Income(value: 700, type: "Business"),
      Income(value: 100, type: "Others"),
      Income(value: 1500, type: "Freelance"),
      Income(value: 1721.75, type: "Investment"),
    ]);
  }

  final Map<String, IncomeInfo> incomeListDATA = {
    "Salary":
        IncomeInfo(color: Colors.green, icon: Icon(Icons.monetization_on)),
    "Freelance": IncomeInfo(color: Colors.blue, icon: Icon(Icons.work)),
    "Investment":
        IncomeInfo(color: Colors.orange, icon: Icon(Icons.trending_up)),
  };
  var incomeTypes =
      ["Salary", "Freelance", "Business", "Investments", "Others"].obs;

  var selectedIncomeType = "Salary".obs;

  @override
  void onInit() {
    fetchIncomes();
    super.onInit();
    addFakeData();
  }

  Future<void> fetchIncomes() async {
    try {
      isLoading.value = true;
      Dio.Response response = await dio.get(apiUrl);
      if (response.statusCode == 200) {
        incomes.value = (response.data as List)
            .map((json) => Income.fromJson(json))
            .toList();
      } else {}
    } catch (e) {
      print('Error fetching incomes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addIncome(double value, String type) async {
    try {
      Income newIncome = Income(value: value, type: type); // إنشاء دخل جديد.
      Dio.Response response = await dio.post(apiUrl,
          data: newIncome.toJson()); // إرسال طلب POST لإضافة الدخل.
      if (response.statusCode == 200) {
        incomes.add(Income.fromJson(response.data)); // إضافة الدخل إلى القائمة.
      }
    } catch (e) {
      print('Error adding income: $e'); // في حالة حدوث خطأ.
    }
  }

  /// 🔹 **حذف دخل معين**
  Future<void> removeIncome(int index, int id) async {
    try {
      Dio.Response response =
          await dio.delete('$apiUrl/$id'); // إرسال طلب DELETE لحذف الدخل.
      if (response.statusCode == 200) {
        incomes.removeAt(index); // إزالة الدخل من القائمة.
      }
    } catch (e) {
      print('Error removing income: $e'); // في حالة حدوث خطأ.
    }
  }
}

class IncomeInfo {
  final Color color;
  final Icon icon;

  IncomeInfo({required this.color, required this.icon});
}
