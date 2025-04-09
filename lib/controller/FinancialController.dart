import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/Expenses.dart';
import '../model/Incomes.dart';
import 'ExpensesController.dart';
import 'IcomesContorller.dart';

class FinancialController extends GetxController {
  final IncomesController incomesController = Get.find();
  final ExpencesController expensesController = Get.find();
  var categoryAnalysis = <Map<String, dynamic>>[].obs;

  void calculateCategoryAnalysis() {
    Map<String, double> combinedData = {};
    for (var income in incomesController.incomes) {
      combinedData[income.category] =
          (combinedData[income.category] ?? 0) + income.price;
    }

    for (var expense in expensesController.listExpenses) {
      combinedData[expense.type] =
          (combinedData[expense.type] ?? 0) - expense.value;
    }

    double total = combinedData.values.fold(0, (a, b) => a + b);

    categoryAnalysis.value = combinedData.entries.map((entry) {
      return {
        "category": entry.key,
        "amount": entry.value.abs(),
        "percentage": (entry.value.abs() / total * 100).toStringAsFixed(1),
        "color": entry.value >= 0 ? Colors.green : Colors.red,
      };
    }).toList();
  }

  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpenses = 0.0.obs;
  final RxDouble balance = 0.0.obs;
  final RxString selectedPeriod = 'month'.obs;
  final RxList<Map<String, dynamic>> transactions =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> monthlyTrends =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // Date range filters
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    _setupDataListeners();
    setPeriod(selectedPeriod.value);
    loadData();
  }

  void _setupDataListeners() {
    ever(incomesController.incomes, (_) => _processData());
    ever(expensesController.listExpenses, (_) => _processData());
    ever(startDate, (_) => _processData());
    ever(endDate, (_) => _processData());
  }

  Future<void> loadData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await Future.wait([
        incomesController.fetchIncomes(),
        expensesController.fetchExpenses()
      ]);
      _processData();
    } catch (e) {
      errorMessage.value = 'Failed to load data: $e';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void _processData() {
    try {
    _calculateTotals();
    _processCategoryAnalysis();
    _processMonthlyTrends();
    _processTransactions();
      _calculateBalance();
      update();
    } catch (e) {
      errorMessage.value = 'Error processing data: $e';
      Get.snackbar('Error', errorMessage.value);
    }
  }

  void _calculateTotals() {
    final filteredIncomes = _filterByDateRange(incomesController.incomes);
    final filteredExpenses =
        _filterByDateRange(expensesController.listExpenses);

    totalIncome.value =
        filteredIncomes.fold(0.0, (sum, income) => sum + income.price);
    totalExpenses.value =
        filteredExpenses.fold(0.0, (sum, expense) => sum + expense.value);
  }

  void _calculateBalance() {
    balance.value = totalIncome.value - totalExpenses.value;
  }

  List<T> _filterByDateRange<T>(List<T> items) {
    if (startDate.value == null || endDate.value == null) return items;

    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    return items.where((item) {
      String dateString;
      if (item is Income) {
        dateString = item.time;
      } else if (item is Expense) {
        dateString = item.date;
      } else {
        return false;
      }

      try {
        final itemDate = dateFormat.parse(dateString);

        final bool isWithinRange = !itemDate.isBefore(startDate.value!) &&
            !itemDate.isAfter(endDate.value!);

        return isWithinRange;
      } catch (e) {
        print(
            'Error parsing date for ${item.runtimeType}: $dateString. Error: $e');
        return false;
      }
    }).toList();
  }

  void _processCategoryAnalysis() {
    final categoryMap = <String, double>{};

    final filteredIncomes = _filterByDateRange(incomesController.incomes);
    for (final income in filteredIncomes) {
      categoryMap.update(
        income.category,
        (value) => value + income.price,
        ifAbsent: () => income.price,
      );
    }

    final filteredExpenses =
        _filterByDateRange(expensesController.listExpenses);
    for (final expense in filteredExpenses) {
      categoryMap.update(
        expense.type,
        (value) => value - expense.value,
        ifAbsent: () => -expense.value,
      );
    }

    final total =
        categoryMap.values.fold<double>(0, (sum, value) => sum + value.abs());

    categoryAnalysis.assignAll(categoryMap.entries.map((e) {
      final isIncome = e.value >= 0;

      dynamic categoryInfo;
      if (isIncome) {
        categoryInfo = incomesController.incomeCategoriesData[e.key] ??
            IncomeInfo(color: Colors.grey, icon: Icon(Icons.money));
      } else {
        categoryInfo = expensesController.expenseData[e.key] ??
            ExpenseInfo(color: Colors.grey, icon: Icon(Icons.money_off));
      }

      return {
        'category': e.key,
        'amount': e.value.abs(),
        'color': isIncome ? Colors.green : Colors.red,
        'icon': categoryInfo.icon,
        'percentage': total == 0
            ? '0.0'
            : ((e.value.abs() / total) * 100).toStringAsFixed(1),
      };
    }).toList());
  }

  void _processMonthlyTrends() {
    final periodMap = <String, Map<String, double>>{};
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    final filteredIncomes = _filterByDateRange(incomesController.incomes);
    final filteredExpenses =
        _filterByDateRange(expensesController.listExpenses);

    String groupByKey(DateTime date) {
      if (selectedPeriod.value == 'week') {
        final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
        return 'Week ${DateFormat('dd/MM').format(startOfWeek)}';
      } else if (selectedPeriod.value == 'month') {
        return DateFormat('MMM y').format(date);
      } else {
        return DateFormat('y').format(date);
      }
    }

    for (final income in filteredIncomes) {
      try {
        final date = dateFormat.parse(income.time);
        final key = groupByKey(date);

        periodMap.putIfAbsent(key, () => {'income': 0.0, 'expense': 0.0});
        periodMap[key]!['income'] =
            (periodMap[key]!['income'] ?? 0.0) + income.price;
      } catch (e) {
        print('Error processing income date: ${income.time}');
      }
    }

    for (final expense in filteredExpenses) {
      try {
        final date = dateFormat.parse(expense.date);
        final key = groupByKey(date);

        periodMap.putIfAbsent(key, () => {'income': 0.0, 'expense': 0.0});
        periodMap[key]!['expense'] =
            (periodMap[key]!['expense'] ?? 0.0) + expense.value;
      } catch (e) {
        print('Error processing expense date: ${expense.date}');
      }
    }

    List<Map<String, dynamic>> sortedEntries = [];
    periodMap.forEach((key, value) {
      DateTime sortDate;
      try {
        if (selectedPeriod.value == 'week') {
          final dateString = key.split(' ')[1];
          sortDate = DateFormat('dd/MM').parse(dateString);
        } else if (selectedPeriod.value == 'month') {
          sortDate = DateFormat('MMM y').parse(key);
        } else {
          sortDate = DateFormat('y').parse(key);
        }
      } catch (e) {
        sortDate = DateTime.now();
      }

      sortedEntries.add({
        'key': key,
        'sortDate': sortDate,
        'income': value['income']!,
        'expense': value['expense']!,
        'balance': value['income']! - value['expense']!,
      });
    });

    sortedEntries.sort((a, b) => a['sortDate'].compareTo(b['sortDate']));

    monthlyTrends.assignAll(sortedEntries.map((e) => {
          'month': e['key'],
          'income': e['income'],
          'expense': e['expense'],
          'balance': e['balance'],
        }));
  }

  void _processTransactions() {
    final filteredIncomes = _filterByDateRange(incomesController.incomes);
    final filteredExpenses =
        _filterByDateRange(expensesController.listExpenses);
    print('Filtered Incomes: ${filteredIncomes.length}');
    print('Filtered Expenses: ${filteredExpenses.length}');

    final combined = [
      ...filteredIncomes.map((income) => _incomeToTransaction(income)),
      ...filteredExpenses.map((expense) => _expenseToTransaction(expense)),
    ];
    print('Combined transactions: ${combined.length}');

    combined.sort((a, b) => b['date'].compareTo(a['date']));

    transactions.assignAll(combined);
  }

  Map<String, dynamic> _incomeToTransaction(Income income) {
    final categoryInfo =
        incomesController.incomeCategoriesData[income.category] ??
        IncomeInfo(color: Colors.grey, icon: Icon(Icons.money));

    DateTime date;
    try {
      date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(income.time);
    } catch (e) {
      date = DateTime.now();
    }

    return {
      'type': 'income',
      'category': income.category,
      'amount': income.price,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'color': categoryInfo.color,
      'icon': categoryInfo.icon,
      'name': income.name,
    };
  }

  Map<String, dynamic> _expenseToTransaction(Expense expense) {
    final categoryInfo = expensesController.expenseData[expense.type] ??
        ExpenseInfo(color: Colors.grey, icon: Icon(Icons.money_off));

    DateTime date;
    try {
      date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(expense.date);
    } catch (e) {
      date = DateTime.now(); // أو التعامل مع الخطأ حسب منطق التطبيق
    }

    return {
      'type': 'expense',
      'category': expense.type,
      'amount': expense.value,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'color': categoryInfo.color,
      'icon': categoryInfo.icon,
      'name': expense.name,
    };
  }

  void setPeriod(String period) {
    final now = DateTime.now();
    DateTime start;
    DateTime end;

    switch (period) {
      case 'week':
        start = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: now.weekday - 1));
        end = start.add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
        break;
      case 'month':
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      case 'year':
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year, 12, 31, 23, 59, 59);
        break;
      default:
        start = now;
        end = now;
    }
    selectedPeriod.value = period;
    setDateRange(start, end);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    startDate.value = start;
    endDate.value = end;
    loadData();
  }

  void clearDateRange() {
    startDate.value = null;
    endDate.value = null;
  }

  // Financial metrics
  double get savingsRate {
    if (totalIncome.value == 0) return 0;
    return ((totalIncome.value - totalExpenses.value) / totalIncome.value) *
        100;
  }

  Map<String, double> get monthlyAverages {
    if (monthlyTrends.isEmpty) return {'income': 0, 'expense': 0, 'balance': 0};

    final totalMonths = monthlyTrends.length;
    final totalIncome = monthlyTrends.fold(
        0.0, (sum, month) => sum + (month['income'] as double));
    final totalExpense = monthlyTrends.fold(
        0.0, (sum, month) => sum + (month['expense'] as double));

    return {
      'income': totalIncome / totalMonths,
      'expense': totalExpense / totalMonths,
      'balance': (totalIncome - totalExpense) / totalMonths,
    };
  }
}
