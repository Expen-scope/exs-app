import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/AppBarC.dart';
import '../controller/ExpensesController.dart';
import '../model/Expenses.dart';

class AddExpences extends StatelessWidget {
  const AddExpences({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController valueController = TextEditingController();
    String selectedType = "Shopping";

    final ExpencesController controller = Get.find();

    return Scaffold(
      appBar: Appbarofpage(TextPage: "Add Expences"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Expense Value",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
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
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                selectedType = value!;
              },
              decoration: InputDecoration(
                labelText: "Select Expense Type",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (valueController.text.isNotEmpty) {
                  Expense expense = Expense(
                    value: double.parse(valueController.text),
                    type: selectedType,
                    date: DateTime.now().toString(),
                  );
                  controller.addExpense(expense);
                  Navigator.pop(context);
                }
              },
              child: Text("Add Expense"),
            ),
          ],
        ),
      ),
    );
  }
}
