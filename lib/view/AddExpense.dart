import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/AppBarC.dart';
import '../const/Constants.dart';
import '../controller/ExpensesController.dart';
import '../model/Expenses.dart';

class AddExpences extends StatefulWidget {
  const AddExpences({super.key});

  @override
  State<AddExpences> createState() => _AddExpencesState();
}

class _AddExpencesState extends State<AddExpences> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  String selectedType = "Shopping";
  final ExpencesController controller = Get.find();

  @override
  void dispose() {
    nameController.dispose();
    valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "Add Expences"),
      body: Padding(
        padding: EdgeInsets.all(hight(context) * .019),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: hight(context) * 0.025),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: hight(Get.context!) * .007),
              child: TextField(
                cursorColor: Color(0xFF264653),
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Color(0xFF264653), fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF264653), width: 2),
                  ),
                ),
              ),
            ),
            SizedBox(height: hight(context) * 0.024),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: hight(Get.context!) * .007),
              child: TextField(
                cursorColor: Color(0xFF264653),
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter Expense Value",
                  labelStyle: TextStyle(color: Color(0xFF264653), fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF264653), width: 2),
                  ),
                ),
              ),
            ),
            SizedBox(height: hight(context) * 0.024),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: hight(Get.context!) * .007),
              child: DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: selectedType,
                items: [
                  "Food & Drinks",
                  "Shopping",
                  "Housing",
                  "Transportation",
                  "Vehicle",
                  "Others"
                ]
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Select Expense Type",
                  labelStyle: TextStyle(color: Color(0xFF264653), fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF264653), width: 2),
                  ),
                ),
              ),
            ),
            SizedBox(height: hight(context) * 0.034),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hight(context) * .1),
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      valueController.text.isNotEmpty) {
                    Expense expense = Expense(
                      name: nameController.text,
                      value: double.parse(valueController.text),
                      type: selectedType,
                      date: DateTime.now().toString(),
                    );
                    controller.addExpense(expense);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                  backgroundColor: Color(0xFF507da0),
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
