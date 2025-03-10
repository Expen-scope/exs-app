import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/AppBarC.dart';
import '../controller/GoalController.dart';
import '../model/Goal.dart';

class EditGoalScreen extends StatefulWidget {
  final GoalModel goal;
  final int goalIndex;

  const EditGoalScreen({Key? key, required this.goal, required this.goalIndex})
      : super(key: key);

  @override
  _EditGoalScreenState createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  final GoalController goalController = Get.find();
  final TextEditingController savedAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    savedAmountController.text = widget.goal.savedAmount.toString();
  }

  void updateGoal() {
    double savedAmount = double.tryParse(savedAmountController.text) ?? widget.goal.savedAmount;
    GoalModel updatedGoal = widget.goal.copyWith(savedAmount: savedAmount);
    goalController.updateGoal(widget.goal.id, updatedGoal);
    Get.back(); // الرجوع للشاشة السابقة
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "Edit Goal"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Goal: ${widget.goal.name}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: savedAmountController,
              decoration: const InputDecoration(labelText: "Saved Amount"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: updateGoal, child: const Text("Update Goal")),
          ],
        ),
      ),
    );
  }
}
