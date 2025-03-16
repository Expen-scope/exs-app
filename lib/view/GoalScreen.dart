import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/AppBarC.dart';
import '../controller/GoalController.dart';
import '../model/Goal.dart';
import 'EditGoalScreen.dart';
import 'AddGoalScreen.dart'; // تأكد من استيراد AddGoalScreen

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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/goals.png', height: 150),
                const SizedBox(height: 20),
                Text(
                  "Start Achieving Your Dreams!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: goalController.goals.length,
          itemBuilder: (context, index) {
            GoalModel goal = goalController.goals[index];
            double progress = goal.savedAmount / goal.totalAmount;

            return Card(
              key: ValueKey(goal.id),
              elevation: 5,
              color: Colors.grey[200],
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(15),
                title: Text(
                  goal.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF264653),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[400],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFF507da0).withOpacity(0.8),
                      ),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${goal.savedAmount.toStringAsFixed(0)} / ${goal.totalAmount.toStringAsFixed(0)} SAR",
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${(progress * 100).toStringAsFixed(1)}%",
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFF264653)),
                  onPressed: () {
                    Get.to(() => EditGoalScreen(goal: goal, goalIndex: index));
                  },
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddGoalScreen()),
        backgroundColor: Color(0xFF507da0),
        child: Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
