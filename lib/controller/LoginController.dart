import 'dart:async';
import 'dart:convert';
import 'package:abo_najib_2/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/User.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000/api/auth',
    contentType: Headers.jsonContentType,
  ));

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() => isPasswordVisible.toggle();

  void validateInputs() {
    if (formKey.currentState!.validate()) loginUser();
  }

  Future<void> loginUser() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;

    try {
      final response = await _dio.post(
        '/login',
        data: {
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      // 3. التحقق من هيكل البيانات
      if (response.data['authorisation']?['token'] == null) {
        throw Exception('Token not found');
      }

      // 4. استخدام UserModel بشكل صحيح
      final user = UserModel.fromJson(response.data);
      await _saveAuthData(user);

      _showSuccessDialog();
    } on DioException catch (e) {
      // 5. معالجة مفصلة لأخطاء Dio
      _handleDioError(e);
    } catch (e) {
      _handleGenericError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveAuthData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', user.token);
    await prefs.setString('user_data', json.encode(user.toJson()));
    Get.find<UserController>().user.value = user; // تحديث الـ UserController
  }

  void _handleDioError(DioException e) {
    final errorMessage =
        e.response?.data?['message'] ?? e.message ?? 'فشل تسجيل الدخول';

    Get.dialog(
      AlertDialog(
        title: const Text("خطأ", style: TextStyle(color: Colors.red)),
        content: Text(_parseDioError(e)),
        actions: [TextButton(onPressed: Get.back, child: const Text("موافق"))],
      ),
    );
  }

  String _parseDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'انتهى وقت الاتصال';
      case DioExceptionType.badResponse:
        return e.response?.data?['message'] ?? 'خطأ في بيانات الاعتماد';
      case DioExceptionType.unknown:
        return 'خطأ في الاتصال بالخادم';
      default:
        return 'خطأ غير متوقع';
    }
  }

  void _handleGenericError(dynamic e) {
    Get.dialog(
      AlertDialog(
        title: const Text("خطأ"),
        content: Text(e.toString()),
        actions: [TextButton(onPressed: Get.back, child: const Text("موافق"))],
      ),
    );
  }

  void _showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("نجاح", style: TextStyle(color: Colors.green)),
        content: const Text("تم تسجيل الدخول بنجاح"),
        actions: [
          TextButton(
            onPressed: () => Get.offAllNamed('/HomePage'),
            child: const Text("موافق"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
