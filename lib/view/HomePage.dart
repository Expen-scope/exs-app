import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../const/Drawer.dart';
import '../controller/FinancialController.dart';

class Homepage extends StatelessWidget {
  final FinancialController controller = Get.put(FinancialController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1e3a4b),
        elevation: 0,
        title: Text('Your App\'s name'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Settings',
            enableFeedback: true,
            icon: Icon(
              CupertinoIcons.gear_alt_fill,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigator.push(
              // context,
              // MaterialPageRoute(
              // builder: (context) => RouteWhereYouGo(),
              // ),
              // );
            },
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      drawer: const DrawerClass(
        accountName: 'khader',
        accountEmail: 'khader@gmail',
        accountInitial: 'K',
      ),
      body: Obx(() {
        return controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: controller.loadData,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    // _buildHeaderSection(),
                    CustomPaint(
                      painter: MyPainter(),
                      child: Container(height: 3),
                    ),
                    _buildFinancialAnalysis(),
                    _buildTransactionList(),
                  ],
                ),
              );
      }),
    );
  }

  // Widget _buildHeaderSection() {
  //   return SizedBox(
  //     height: 200, // Adjust height accordingly
  //     child: Stack(
  //       children: [
  //         Container(
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //               colors: [Colors.blue, Colors.green],
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //             ),
  //           ),
  //         ),
  //         // Center(
  //         //   child: Obx(() {
  //         //     return Text(
  //         //       'Financial Difference: ${(controller.totalIncome.value - controller.totalExpenses.value).toStringAsFixed(2)}',
  //         //       style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //         //     );
  //         //   }),
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFinancialAnalysis() {
    return Column(
      children: [
        DropdownButton<String>(
          value:
              'Last Month', // Replace with your dynamic time period selection
          items: ['Last Week', 'Last Month', 'Last 2 Months']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) {
            // Handle change in time period and reload data
          },
        ),
        SizedBox(height: 10),
        Obx(() {
          return controller.totalExpenses.value > 0 ||
                  controller.totalIncome.value > 0
              ? Column(
                  children: [
                    _buildPieChart(),
                    _buildFinancialChart(),
                  ],
                )
              : Container();
        }),
      ],
    );
  }

  Widget _buildPieChart() {
    return Container(
      child: Center(child: Text("Pie Chart Placeholder")),
    );
  }

  Widget _buildFinancialChart() {
    return Container(
      child: Center(child: Text("Financial Chart Placeholder")),
    );
  }

  Widget _buildTransactionList() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xfff9f9f9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Recent Transactions',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800]),
            ),
          ),
          Obx(() {
            if (controller.transactions.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No transactions found',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return Column(
                children: controller.transactions
                    .take(5)
                    .map((transaction) =>
                        _transactionTile(transaction: transaction))
                    .toList(),
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _transactionTile({required Map<String, dynamic> transaction}) {
    return ListTile(
      title: Text(transaction['category'] ?? 'Transaction'),
      subtitle: Text(transaction['date'] ?? 'Date'),
      trailing: Text('\$${transaction['amount']}'),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_1 = Paint()
      ..color = Color(0xFF1e3a4b)
      ..style = PaintingStyle.fill;

    Path path_1 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * .1, 0)
      ..cubicTo(size.width * .05, 0, 0, 20, 0, size.width * .08);

    Path path_2 = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width * .9, 0)
      ..cubicTo(
          size.width * .95, 0, size.width, 20, size.width, size.width * .08);

    Paint paint_2 = Paint()
      ..color = Color(0xFF1e3a4b)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    Path path_3 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(path_1, paint_1);
    canvas.drawPath(path_2, paint_1);
    canvas.drawPath(path_3, paint_2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
