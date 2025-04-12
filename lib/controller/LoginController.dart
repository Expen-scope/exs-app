import 'dart:async';
import 'dart:convert';
import 'package:abo_najib_2/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/User.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/dialog_helper.dart';
import 'package:http/http.dart' as http;
import '../const/ApiConstants.dart';

class LoginController extends GetxController {
  final Dio _dio = Dio(BaseOptions(
    baseUrl:
        Platform.isAndroid && !Platform.environment.containsKey('FLUTTER_TEST')
            ? 'http://10.0.2.2:8000/api/auth'
            : 'http://127.0.0.1:8000/api/auth',
    contentType: Headers.jsonContentType,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  final _storage = const FlutterSecureStorage();
  final isLoggedIn = false.obs;

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

      if (response.data['authorisation']?['token'] == null) {
        throw Exception('Token not found');
      }

      final user = UserModel.fromJson(response.data);
      await _saveAuthData(user);
      _showSuccessDialog();
    } on DioException catch (e) {
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

    Get.find<UserController>()
      ..user.value = user
      ..isLoggedIn.value = true;

    print('Token saved: ${user.token}');
  }

  void _handleDioError(DioException e) {
    String errorMessage = 'Login failed';

    if (e.response?.statusCode == 401) {
      errorMessage = 'Invalid email or password';
    } else if (e.response?.statusCode == 422) {
      errorMessage = e.response?.data['message'] ?? 'Validation error';
    } else if (e.type == DioExceptionType.connectionTimeout) {
      errorMessage =
          'Connection timeout. Please check your internet connection';
    } else if (e.type == DioExceptionType.connectionError) {
      errorMessage =
          'Unable to connect to the server. Please check your internet connection';
    }

    DialogHelper.showErrorDialog(
      title: 'Login Error',
      message: errorMessage,
    );
  }

  void _handleGenericError(dynamic e) {
    DialogHelper.showErrorDialog(
      title: 'Error',
      message: e.toString(),
    );
  }

  void _showSuccessDialog() {
    DialogHelper.showSuccessDialog(
      title: "success",
      message: "You have been logged in successfully",
        onOkPressed: () =>Get.offAllNamed('/HomePage'),
    );
  }

  Future<void> checkLoginStatus() async {
    final token = await _storage.read(key: 'token');
    isLoggedIn.value = token != null;
  }

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<bool> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        DialogHelper.showErrorDialog(
          title: 'Input Error',
          message: 'Please enter your email and password',
        );
        return false;
      }

      isLoading.value = true;
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = data['user'];

        await _storage.write(key: 'token', value: token);
        await _storage.write(key: 'user', value: jsonEncode(user));

        final userController = Get.find<UserController>();
        userController.user.value = UserModel.fromJson(user);
        return true;
      } else {
        final error = jsonDecode(response.body)['message'];
        DialogHelper.showErrorDialog(
          title: 'Login Failed',
          message: error ?? 'An error occurred during login',
        );
        return false;
      }
    } catch (e) {
      DialogHelper.showErrorDialog(
        title: 'Connection Error',
        message:
            'Unable to connect to the server. Please check your internet connection',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    DialogHelper.showConfirmDialog(
      title: 'Confirm Logout',
      message: 'Are you sure you want to logout?',
      onConfirm: () async {
        await _storage.delete(key: 'token');
        await _storage.delete(key: 'user');
        Get.find<UserController>().user.value = UserModel(
          id: 0,
          name: '',
          email: '',
          token: '',
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        );
        Get.offAllNamed('/login');
      },
    );
  }

  Future<void> changePassword() async {
    DialogHelper.showConfirmDialog(
      title: 'Change Password',
      message: 'Are you sure you want to change your password?',
      onConfirm: () async {
        // Add password change logic here
        DialogHelper.showSuccessDialog(
          title: 'Password Changed',
          message: 'Your password has been changed successfully',
        );
      },
    );
  }
}
