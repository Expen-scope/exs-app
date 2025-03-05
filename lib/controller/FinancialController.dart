import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FinancialController extends GetxController {
  var isLoading = true.obs;
  var totalIncome = 0.0.obs;
  var totalExpenses = 0.0.obs;
  var transactions = <Map<String, dynamic>>[].obs;

  final String apiUrl =
      'https://your-laravel-api-endpoint.com'; // Replace with your Laravel API URL

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading(true);
    try {
      final response = await http.get(Uri.parse('$apiUrl/financial-data'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        totalIncome.value = data['totalIncome'];
        totalExpenses.value = data['totalExpenses'];
        transactions.assignAll(data['transactions']);
      } else {
        throw Exception('Failed to load financial data');
      }
    } finally {
      isLoading(false);
    }
  }
}
