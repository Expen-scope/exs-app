import 'package:get/get.dart';
import 'ExpensesController.dart';
import 'IcomesContorller.dart';


class TransactionController extends GetxController {
  // المراجع الخاصة بالمداخيل والمصاريف
  final IncomesController incomesController = Get.find<IncomesController>();
  final ExpencesController expensesController = Get.find<ExpencesController>();

  // إجمالي المداخيل والمصاريف
  var totalIncome = 0.0.obs;
  var totalExpenses = 0.0.obs;
  var balance = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    calculateAnalytics();
  }

  // حساب إجمالي المداخيل والمصاريف والرصيد
  void calculateAnalytics() {
    totalIncome.value = incomesController.incomes.fold(0.0, (sum, item) => sum + item.value);
    totalExpenses.value = expensesController.listExpenses.fold(0.0, (sum, item) => sum + item.value);
    balance.value = totalIncome.value - totalExpenses.value;
  }

  // تحديث التحليلات عند تغيير البيانات
  void updateAnalytics() {
    calculateAnalytics();
  }
}
