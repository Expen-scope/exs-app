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

  bool isLoading = false;
  String selectedCategory = "Travel";
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final List<String> categories = [
    "Travel",
    "Education",
    "Electronics",
    "Sports",
    "Others"
  ];

  Future<void> saveGoal() async {
    setState(() => isLoading = true);

    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      showSnackBar('Please fill all required fields');
      setState(() => isLoading = false);
      return;
    }

    try {
      double.parse(priceController.text);
      double.parse(collectedController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Price and collected amount must be valid numbers'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    DateTime finalDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
    try {
      final newGoal = GoalModel(
        id: null,
        name: nameController.text,
        price: double.parse(priceController.text),
        collectedmoney: double.parse(collectedController.text),
        category: selectedCategory,
        time: finalDateTime,
        createdAt: DateTime.now(),
      );

      if (await goalController.addGoal(newGoal)) {
        await Future.delayed(Duration(milliseconds: 300));
        if (mounted) {
          Navigator.pop(context);
          goalController.fetchGoals();
        }
      }
    } catch (e) {
      showSnackBar('Error saving goal: ${e.toString()}');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && mounted) {
      setState(() => selectedDate = picked);
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
                onTap: pickDate,
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
