import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../const/AppBarC.dart';
import '../controller/IcomesContorller.dart';
import 'AddIncomes.dart';

class IncomesScreens extends StatelessWidget {
  IncomesScreens({super.key});

  final IncomesController controller =
      Get.find<IncomesController>(); // استخدام Get.find بدل Get.put

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "Incomes"),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                return PieChart(
                  PieChartData(
                    sections: controller.incomes.isEmpty
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
                            )
                          ]
                        : controller.incomes.map((income) {
                            final type = income.type;
                            final incomeInfo = controller.incomeListDATA[type];
                            return PieChartSectionData(
                              value: income.value,
                              color: incomeInfo?.color ?? Colors.grey,
                              title: income.value.toString(),
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
          ),
          // 🔹 **قائمة المداخل المالية**
          Expanded(
            flex: 3,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: controller.incomes.length,
                itemBuilder: (context, index) {
                  final income = controller.incomes[index];
                  final incomesInfo = controller.incomeListDATA[income.type];

                  return Card(
                    key: ValueKey(income.id),
                    elevation: 5,
                    color: Colors.grey[200],
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15),
                      leading: CircleAvatar(
                        backgroundColor: incomesInfo?.color?.withOpacity(0.2) ??
                            const Color(0xFF507da0).withOpacity(0.2),
                        child: Icon(
                          incomesInfo?.icon?.icon ?? Icons.attach_money,
                          color: const Color(0xFF264653),
                        ),
                      ),
                      title: Text(
                        income.type,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF264653),
                        ),
                      ),
                      subtitle: Text(
                        "\$${income.value.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                        ),
                      ),
                      trailing: IconButton(
                        icon:
                            const Icon(Icons.delete, color: Color(0xFF264653)),
                        onPressed: () async {
                          await controller.removeIncome(index, income.id!);
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
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
}
