import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../const/AppBarC.dart';
import '../controller/ReminderController.dart';
import '../model/Reminder.dart';
import '../utils/dialog_helper.dart';

class EditReminderScreen extends StatefulWidget {
  final ReminderModel reminder;
  const EditReminderScreen({Key? key, required this.reminder})
      : super(key: key);

  @override
  _EditReminderScreenState createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends State<EditReminderScreen> {
  final ReminderController reminderController = Get.find();
  final TextEditingController _amountController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.reminder.collectedoprice.toString();
  }

  void _handleReminderUpdate() async {
    setState(() => isLoading = true);
    try {
      final enteredAmount = double.tryParse(_amountController.text) ?? 0.0;

      if (enteredAmount <= 0) {
        DialogHelper.showErrorDialog(
          title: 'Invalid Amount',
          message: 'Please enter an amount greater than zero',
        );
        return;
      }

      if (enteredAmount > widget.reminder.price) {
        DialogHelper.showErrorDialog(
          title: 'Invalid Amount',
          message: 'The entered amount cannot exceed the total amount',
        );
        return;
      }

      final updatedReminder = ReminderModel(
        id: widget.reminder.id,
        name: widget.reminder.name,
        price: widget.reminder.price,
        collectedoprice: enteredAmount,
        time: widget.reminder.time,
      );

      final success = await reminderController.updateReminder(updatedReminder);

      if (success) {
        DialogHelper.showSuccessDialog(
          title: 'Success',
          message: 'Reminder updated successfully',
          onOkPressed: () {
            Get.back();
          },
        );
      } else {
        DialogHelper.showErrorDialog(
          title: 'Update Error',
          message: 'Failed to update reminder',
        );
      }
    } catch (e) {
      DialogHelper.showErrorDialog(
        title: 'Update Error',
        message: 'Failed to update reminder: ${e.toString()}',
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedAmount = widget.reminder.collectedoprice;
    final totalAmount = widget.reminder.price;
    final progress = totalAmount > 0 ? savedAmount / totalAmount : 0.0;
    final remainingAmount = totalAmount - savedAmount;

    return Scaffold(
      appBar: Appbarofpage(TextPage: " ${widget.reminder.name}"),
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
              color: Color(0xFF507da0),
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
        "Collected: ${saved.toStringAsFixed(2)} / ${total.toStringAsFixed(2)}",
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2e495e)),
      ),
    );
  }

  Widget _buildAmountInput(double remaining) {
    return TextFormField(
      cursorColor: Color(0xFF264653),
      controller: _amountController,
      decoration: InputDecoration(
        labelText:
            "Update collected amount (remaining: ${remaining.toStringAsFixed(2)})",
        labelStyle: TextStyle(color: Color(0xFF264653), fontSize: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF2e495e))),
        prefixIcon: Icon(Icons.attach_money, color: Color(0xFF2e495e)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => _amountController.clear(),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF264653), width: 2),
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
          onPressed: isLoading ? null : _handleReminderUpdate,
          icon: const Icon(Icons.update, color: Colors.white),
          label: Text(
            isLoading ? "Updating..." : "Update",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF507da0),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
