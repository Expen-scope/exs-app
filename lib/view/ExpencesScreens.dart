import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/AppBarC.dart';
import '../const/ContentLE.dart';
import '../controller/ExpensesController.dart';
import 'AddExpense.dart';

class ExpencesScreens extends StatelessWidget {
  const ExpencesScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExpencesController>();

    return Scaffold(
      appBar: Appbarofpage(TextPage: "Expences"),
      body: Obx(() {
        if (controller.listExpenses.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            // رسم الرسم البياني
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PieChart(
                  PieChartData(
                    sections: controller.listExpenses.isEmpty
                        ? [
                            PieChartSectionData(
                              value: 100,
                              color: Colors.grey,
                              title: "No Data",
                              radius: 50,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ]
                        : controller.listExpenses.map((expense) {
                            final type = expense.type;
                            final expenseInfo = controller.expenseData[type];
                            return PieChartSectionData(
                              value: expense.value,
                              color: expenseInfo?.color ?? Colors.grey,
                              title: expense.value.toString(),
                              radius: 50,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                    centerSpaceRadius: 40,
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 4,
                  ),
                ),
              ),
            ),
            // عرض قائمة المصروفات
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: controller.listExpenses.length,
                itemBuilder: (context, index) {
                  final expense = controller.listExpenses[index];
                  final expenseInfo = controller.expenseData[expense.type];
                  return ContentLE(
                    iconcolor: expenseInfo?.color?.withOpacity(0.2) ??
                        Colors.grey.withOpacity(0.2),
                    iconprimary: expenseInfo?.icon ??
                        const Icon(Icons.error, color: Colors.grey),
                    nameofcategory: expense.type,
                    onpres: () async {
                      await controller.removeExpense(index);
                    },
                    colorofmoney: expenseInfo?.color ?? Colors.grey,
                    valueofmoney: "\$${expense.value.toStringAsFixed(2)}",
                    icondelete: const Icon(Icons.delete, color: Colors.red),
                  );
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF507da0),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddExpences(),
          ));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
