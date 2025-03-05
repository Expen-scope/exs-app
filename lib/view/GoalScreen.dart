import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/AppBarC.dart';
import '../controller/GoalController.dart';
import '../model/Goal.dart';
import 'EditGoalScreen.dart';

class GoalsScreen extends StatelessWidget {
  final GoalController goalController = Get.put(GoalController());

  GoalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "My Goals"),
      body: Obx(() {
        if (goalController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (goalController.goals.isEmpty) {
          return const Center(child: Text("No goals added yet!"));
        }

        return ListView.builder(
          itemCount: goalController.goals.length,
          itemBuilder: (context, index) {
            GoalModel goal = goalController.goals[index];
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(goal.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle:
                    Text("Saved: ${goal.savedAmount} / ${goal.totalAmount}"),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Get.to(() => EditGoalScreen(goal: goal, goalIndex: index));
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
