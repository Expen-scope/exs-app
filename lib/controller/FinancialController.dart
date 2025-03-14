import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FinancialController extends GetxController {
  var isLoading = true.obs;
  var totalIncome = 0.0.obs;
  var totalExpenses = 0.0.obs;
  var transactions = <Map<String, dynamic>>[].obs;
  final String apiUrl =
      'https://abo-najib.test/api'; // Replace with your Laravel API URL

  @override
  void onInit() {
    super.onInit();
    loadFakeData();
    loadData();
  }

  void loadFakeData() {
    isLoading(true);
    Future.delayed(Duration(seconds: 1), () {
      totalIncome.value = 5000.0;
      totalExpenses.value = 3000.0;
      transactions.assignAll([
        {'id': 1, 'category': 'Food', 'amount': 50.0, 'date': '2025-03-13'},
        {
          'id': 2,
          'category': 'Transport',
          'amount': 20.0,
          'date': '2025-03-12'
        },
        {
          'id': 3,
          'category': 'Shopping',
          'amount': 150.0,
          'date': '2025-03-11'
        },
        {'id': 4, 'category': 'Salary', 'amount': 5000.0, 'date': '2025-03-01'},
      ]);
      isLoading(false);
    });
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
        // If the API fails, use the fake data
        loadFakeData();
      }
    } catch (e) {
      // If there's an error with the API, use the fake data
      loadFakeData();
    } finally {
      isLoading(false);
    }
  }
}

class FinancialAnalysisPage extends StatelessWidget {
  final FinancialController controller = Get.put(FinancialController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Financial Analysis')),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Colors.green,
                          value: controller.totalIncome.value,
                          title: 'Income',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          color: Colors.red,
                          value: controller.totalExpenses.value,
                          title: 'Expenses',
                          radius: 50,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        titlesData: FlTitlesData(show: true),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: controller.transactions
                                .asMap()
                                .entries
                                .map((e) => FlSpot(
                                      e.key.toDouble(),
                                      (e.value['amount'] as double),
                                    ))
                                .toList(),
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 4,
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
    );
  }
}
// Widget _buildFinancialChart() {
//   final double percentage = (totalExpenses / totalIncome * 100).clamp(0, 100);
//
//   return Container(
//     margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
//     height: MediaQuery.of(context).size.height * 0.5,
//     padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         colors: [Color(0xfffdfbfb), Color(0xffebedee)],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.15),
//           spreadRadius: 3,
//           blurRadius: 7,
//           offset: Offset(0, 3),
//         ),
//       ],
//     ),
//     child: Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).size.width * 0.03),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Financial Overview',
//                 style: TextStyle(
//                   fontSize: MediaQuery.of(context).size.width * 0.045,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.deepPurple,
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: MediaQuery.of(context).size.width * 0.03,
//                   vertical: MediaQuery.of(context).size.width * 0.01,
//                 ),
//                 decoration: BoxDecoration(
//                   color: percentage > 75
//                       ? Colors.red.shade100
//                       : percentage > 50
//                       ? Colors.orange.shade100
//                       : Colors.green.shade100,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   '${percentage.toStringAsFixed(1)}% Ratio',
//                   style: TextStyle(
//                     fontSize: MediaQuery.of(context).size.width * 0.035,
//                     color: percentage > 75
//                         ? Colors.red
//                         : percentage > 50
//                         ? Colors.orange
//                         : Colors.green,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: SfCartesianChart(
//             margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
//             plotAreaBorderWidth: 0,
//             primaryXAxis: CategoryAxis(
//               labelRotation: -20,
//               labelStyle: TextStyle(
//                   fontSize: MediaQuery.of(context).size.width * 0.03),
//               majorGridLines: const MajorGridLines(width: 0),
//             ),
//             primaryYAxis: NumericAxis(
//               numberFormat: NumberFormat.compactCurrency(symbol: '\$'),
//               axisLine: const AxisLine(width: 0),
//               labelStyle: TextStyle(
//                   fontSize: MediaQuery.of(context).size.width * 0.03),
//               majorTickLines: const MajorTickLines(size: 0),
//             ),
//             legend: Legend(
//               isVisible: true,
//               position: LegendPosition.top,
//               textStyle: TextStyle(
//                   fontSize: MediaQuery.of(context).size.width * 0.035),
//             ),
//             tooltipBehavior: TooltipBehavior(
//               enable: true,
//               header: '',
//               format: '{point.x}: \$ {point.y}',
//               canShowMarker: true,
//               textStyle: TextStyle(
//                   fontSize: MediaQuery.of(context).size.width * 0.03),
//             ),
//             series: <CartesianSeries>[
//               AreaSeries<SalesData, String>(
//                 dataSource: [
//                   SalesData('Income', totalIncome),
//                   SalesData('Expenses', totalExpenses),
//                   SalesData('Savings', totalIncome - totalExpenses),
//                 ],
//                 xValueMapper: (data, _) => data.month,
//                 yValueMapper: (data, _) => data.sales,
//                 name: 'Financial Trend',
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.blue.withOpacity(0.5),
//                     Colors.blue.withOpacity(0.1)
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//                 borderWidth: 3,
//                 borderColor: Colors.blue,
//                 markerSettings: MarkerSettings(
//                   isVisible: true,
//                   shape: DataMarkerType.circle,
//                   color: Colors.blue,
//                   borderWidth: 2,
//                   borderColor: Colors.white,
//                 ),
//                 dataLabelSettings: DataLabelSettings(
//                   isVisible: true,
//                   textStyle: TextStyle(
//                       fontSize: MediaQuery.of(context).size.width * 0.03,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding:
//           EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.02),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildLegendItem(
//                 color: Colors.greenAccent,
//                 title: 'Total Income',
//                 value: totalIncome,
//               ),
//               _buildLegendItem(
//                 color: Colors.redAccent,
//                 title: 'Total Expenses',
//                 value: totalExpenses,
//               ),
//               _buildLegendItem(
//                 color: Colors.blueAccent,
//                 title: 'Net Savings',
//                 value: totalIncome - totalExpenses,
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
