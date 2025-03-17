import 'dart:async';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;

    try {
      final response = await http
          .post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      )
          .timeout(Duration(seconds: 10));

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = responseBody['token']; // استخراج التوكن من الاستجابة

        if (token != null) {
          await _saveToken(token); // حفظ التوكن في SharedPreferences
          UserModel user = UserModel.fromJson(responseBody);
          _showSuccessDialog();
        } else {
          // إذا لم يكن هناك توكن في الاستجابة، عرض الخطأ المناسب
          _handleErrorResponse({"message": "Token not found in response"});
        }
      } else {
        // استجابة غير صحيحة، استخدم الرسالة التي يرجعها السيرفر
        _handleErrorResponse(responseBody);
      }
    } on http.ClientException catch (e) {
      _handleNetworkError(e.message ?? 'خطأ في الاتصال بالإنترنت');
    } on TimeoutException {
      _handleNetworkError('انتهى وقت الانتظار');
    } on FormatException {
      _handleNetworkError('خطأ في تنسيق البيانات');
    } catch (e) {
      print('$e');
      _handleNetworkError('خطأ غير متوقع');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token); // حفظ التوكن في SharedPreferences
  }

  void _showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("نجاح", style: TextStyle(color: Colors.green)),
        content: Text("تم تسجيل الدخول بنجاح"),
        actions: [
          TextButton(
            onPressed: () => Get.offAllNamed('/HomePage'),
            child: Text("موافق"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _handleErrorResponse(dynamic responseBody) {
    final error = responseBody['message'] ?? "فشل تسجيل الدخول";  // استخدم رسالة الخطأ من الاستجابة الفعلية
    Get.dialog(
      AlertDialog(
        title: Text("خطأ", style: TextStyle(color: Colors.red)),
        content: Text(error),
        actions: [TextButton(onPressed: Get.back, child: Text("موافق"))],
      ),
    );
  }

  void _handleNetworkError(String message) {
    Get.dialog(
      AlertDialog(
        title: Text("خطأ اتصال"),
        content: Text(message),
        actions: [TextButton(onPressed: Get.back, child: Text("موافق"))],
      ),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
