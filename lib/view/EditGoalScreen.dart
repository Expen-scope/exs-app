import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../const/AppBarC.dart';
import '../controller/GoalController.dart';
import '../model/Goal.dart';

class EditGoalScreen extends StatefulWidget {
  final GoalModel goal;

  const EditGoalScreen({Key? key, required this.goal}) : super(key: key);

  @override
  _EditGoalScreenState createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  final GoalController goalController = Get.find();
  final TextEditingController collectedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // تهيئة الحقل بالقيمة الحالية مع تحديد منزلتين عشريتين
    collectedController.text = widget.goal.collectedmoney!.toStringAsFixed(2);
  }

  void updateGoal() async {
    try {
      double collected = double.tryParse(collectedController.text) ??
          widget.goal.collectedmoney!;

      // إنشاء نسخة محدثة من الهدف
      GoalModel updatedGoal = widget.goal.copyWith(
        collectedmoney: collected,
      );

      // استدعاء دالة التحديث مع تمرير المعرف الصحيح
      bool success =
          await goalController.updateGoal(widget.goal.id!, updatedGoal);

      if (success) {
        Get.back(); // العودة للشاشة السابقة عند النجاح
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update goal: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "Edit Goal"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Editing: ${widget.goal.name}",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800]),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: collectedController,
              decoration: InputDecoration(
                labelText:
                    "Saved Amount (${widget.goal.price! - widget.goal.collectedmoney!} remaining)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.attach_money, color: Colors.blue[800]),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: updateGoal,
                icon: Icon(Icons.update, color: Colors.white),
                label: Text("Update Progress", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
