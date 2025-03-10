import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../model/Goal.dart';

class GoalService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://abo-najib.test/"));

  Future<List<GoalModel>> fetchGoals() async {
    final response = await _dio.get("/goals");
    return (response.data as List)
        .map((goal) => GoalModel.fromJson(goal))
        .toList();
  }

  Future<void> addGoal(GoalModel goal) async {
    await _dio.post("/goals", data: goal.toJson());
  }

  Future<void> updateGoal(int id, double savedAmount) async {
    await _dio.put("/goals/$id", data: {"savedAmount": savedAmount});
  }
}
