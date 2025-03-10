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

  Dio.Dio dio =
      Dio.Dio(Dio.BaseOptions(baseUrl: 'http://abo-najib.test/api/auth'));

  void validateInputs() {
    nameError.value = name.value.isEmpty ? "يجب إدخال الاسم" : null;
    emailError.value =
        email.value.isEmpty ? "يجب إدخال البريد الإلكتروني" : null;
    passwordError.value =
        password.value.isEmpty ? "يجب إدخال كلمة المرور" : null;
    confirmPasswordError.value =
        confirmPassword.value.isEmpty ? "يجب إدخال تأكيد كلمة المرور" : null;
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
            // 'salary': salary.value,
          },
        );

        if (response.statusCode == 201) {
          UserModel user = UserModel.fromJson(response.data);
          Get.snackbar("نجاح", "تم إنشاء الحساب بنجاح");
          Get.offAllNamed('/login'); // توجيه المستخدم إلى صفحة تسجيل الدخول
        } else {
          Get.snackbar(
              "خطأ", response.data['message'] ?? "حدث خطأ أثناء التسجيل");
        }

      } on Dio.DioException catch (e) {
    print("❌ Dio Error: ${e.message}");
    print("🔍 Response Data: ${e.response?.data}");
    print("📡 Status Code: ${e.response?.statusCode}");
    Get.snackbar("خطأ", e.response?.data['message'] ?? "حدث خطأ في الاتصال بالسيرفر");
    }


    // on Dio.DioException catch (e) {
      //   Get.snackbar("خطأ",
      //       e.response?.data['message'] ?? "حدث خطأ في الاتصال بالسيرفر");
      // }
      finally {
        isLoading.value = false;
      }
    }
  }
}
