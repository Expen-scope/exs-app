import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as Dio;
import '../model/User.dart';

class RegisterController extends GetxController {
  // ملاحظة: تم الحفاظ على جميع المتغيرات كما هي
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var nameError = RxnString();
  var emailError = RxnString();
  var passwordError = RxnString();
  var confirmPasswordError = RxnString();
  var isLoading = false.obs;

  // التعديل 1: إضافة content-type لتحديد شكل البيانات المرسلة
  final Dio.Dio dio = Dio.Dio(Dio.BaseOptions(
    baseUrl: 'http://10.0.2.2:8000/api/auth',
    contentType:
        Dio.Headers.jsonContentType, // إضافة مهمة لتوضيح أننا نرسل JSON
  ));

  void validateInputs() {
    // نفس المنطق السابق
    nameError.value = name.value.isEmpty ? "يجب إدخال الاسم" : null;
    emailError.value =
        email.value.isEmpty ? "يجب إدخال البريد الإلكتروني" : null;
    passwordError.value =
        password.value.isEmpty ? "يجب إدخال كلمة المرور" : null;
    confirmPasswordError.value =
        confirmPassword.value.isEmpty ? "يجب إدخال تأكيد كلمة المرور" : null;

    if (password.value != confirmPassword.value) {
      confirmPasswordError.value = "كلمات المرور غير متطابقة";
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
        Dio.Response response = await dio.post(
          '/register',
          data: {
            'name': name.value,
            'email': email.value,
            'password': password.value,
          },
        );

        // التعديل 2: تعديل طريقة استخراج بيانات المستخدم حسب الرد من API
        if (response.statusCode == 201) {
          UserModel user = UserModel.fromJson(
              response.data['user']); // استخراج من مفتاح 'user'
          showSuccessDialog();
        } else {
          showErrorDialog(response.data['message'] ?? "حدث خطأ أثناء التسجيل");
        }
      } on Dio.DioException catch (e) {
        // التعديل 3: تحسين رسائل الخطأ للتسجيل
        print("❌ Dio Error: ${e.message}");
        print("🔍 Response Data: ${e.response?.data}");
        print("📡 Status Code: ${e.response?.statusCode}");
        showErrorDialog(
            e.response?.data['message'] ?? "حدث خطأ في الاتصال بالسيرفر");
      } finally {
        isLoading.value = false;
      }
    }
  }

  void showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("نجاح"),
        content: const Text("تم إنشاء الحساب بنجاح"),
        actions: [
          TextButton(
            onPressed: () => Get.back(canPop: false),
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
        title: const Text("error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("ok"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
