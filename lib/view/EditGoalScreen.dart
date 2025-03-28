import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../const/AppBarC.dart';
import '../controller/GoalController.dart';
import '../model/Goal.dart';

class EditGoalScreen extends StatefulWidget {
  final GoalModel goal;
  const EditGoalScreen({Key? key, required this.goal}) : super(key: key);

  @override
  _EditGoalScreenState createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  final GoalController goalController = Get.find();
  final TextEditingController _amountController = TextEditingController();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'goal_channel_id',
      'Goal Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(0, title, body, platformDetails);
  }

  void _handleGoalUpdate() async {
    try {
      final enteredAmount = double.tryParse(_amountController.text) ?? 0.0;

      if (enteredAmount <= 0) {
        Get.snackbar("خطأ", "الرجاء إدخال مبلغ صحيح أكبر من الصفر");
        return;
      }

      final newTotal = widget.goal.collectedmoney! + enteredAmount;
      final remaining = widget.goal.price! - widget.goal.collectedmoney!;

      if (newTotal > widget.goal.price!) {
        Get.snackbar("خطأ", "المبلغ المدخل يتجاوز المتبقي ($remaining)");
        return;
      }

      final updatedGoal = widget.goal.copyWith(collectedmoney: newTotal);

      final success =
          await goalController.updateGoal(widget.goal.id!, updatedGoal);

      if (success) {
        _amountController.clear();
        if (newTotal >= widget.goal.price!) {
          await _showNotification(
              "هدف مكتمل!", "تهانينا! لقد حققت هدف ${widget.goal.name}");
        }
        Get.back();
        Get.until((route) => Get.currentRoute == '/Goals');
      }
    } catch (e) {
      Get.snackbar("خطأ التحديث", "فشل في تحديث الهدف: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedAmount = widget.goal.collectedmoney!;
    final totalAmount = widget.goal.price!;
    final progress = totalAmount > 0 ? savedAmount / totalAmount : 0.0;
    final remainingAmount = totalAmount - savedAmount;

    return Scaffold(
      appBar: Appbarofpage(TextPage: "تعديل هدف: ${widget.goal.name}"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressChart(progress),
            _buildAmountInfo(savedAmount, totalAmount),
            _buildAmountInput(remainingAmount),
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart(double progress) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: progress * 100,
              color: Colors.blue,
              title: "${(progress * 100).toStringAsFixed(1)}%",
              radius: 60,
              titleStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            PieChartSectionData(
              value: (1 - progress) * 100,
              color: Colors.grey[300],
              title: "",
              radius: 60,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInfo(double saved, double total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        "المدخر: ${saved.toStringAsFixed(2)} / ${total.toStringAsFixed(2)}",
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      ),
    );
  }

  Widget _buildAmountInput(double remaining) {
    return TextFormField(
      controller: _amountController,
      decoration: InputDecoration(
        labelText: "المبلغ المضاف (المتبقي: ${remaining.toStringAsFixed(2)})",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue)),
        prefixIcon: Icon(Icons.attach_money, color: Colors.blue[800]),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => _amountController.clear(),
        ),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildUpdateButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: _handleGoalUpdate,
          icon: const Icon(Icons.update, color: Colors.white),
          label: const Text(
            "تحديث التقدم",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
