import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as Dio;
import '../model/User.dart';

class RegisterController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var nameError = RxnString();
  var emailError = RxnString();
  var passwordError = RxnString();
  var confirmPasswordError = RxnString();
  var isLoading = false.obs;

  final Dio.Dio dio = Dio.Dio(Dio.BaseOptions(
    baseUrl: 'http://10.0.2.2:8000/api/auth',
    contentType: Dio.Headers.jsonContentType,
    validateStatus: (status) => status! < 500,
  ));

  void validateInputs() {
    nameError.value = name.value.isEmpty ? "You must enter the name" : null;

    if (email.value.isEmpty) {
      emailError.value = "You must enter an email";
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(email.value)) {
      emailError.value = "Invalid email format";
    } else {
      emailError.value = null;
    }

    if (password.value.isEmpty) {
      passwordError.value = "You must enter the password";
    } else if (password.value.length < 8) {
      passwordError.value = "Password must be at least 8 characters long.";
    } else {
      passwordError.value = null;
    }

    if (confirmPassword.value.isEmpty) {
      confirmPasswordError.value = "You must enter a password confirmation.";
    } else if (password.value != confirmPassword.value) {
      confirmPasswordError.value = "Passwords do not match";
    } else {
      confirmPasswordError.value = null;
    }
  }

  Future<void> registerUser() async {
    validateInputs();

    if (nameError.value == null &&
        emailError.value == null &&
        passwordError.value == null &&
        confirmPasswordError.value == null) {
      isLoading.value = true;

      try {
        final response = await dio.post(
          '/register',
          data: {
            'name': name.value,
            'email': email.value,
            'password': password.value,
          },
        );

        print('✅ Full Response: ${response.data}');

        if ([200, 201].contains(response.statusCode)) {
          if (response.data == null ||
              response.data['user'] == null ||
              response.data['authorisation'] == null) {
            throw FormatException('The response data is invalid');
          }

          final userData = response.data['user'] as Map<String, dynamic>;
          final authData =
              response.data['authorisation'] as Map<String, dynamic>;

          if (!userData.containsKey('name') || !userData.containsKey('email')) {
            throw FormatException('User data is incomplete');
          }

          final token = authData['token']?.toString() ?? '';

          final user = UserModel(
            id: userData['id'] as int? ?? 0,
            name: userData['name']?.toString() ?? 'unknown',
            email: userData['email']?.toString() ?? 'Unknown email',
            createdAt: userData['created_at']?.toString() ?? '',
            updatedAt: userData['updated_at']?.toString() ?? '',
            token: token,
          );

          showSuccessDialog();
        } else {
          handleServerErrors(response.data);
        }
      } on Dio.DioException catch (e) {
        print('🚨 Dio Error: ${e.message}');
        showErrorDialog(
            "Connection error: ${e.message ?? 'An unknown error has occurred'}");
      } on FormatException catch (e) {
        print('❌ Format Error: $e');
        showErrorDialog("Data format error: ${e.message}");
      } catch (e) {
        print('‼️ Critical Error: $e');
        showErrorDialog("An unexpected error occurred: ${e.toString()}");
      } finally {
        isLoading.value = false;
      }
    }
  }

  void handleServerErrors(Map<String, dynamic>? data) {
    if (data?['errors'] != null) {
      final errors = data!['errors'];

      if (errors.containsKey('email')) {
        emailError.value = errors['email'][0];
      }
      if (errors.containsKey('password')) {
        passwordError.value = errors['password'][0];
      }
      if (errors.containsKey('name')) {
        nameError.value = errors['name'][0];
      }
    } else {
      showErrorDialog(data?['message'] ?? "An unexpected error occurred");
    }
  }

  void showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("success"),
        content: const Text("The account has been created successfully"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/Login');
            },
            child: const Text("OK"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text("Erorr"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Try again"),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
}
