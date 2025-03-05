import 'package:get/get.dart';
import 'package:dio/dio.dart' as Dio;
import '../model/User.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var emailError = RxnString();
  var passwordError = RxnString();
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  Dio.Dio dio =
      Dio.Dio(Dio.BaseOptions(baseUrl: 'https://your-api-url.com/api'));

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void validateInputs() {
    emailError.value =
        email.value.isEmpty ? "يجب إدخال البريد الإلكتروني" : null;
    passwordError.value =
        password.value.isEmpty ? "يجب إدخال كلمة المرور" : null;

    if (emailError.value == null && passwordError.value == null) {
      loginUser();
    }
  }

  Future<void> loginUser() async {
    isLoading.value = true;
    try {
      Dio.Response response = await dio.post(
        '/login',
        data: {
          'email': email.value,
          'password': password.value,
        },
      );

      if (response.statusCode == 200) {
        UserModel user = UserModel.fromJson(response.data);
        Get.snackbar("نجاح", "تم تسجيل الدخول بنجاح");
      } else {
        Get.snackbar("خطأ", response.data['message'] ?? "فشل تسجيل الدخول");
      }
    } on Dio.DioException catch (e) {
      Get.snackbar(
          "خطأ", e.response?.data['message'] ?? "حدث خطأ في الاتصال بالسيرفر");
    } finally {
      isLoading.value = false;
    }
  }
}
