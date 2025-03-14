import 'dart:math';
import 'dart:ui';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

class FinancialController extends GetxController {
  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpenses = 0.0.obs;
  final RxString selectedPeriod = 'month'.obs;
  final RxList<Map<String, dynamic>> transactions = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> fakeFinancialData = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> monthlyTrends = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2)); // محاكاة جلب البيانات من API
    generateFakeData();
    generateTransactions();
    isLoading.value = false;
  }

  void generateFakeData() {
    final rand = Random();

    // توليد بيانات الاتجاهات الشهرية
    List<Map<String, dynamic>> tempMonthly = [];
    for (int i = 0; i < 6; i++) {
      tempMonthly.add({
        'month': DateFormat('MMM').format(DateTime.now().subtract(Duration(days: 30 * i))),
        'income': rand.nextDouble() * 5000 + 3000,
        'expense': rand.nextDouble() * 4000 + 2000,
      });
    }
    monthlyTrends.assignAll(tempMonthly);

    // توليد بيانات الفئات
    List<Map<String, dynamic>> tempCategories = [];
    List<String> categories = ['الطعام', 'المواصلات', 'الترفيه', 'الفواتير', 'التسوق', 'الصحة'];
    for (String category in categories) {
      tempCategories.add({
        'category': category,
        'amount': rand.nextDouble() * 3000 + 1000,
        'color': Color.fromRGBO(
          rand.nextInt(256),
          rand.nextInt(256),
          rand.nextInt(256),
          1,
        ),
      });
    }
    fakeFinancialData.assignAll(tempCategories);

    totalIncome.value = tempMonthly.last['income'];
    totalExpenses.value = tempMonthly.last['expense'];
  }

  void generateTransactions() {
    List<Map<String, dynamic>> tempTransactions = [];
    final rand = Random();
    for (int i = 0; i < 10; i++) {
      tempTransactions.add({
        'category': ['الطعام', 'المواصلات', 'الفواتير'][rand.nextInt(3)],
        'amount': (rand.nextDouble() * 500 + 50).toStringAsFixed(2),
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: i))),
        'type': rand.nextBool() ? 'income' : 'expense',
      });
    }
    transactions.assignAll(tempTransactions);
  }
}