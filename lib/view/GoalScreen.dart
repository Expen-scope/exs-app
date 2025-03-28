import 'package:abo_najib_2/const/AppBarC.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/GoalController.dart';
import '../model/Goal.dart';
import 'EditGoalScreen.dart';
import 'AddGoalScreen.dart';

class GoalsScreen extends StatelessWidget {
  final GoalController goalController = Get.find<GoalController>();

  GoalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "My Goals"),
      body: RefreshIndicator(
        onRefresh: () => goalController.fetchGoals(),
        child: Obx(() {
          if (goalController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (goalController.goals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
              double progress = goal.collectedmoney / goal.price;

              return Card(
                key: ValueKey(goal.id),
                elevation: 5,
                color: Colors.grey[200],
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                          Color(0xFF507da0).withOpacity(0.8),
                        ),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${goal.collectedmoney.toStringAsFixed(0)} / ${goal.price.toStringAsFixed(0)} SAR",
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
                      const SizedBox(height: 8),
                      Text(
                        "Category: ${goal.category}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Deadline: ${goal.time.toLocal().toString().split(' ')[0]}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Color(0xFF264653)),
                    onPressed: () async {
                      bool success = await goalController.deleteGoal(goal.id!);
                      if (success) {
                        Get.snackbar("Success", "Goal deleted successfully",
                            snackPosition: SnackPosition.BOTTOM);
                      } else {
                        Get.snackbar("Error", "Failed to delete goal",
                            snackPosition: SnackPosition.BOTTOM);
                      }
                    },
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddGoalScreen()),
        backgroundColor: const Color(0xFF507da0),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
