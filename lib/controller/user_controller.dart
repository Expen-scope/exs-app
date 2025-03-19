import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/User.dart';
import 'dart:convert';

class UserController extends GetxController {
  Rx<UserModel?> user = Rx<UserModel?>(null);

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user_data');
    if (userData != null) {
      user.value = UserModel.fromJson(json.decode(userData));
    }
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    user.value = null;
  }
}
