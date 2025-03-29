import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../const/AppBarC.dart';
import '../controller/IcomesContorller.dart';
import 'AddIncomes.dart';

class IncomesScreens extends StatelessWidget {
  IncomesScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<IncomesController>();

    return Scaffold(
      appBar: Appbarofpage(TextPage: "Incomes"),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchIncomes(),
        child: Obx(() => Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PieChart(
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
                                ),
                              ]
                            : controller.incomes.map((income) {
                                final categoryInfo =
                                    controller.incomeCategoriesData[
                                            income.category] ??
                                        IncomeInfo(
                                            color: Colors.grey,
                                            icon: const Icon(Icons.category));
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
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ListView.builder(
                    itemCount: controller.incomes.length,
                    itemBuilder: (context, index) {
                      final income = controller.incomes[index];
                      final categoryInfo =
                          controller.incomeCategoriesData[income.category] ??
                              IncomeInfo(
                                  color: Colors.grey,
                                  icon: const Icon(Icons.category));
                      return Card(
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
                            backgroundColor:
                                categoryInfo.color.withOpacity(0.2),
                            child: Icon(
                              categoryInfo.icon.icon,
                              color: const Color(0xFF264653),
                            ),
                          ),
                          title: Text(income.name),
                          subtitle:
                              Text("\$${income.price.toStringAsFixed(2)}"),
                          trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Color(0xFF264653)),
                              onPressed: () =>
                                  controller.deleteIncome(income.id)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
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
