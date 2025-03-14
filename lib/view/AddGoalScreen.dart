import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/AppBarC.dart';
import '../const/Constants.dart';
import '../controller/GoalController.dart';
import '../model/Goal.dart';

class AddGoalScreen extends StatefulWidget {
  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
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

  void saveGoal() {
    if (nameController.text.isEmpty || totalAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    GoalModel newGoal = GoalModel(
      id: DateTime.now().millisecondsSinceEpoch,
      name: nameController.text,
      totalAmount: double.tryParse(totalAmountController.text) ?? 0.0,
      savedAmount: double.tryParse(savedAmountController.text) ?? 0.0,
      type: selectedType,
      startDate: DateTime.now(),
      deadline: selectedDate,
    );

    goalController.addGoal(newGoal);
    Get.back();
  }

  Future<void> pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "Goal Add"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: hight(context) * .028),
        child: Column(
          children: [
            SizedBox(height: hight(context) * .02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hight(context) * .007),
              child: TextField(
                controller: nameController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Goal Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: hight(context) * .02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hight(context) * .007),
              child: TextField(
                controller: totalAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Total Amount",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: hight(context) * .02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hight(context) * .007),
              child: TextField(
                controller: savedAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Saved Amount",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: hight(context) * .02),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: goalTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Goal Type",
                border: OutlineInputBorder(),
              ),
            ),
            TextButton(
              onPressed: () => pickDateTime(context),
              child: Text(
                style: TextStyle(
                  color: Color(0xFF507da0),
                ),
                selectedDate == null
                    ? "Choose Date & Time"
                    : "${selectedDate!.toLocal()}".split('.')[0],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hight(context) * .1),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF507da0), Color(0xFF507da0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8), // تعديل شكل الزر
                ),
                child: ElevatedButton(
                    onPressed: saveGoal,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      backgroundColor: Color(
                          0xFF507da0), // اجعل الخلفية شفافة لتظهر التدرجات
                      // اجعل الخلفية شفافة لتظهر التدرجات
                      shadowColor: Colors.transparent, // إزالة الظل الافتراضي
                    ),
                    child: const Text(
                      "Save Goal",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors
                            .white, // اجعل النص أبيض ليظهر بوضوح على التدرج
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
