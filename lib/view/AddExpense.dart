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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: hight(context) * .02),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: hight(context) * .02),
            TextField(
              controller: valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Expense Value",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: hight(context) * .03),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: [
                "Food & Drinks",
                "Shopping",
                "Housing",
                "Transportation",
                "Vehicle",
                "Others"
              ]
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Select Expense Type",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: hight(context) * .03),
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
