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
    nameError.value = name.value.isEmpty ? "يجب إدخال الاسم" : null;

    if (email.value.isEmpty) {
      emailError.value = "يجب إدخال البريد الإلكتروني";
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(email.value)) {
      emailError.value = "صيغة البريد الإلكتروني غير صحيحة";
    } else {
      emailError.value = null;
    }

    if (password.value.isEmpty) {
      passwordError.value = "يجب إدخال كلمة المرور";
    } else if (password.value.length < 8) {
      passwordError.value = "كلمة المرور يجب أن تكون 8 أحرف على الأقل";
    } else {
      passwordError.value = null;
    }

    if (confirmPassword.value.isEmpty) {
      confirmPasswordError.value = "يجب إدخال تأكيد كلمة المرور";
    } else if (password.value != confirmPassword.value) {
      confirmPasswordError.value = "كلمات المرور غير متطابقة";
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

        // طباعة الرد الكامل للتشخيص
        print('✅ Full Response: ${response.data}');

        if ([200, 201].contains(response.statusCode)) {
          // 1. التحقق من وجود البيانات الأساسية
          if (response.data == null ||
              response.data['user'] == null ||
              response.data['authorisation'] == null) {
            throw FormatException('بيانات الاستجابة غير صالحة');
          }

          final userData = response.data['user'] as Map<String, dynamic>;
          final authData =
              response.data['authorisation'] as Map<String, dynamic>;

          // 2. التحقق من الحقول المطلوبة
          if (!userData.containsKey('name') || !userData.containsKey('email')) {
            throw FormatException('بيانات المستخدم ناقصة');
          }

          // 3. معالجة التوكن بشكل آمن
          final token = authData['token']?.toString() ?? '';

          // 4. إنشاء النموذج مع القيم الافتراضية
          final user = UserModel(
            id: userData['id'] as int? ?? 0,
            name: userData['name']?.toString() ?? 'غير معروف',
            email: userData['email']?.toString() ?? 'بريد إلكتروني غير معروف',
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
        showErrorDialog("خطأ في الاتصال: ${e.message ?? 'حدث خطأ غير معروف'}");
      } on FormatException catch (e) {
        print('❌ Format Error: $e');
        showErrorDialog("خطأ في تنسيق البيانات: ${e.message}");
      } catch (e) {
        print('‼️ Critical Error: $e');
        showErrorDialog("حدث خطأ غير متوقع: ${e.toString()}");
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
      showErrorDialog(data?['message'] ?? "حدث خطأ غير متوقع");
    }
  }

  void showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("نجاح"),
        content: const Text("تم إنشاء الحساب بنجاح"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/Login'); // التوجيه بعد الإغلاق
            },
            child: const Text("موافق"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text("خطأ"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("حاول مجدداً"),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
}
