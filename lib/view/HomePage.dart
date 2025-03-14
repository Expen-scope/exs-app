import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../const/Drawer.dart';
import '../controller/FinancialController.dart'; // لأجل التنسيق التاريخ

class HomePage extends StatelessWidget {
  final FinancialController controller = Get.put(FinancialController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: DrawerClass(
        accountName: '',
        accountEmail: '',
        accountInitial: '',
      ),
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
      title: Text('التحليل المالي'),
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
          Text(
            'التقرير المالي الشامل',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          SizedBox(height: 10),
          Obx(() => SegmentedButton(
                segments: [
                  ButtonSegment(value: 'week', label: Text('أسبوع')),
                  ButtonSegment(value: 'month', label: Text('شهر')),
                  ButtonSegment(value: 'year', label: Text('سنة')),
                ],
                selected: {controller.selectedPeriod.value},
                onSelectionChanged: (newSelection) {
                  controller.selectedPeriod.value = newSelection.first;
                  controller.generateFakeData();
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
                    title: 'الدخل',
                    value: controller.totalIncome.value,
                    color: Colors.green,
                  ),
                  _buildSummaryItem(
                    title: 'المصروفات',
                    value: controller.totalExpenses.value,
                    color: Colors.red,
                  ),
                  _buildSummaryItem(
                    title: 'الصافي',
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

  Widget _buildCategoryAnalysisChart() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('توزيع المصروفات', style: TextStyle(fontSize: 18)),
            SizedBox(height: 0.1),
            SizedBox(
              height: 225,
              child: Obx(() => PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                      sections: controller.fakeFinancialData.map((data) {
                        return PieChartSectionData(
                          color: data['color'],
                          value: data['amount'],
                          title:
                              '${(data['amount'] / controller.totalExpenses.value * 100).toStringAsFixed(1)}%',
                          radius: 30,
                          titleStyle:
                              TextStyle(color: Colors.white, fontSize: 12),
                        );
                      }).toList(),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendAnalysisChart() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('الاتجاهات الشهرية', style: TextStyle(fontSize: 18)),
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
                          spots:
                              controller.monthlyTrends.asMap().entries.map((e) {
                            return FlSpot(e.key.toDouble(), e.value['income']);
                          }).toList(),
                          color: Colors.green,
                          isCurved: true,
                          barWidth: 4,
                        ),
                        LineChartBarData(
                          spots:
                              controller.monthlyTrends.asMap().entries.map((e) {
                            return FlSpot(e.key.toDouble(), e.value['expense']);
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
      ),
    );
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
              height: 150, // تم تصغير الارتفاع هنا
              child: Obx(() => RadialPercentChart(
                    progress: (controller.totalExpenses.value /
                            controller.totalIncome.value) *
                        100,
                    progressColor: Colors.blue,
                    fillColor: Colors.grey[200]!,
                    lineWidth: 8, // تم تصغير سمك الخط هنا
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('نسبة الصرف'),
                        Text(
                          '${(controller.totalExpenses.value / controller.totalIncome.value * 100).toStringAsFixed(1)}%',
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
    return Padding(
      padding: EdgeInsets.all(16),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('آخر المعاملات', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Obx(() => SizedBox(
                height: 210, // ارتفاع مناسب لعرض 3 عناصر تقريبًا
                child: ListView.builder(
                  itemCount: controller.transactions.length,
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
              )),
            ],
          ),
        ),
      ),
    );
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
