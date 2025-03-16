import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/User.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  String baseUrl = 'http://10.0.2.2:8000/api/auth';

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void validateInputs() {
    if (formKey.currentState!.validate()) {
      loginUser();
    }
  }

  Future<void> loginUser() async {
    isLoading.value = true;
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      print("📡 Status Code: ${response.statusCode}");
      print("🔍 Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        UserModel user = UserModel.fromJson(data);
        Get.snackbar("نجاح", "تم تسجيل الدخول بنجاح");
        Get.offAllNamed('/HomePage');
      } else {
        var errorMessage =
            jsonDecode(response.body)['message'] ?? "فشل تسجيل الدخول";
        Get.snackbar("خطأ", errorMessage);
      }
    } catch (e) {
      print("❌ HTTP Error: $e");
      Get.snackbar("خطأ", "حدث خطأ في الاتصال بالسيرفر");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
