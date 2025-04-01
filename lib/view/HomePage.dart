import 'dart:math';
import 'package:abo_najib_2/const/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../const/Drawer.dart';
import '../controller/FinancialController.dart';

class HomePage extends StatelessWidget {
  final FinancialController controller = Get.put(FinancialController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      body: Obx(() {
        return controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: controller.loadData,
                child: ListView(
                  children: [
                    _buildHeader(),
                    _buildFinancialSummary(),
                    _buildAdvancedChartsSection(),
                    _buildTransactionSection(),
                  ],
                ),
              );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: Text('ABO NAJIB',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: "Tajawal-Bold.ttf")),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2e495e),
              Color(0xFF507da0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2e495e), Color(0xFF507da0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Text('Financial analysis',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: "Tajawal-Bold.ttf")),
          SizedBox(height: 10),
          Obx(() => SegmentedButton(
                segments: [
                  ButtonSegment(value: 'week', label: Text('week')),
                  ButtonSegment(value: 'month', label: Text('month')),
                  ButtonSegment(value: 'year', label: Text('year')),
                ],
                selected: {controller.selectedPeriod.value},
                onSelectionChanged: (newSelection) {
                  controller.selectedPeriod.value = newSelection.first;
                  final now = DateTime.now();
                  DateTime startDate;
                  switch (newSelection.first) {
                    case 'week':
                      startDate = now.subtract(Duration(days: now.weekday - 1));
                      break;
                    case 'month':
                      startDate = DateTime(now.year, now.month, 1);
                      break;
                    case 'year':
                      startDate = DateTime(now.year, 1, 1);
                      break;
                    default:
                      startDate = now;
                  }
                  controller.setDateRange(startDate, now);
                },
              )),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    title: 'Income',
                    value: controller.totalIncome.value,
                    color: Colors.green,
                  ),
                  _buildSummaryItem(
                    title: 'Expenses',
                    value: controller.totalExpenses.value,
                    color: Colors.red,
                  ),
                  _buildSummaryItem(
                    title: 'Net',
                    value: controller.totalIncome.value -
                        controller.totalExpenses.value,
                    color: (controller.totalIncome.value -
                                controller.totalExpenses.value) >
                            0
                        ? Colors.blue
                        : Colors.orange,
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
      {required String title, required double value, required Color color}) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 14)),
        AnimatedCount(
          count: value,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildAdvancedChartsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildCategoryAnalysisChart(),
          SizedBox(height: 20),
          _buildTrendAnalysisChart(),
          SizedBox(height: 20),
          _buildBudgetProgressChart(),
        ],
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 5,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryAnalysisChart() {
    return Obx(() {
      if (controller.categoryAnalysis.isEmpty) {
        return _buildEmptyState(
          icon: Icons.pie_chart_outline,
          message: 'No financial data available',
        );
      }

      return Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Income & Expense Distribution',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 0.1),
              SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: controller.categoryAnalysis.map((data) {
                      return PieChartSectionData(
                        color: data['color'],
                        value: data['amount'],
                        title: '${data['percentage']}%',
                        radius: 25,
                        titleStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildLegend(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 10,
      children: controller.categoryAnalysis.map((data) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              color: data['color'],
            ),
            SizedBox(width: 5),
            Text(data['category']),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTrendAnalysisChart() {
    return Obx(() {
      if (controller.monthlyTrends.isEmpty) {
        return _buildEmptyState(
          icon: Icons.trending_up,
          message: 'No trend data available',
        );
      }
      return Card(
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Monthly trends', style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                SizedBox(
                  height: 350,
                  child: Obx(() => LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(enabled: true),
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Text(controller
                                        .monthlyTrends[value.toInt()]['month']),
                                  );
                                },
                              ),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: controller.monthlyTrends
                                  .asMap()
                                  .entries
                                  .map((e) {
                                return FlSpot(
                                    e.key.toDouble(), e.value['income']);
                              }).toList(),
                              color: Colors.green,
                              isCurved: true,
                              barWidth: 4,
                            ),
                            LineChartBarData(
                              spots: controller.monthlyTrends
                                  .asMap()
                                  .entries
                                  .map((e) {
                                return FlSpot(
                                    e.key.toDouble(), e.value['expense']);
                              }).toList(),
                              color: Colors.red,
                              isCurved: true,
                              barWidth: 4,
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ));
    });
  }

  Widget _buildBudgetProgressChart() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(60),
        child: Column(
          children: [
            Text('', style: TextStyle(fontSize: 18)),
            SizedBox(height: 0.1),
            SizedBox(
              height: 150,
              child: Obx(() => RadialPercentChart(
                    progress: controller.totalIncome.value == 0
                        ? 0
                        : (controller.totalExpenses.value /
                                controller.totalIncome.value) *
                            100,
                    progressColor: Colors.blue,
                    fillColor: Colors.grey[200]!,
                    lineWidth: 8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Exchange ratio'),
                        Text(
                          '${controller.totalIncome.value == 0 ? 0 : (controller.totalExpenses.value / controller.totalIncome.value * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionSection() {
    return Obx(() {
      if (controller.transactions.isEmpty) {
        return _buildEmptyState(
          icon: Icons.receipt,
          message: 'No transactions recorded',
        );
      }

      return Padding(
          padding: EdgeInsets.all(16),
          child: Card(
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Latest transactions', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 210,
                    child: ListView.separated(
                      itemCount: controller.transactions.length,
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        final transaction = controller.transactions[index];
                        return ListTile(
                          leading: Icon(
                            transaction['type'] == 'income'
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: transaction['type'] == 'income'
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text(transaction['category']),
                          subtitle: Text(transaction['date']),
                          trailing: Text('\$${transaction['amount']}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}

class AnimatedCount extends StatelessWidget {
  final double count;
  final TextStyle style;

  const AnimatedCount({required this.count, required this.style});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: count),
      duration: Duration(seconds: 1),
      builder: (context, value, child) {
        return Text(
          '\$${value.toStringAsFixed(2)}',
          style: style,
        );
      },
    );
  }
}

class RadialPercentChart extends StatelessWidget {
  final double progress;
  final Color progressColor;
  final Color fillColor;
  final double lineWidth;
  final Widget child;

  const RadialPercentChart({
    required this.progress,
    required this.progressColor,
    required this.fillColor,
    required this.lineWidth,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(
        progress: progress,
        progressColor: progressColor,
        fillColor: fillColor,
        lineWidth: lineWidth,
      ),
      child: Center(child: child),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color fillColor;
  final double lineWidth;

  _RadialPainter({
    required this.progress,
    required this.progressColor,
    required this.fillColor,
    required this.lineWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = fillColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - lineWidth / 2;

    canvas.drawCircle(center, radius, paint);

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * (progress / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
