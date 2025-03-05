import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/AppBarC.dart';
import '../controller/GoalController.dart';
import '../model/Goal.dart';

class AddGoalScreen extends StatelessWidget {
  final GoalController goalController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController savedAmountController = TextEditingController();
  String selectedType = "Default Type";
  DateTime? selectedDate;

  final List<String> goalTypes = [
    "Default Type",
    "Education",
    "Travel",
    "Savings",
    "Others"
  ];

  void saveGoal(BuildContext context) {
    if (nameController.text.isEmpty || totalAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all required fields")));
      return;
    }

    GoalModel newGoal = GoalModel(
      name: nameController.text,
      totalAmount: double.tryParse(totalAmountController.text) ?? 0.0,
      savedAmount: double.tryParse(savedAmountController.text) ?? 0.0,
      type: selectedType,
      startDate: DateTime.now(),
      deadline: selectedDate,
    );

    goalController.addGoal(newGoal);
    Get.back(); // إغلاق الشاشة
  }

  Future<void> pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (pickedTime != null) {
        selectedDate = DateTime(pickedDate.year, pickedDate.month,
            pickedDate.day, pickedTime.hour, pickedTime.minute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "Goal Add"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Goal Name")),
            TextField(
                controller: totalAmountController,
                decoration: const InputDecoration(labelText: "Total Amount"),
                keyboardType: TextInputType.number),
            TextField(
                controller: savedAmountController,
                decoration: const InputDecoration(labelText: "Saved Amount"),
                keyboardType: TextInputType.number),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: goalTypes
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) => selectedType = value!,
              decoration: const InputDecoration(labelText: "Goal Type"),
            ),
            TextButton(
                onPressed: () => pickDateTime(context),
                child: Text(selectedDate == null
                    ? "Choose Date & Time"
                    : selectedDate!.toLocal().toString())),
            ElevatedButton(
                onPressed: () => saveGoal(context),
                child: const Text("Save Goal")),
          ],
        ),
      ),
    );
  }
}
