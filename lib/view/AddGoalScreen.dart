import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/AppBarC.dart';
import '../controller/GoalController.dart';
import '../model/Goal.dart';

class AddGoalScreen extends StatefulWidget {
  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final GoalController goalController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController collectedController = TextEditingController();

  String selectedCategory = "Travel";
  DateTime? selectedDate;

  final List<String> categories = [
    "Travel",
    "Education",
    "Electronics",
    "Sports",
    "Others"
  ];

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void saveGoal() {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        selectedDate == null) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    GoalModel newGoal = GoalModel(
      id: 0,
      name: nameController.text,
      price: double.tryParse(priceController.text) ?? 0.0,
      collectedmoney: double.tryParse(collectedController.text) ?? 0.0,
      category: selectedCategory,
      time: selectedDate!,
      createdAt: DateTime.now(),
    );

    goalController.addGoal(newGoal);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "Add Goal"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Goal Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Target Amount",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: collectedController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Initial Saved Amount",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedCategory = value!),
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text(selectedDate == null
                    ? "Select Deadline"
                    : "Deadline: ${selectedDate!.toLocal().toString().split(' ')[0]}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => pickDate(context),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: saveGoal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF507da0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  "Save Goal",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
