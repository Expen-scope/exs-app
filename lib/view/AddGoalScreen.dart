import 'package:abo_najib_2/const/Constants.dart';
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

  final List<String> categories = ["Travel", "Savings", "Education", "Others"];

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

    final newGoal = GoalModel(
      id: null,
      name: nameController.text,
      price: double.parse(priceController.text),
      collectedmoney: double.parse(collectedController.text),
      category: selectedCategory,
      time: finalDateTime,
      createdAt: DateTime.now(),
    );

    bool success = await goalController.addGoal(newGoal);
    if (success) {
      await Future.delayed(Duration(milliseconds: 300));
      if (mounted) {
        Navigator.pop(context);
        goalController.fetchGoals();
      }
    }
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF507da0),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF507da0),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
    setState(() => isLoading = false);
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

  Future<void> pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Color(0xFF507da0),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF507da0),
                ),
              )),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "Add Goal"),
      body: Padding(
        padding: EdgeInsets.all(hight(context) * .019),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: hight(context) * 0.025),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: hight(Get.context!) * .007),
                child: TextField(
                  cursorColor: Color(0xFF264653),
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Goal Name",
                    labelStyle:
                        TextStyle(color: Color(0xFF264653), fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Color(0xFF264653), width: 2),
                    ),
                  ),
                ),
              ),
              SizedBox(height: hight(context) * 0.024),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: hight(Get.context!) * .007),
                child: TextField(
                  cursorColor: Color(0xFF264653),
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Target Amount",
                    labelStyle:
                        TextStyle(color: Color(0xFF264653), fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Color(0xFF264653), width: 2),
                    ),
                  ),
                ),
              ),
              SizedBox(height: hight(context) * 0.024),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: hight(Get.context!) * .007),
                child: TextField(
                  cursorColor: Color(0xFF264653),
                  controller: collectedController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Amount collected",
                    labelStyle:
                        TextStyle(color: Color(0xFF264653), fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Color(0xFF264653), width: 2),
                    ),
                  ),
                ),
              ),
              SizedBox(height: hight(context) * 0.024),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: hight(Get.context!) * .007),
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  dropdownColor: Colors.white,
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => selectedCategory = value!),
                  decoration: InputDecoration(
                    labelText: "Category",
                    labelStyle:
                        TextStyle(color: Color(0xFF264653), fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.black, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Color(0xFF264653), width: 2),
                    ),
                  ),
                ),
              ),
              SizedBox(height: hight(context) * 0.024),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: pickTime,
                    child: Card(
                      elevation: 8,
                      color: Colors.grey[100],
                      margin: EdgeInsets.all(4.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Time: ${selectedTime != null ? selectedTime!.format(context) : ''}",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.calendar_today, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: pickDate,
                    child: Card(
                      elevation: 8,
                      color: Colors.grey[100],
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              selectedDate == null
                                  ? "Select Deadline"
                                  : "Deadline: ${selectedDate!.toLocal().toString().split(' ')[0]}",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.access_time, color: Colors.green),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: hight(context) * 0.034),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hight(context) * .1),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF507da0), Color(0xFF507da0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: saveGoal,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      backgroundColor: Color(0xFF507da0),
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      "Save Goal",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
