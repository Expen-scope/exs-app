import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as Dio;
import '../model/User.dart';

class RegisterController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  // var salary = ''.obs;

  var nameError = RxnString();
  var emailError = RxnString();
  var passwordError = RxnString();
  var confirmPasswordError = RxnString();
  var salaryError = RxnString();

  var isLoading = false.obs;

  Dio.Dio dio = Dio.Dio(Dio.BaseOptions(baseUrl: 'http://10.0.2.2:8000/api/auth'));

  void validateInputs() {
    nameError.value = name.value.isEmpty ? "يجب إدخال الاسم" : null;
    emailError.value = email.value.isEmpty ? "يجب إدخال البريد الإلكتروني" : null;
    passwordError.value = password.value.isEmpty ? "يجب إدخال كلمة المرور" : null;
    confirmPasswordError.value = confirmPassword.value.isEmpty ? "يجب إدخال تأكيد كلمة المرور" : null;
    // salaryError.value = salary.value.isEmpty ? "يجب إدخال الراتب" : null;

    if (password.value != confirmPassword.value) {
      confirmPasswordError.value = "كلمات المرور غير متطابقة";
    }
  }

  Future<void> registerUser() async {
    validateInputs();

    if (nameError.value == null &&
        emailError.value == null &&
        passwordError.value == null &&
        confirmPasswordError.value == null &&
        salaryError.value == null) {
      isLoading.value = true;
      try {
        Dio.Response response = await dio.post(
          '/register',
          data: {
            'name': name.value,
            'email': email.value,
            'password': password.value,
            'password_confirmation': confirmPassword.value,
          },
        );

        if (response.statusCode == 201) {
          UserModel user = UserModel.fromJson(response.data);

          // Show success dialog
          Get.dialog(
            AlertDialog(
              title: Text("نجاح"),
              content: Text("تم إنشاء الحساب بنجاح"),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    Get.offAllNamed('/login');
                  },
                  child: Text("موافق"),
                ),
              ],
            ),
            barrierDismissible: false,
          );
        } else {
          // Show error dialog
          Get.dialog(
            AlertDialog(
              title: Text("خطأ"),
              content: Text(response.data['message'] ?? "حدث خطأ أثناء التسجيل"),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back(); // Close the dialog
                  },
                  child: Text("موافق"),
                ),
              ],
            ),
            barrierDismissible: false,
          );
        }
      } on Dio.DioException catch (e) {
        print("❌ Dio Error: ${e.message}");
        print("🔍 Response Data: ${e.response?.data}");
        print("📡 Status Code: ${e.response?.statusCode}");

        // Show error dialog
        Get.dialog(
          AlertDialog(
            title: Text("خطأ"),
            content: Text(e.response?.data['message'] ?? "حدث خطأ في الاتصال بالسيرفر"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close the dialog
                },
                child: Text("موافق"),
              ),
            ],
          ),
          barrierDismissible: false, // Prevent closing the dialog by tapping outside
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}
