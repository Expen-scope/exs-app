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
                  final income =
                      controller.incomes[index]; // استخدام Income Model
                  final incomesInfo = controller.incomeListDATA[income.type];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: incomesInfo?.color?.withOpacity(0.2) ??
                          Colors.grey.withOpacity(0.2),
                      child: incomesInfo?.icon ?? const Icon(Icons.error),
                    ),
                    title: Text(income.type),
                    subtitle: Text("\$${income.value.toStringAsFixed(2)}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await controller.removeIncome(index, income.id!);
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF507da0),
        onPressed: () async {
          await Get.to(() => AddIncomes());
          controller.fetchIncomes();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
