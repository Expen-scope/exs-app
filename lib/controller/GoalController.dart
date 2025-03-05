import 'package:get/get.dart';

import '../model/Goal.dart';
import '../servises/ModelServes.dart';

class GoalController extends GetxController {
  final GoalService _goalService = GoalService();
  var goals = <GoalModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchGoals();
    super.onInit();
  }

  void fetchGoals() async {
    isLoading.value = true;
    try {
      goals.value = await _goalService.fetchGoals();
    } finally {
      isLoading.value = false;
    }
  }

  void addGoal(GoalModel goal) async {
    await _goalService.addGoal(goal);
    fetchGoals(); // تحديث القائمة بعد الإضافة
  }

  void updateGoal(int index, double savedAmount) async {
    await _goalService.updateGoal(index, savedAmount);
    fetchGoals();
  }
}
