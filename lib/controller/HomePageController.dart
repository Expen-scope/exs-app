import 'package:get/get.dart';

class TransactionController extends GetxController {
  // قائمة المعاملات
  var transactions = <Map<String, dynamic>>[].obs;

  // إضافة معاملة جديدة
  void addTransaction(Map<String, dynamic> transaction) {
    transactions.add(transaction);
  }

  // تحديث معاملة
  void updateTransaction(int index, Map<String, dynamic> updatedTransaction) {
    transactions[index] = updatedTransaction;
  }

  // حذف معاملة
  void deleteTransaction(int index) {
    transactions.removeAt(index);
  }

  // الحصول على أول 5 معاملات
  List<Map<String, dynamic>> get topTransactions {
    return transactions.take(5).toList();
  }

  // عرض جميع المعاملات
  List<Map<String, dynamic>> getAllTransactions() {
    return transactions;
  }
}
