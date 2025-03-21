import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../const/AppBarC.dart';
import '../controller/IcomesContorller.dart';
import 'AddIncomes.dart';

class IncomesScreens extends StatelessWidget {
  IncomesScreens({super.key});
  final IncomesController controller = Get.find<IncomesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "Incomes"),
      body: Column(
        children: [
          _buildPieChart(),
          _buildIncomesList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => AddIncomes());
          controller.fetchIncomes();
        },
        backgroundColor: const Color(0xFF507da0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPieChart() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.incomes.isEmpty) {
            return const Center(child: Text("No incomes available"));
          }
          return PieChart(
            PieChartData(
              sections: controller.incomes.map((income) {
                final categoryInfo = controller
                        .incomeCategoriesData[income.category] ??
                    IncomeInfo(color: Colors.grey, icon: Icon(Icons.category));
                return PieChartSectionData(
                  value: income.price,
                  color: categoryInfo.color,
                  title: "\$${income.price.toStringAsFixed(0)}",
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
          );
        }),
      ),
    );
  }

  Widget _buildIncomesList() {
    return Expanded(
      flex: 3,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.incomes.length,
          itemBuilder: (context, index) {
            final income = controller.incomes[index];
            final categoryInfo =
                controller.incomeCategoriesData[income.category] ??
                    IncomeInfo(color: Colors.grey, icon: Icon(Icons.category));
            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(15),
                leading: CircleAvatar(
                  backgroundColor: categoryInfo.color.withOpacity(0.2),
                  child: Icon(categoryInfo.icon.icon,
                      color: const Color(0xFF264653)),
                ),
                title: Text(
                  income.nameOfExpense,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF264653)),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("\$${income.price.toStringAsFixed(2)}",
                        style:
                            TextStyle(color: Colors.grey[800], fontSize: 16)),
                    Text(DateFormat('yyyy-MM-dd HH:mm').format(income.time),
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Color(0xFF264653)),
                  onPressed: () => controller.deleteIncome(income.id),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
