import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/User.dart';
import 'dart:convert';

class UserController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = true.obs;
  var selectedImage = Rx<File?>(null);
  late SharedPreferences _prefs;
  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await initializeUser();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
      await _saveToPrefs();
    }
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      String? userData = _prefs.getString('user_data');
      String? token = _prefs.getString('auth_token');
      if (userData != null && token != null) {
        user.value = UserModel.fromJson(json.decode(userData));
        isLoggedIn.value = true;
        print('User data loaded: ${user.value?.name}');
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initializeUser() async {
    try {
      isLoading.value = true;
      bool rememberMe = _prefs.getBool('remember_me') ?? false;

      if (rememberMe) {
        await loadUserData();

        if (isLoggedIn.value) {
          bool isValid = await _verifyTokenWithServer();
          if (!isValid) {
            await clearUserData();
            isLoggedIn.value = false;
            Get.offAllNamed('/Login');
          } else {
            Get.offAllNamed('/HomePage');
          }
        }
      }
    } catch (e) {
      await clearUserData();
      Get.offAllNamed('/Login');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _verifyTokenWithServer() async {
    try {
      final response = await _dio.get(
        'http://10.0.2.2:8000/api/verify-token',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_prefs.getString('auth_token')}',
          },
        ),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return await _refreshToken();
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final response = await _dio.post(
        'http://10.0.2.2:8000/api/refresh',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_prefs.getString('auth_token')}',
          },
        ),
      );

      if (response.statusCode == 200) {
        String newToken = response.data['authorisation']['token'];
        await _prefs.setString('auth_token', newToken);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearUserData() async {
    try {
      await _prefs.remove('auth_token');
      await _prefs.remove('user_data');
      await _prefs.remove('remember_me');
      user.value = null;
      isLoggedIn.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to clear data: $e');
    }
  }

  Future<void> updateProfileImage(String imagePath) async {
    try {
      if (user.value != null) {
        selectedImage.value = File(imagePath);
        await _saveToPrefs();
        update();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      if (user.value != null) {
        await _prefs.setString('user_data', json.encode(user.value!.toJson()));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save data: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'http://10.0.2.2:8000/api/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        String token = response.data['authorisation']['token'];
        UserModel userData = UserModel.fromJson(response.data['user']);

        await _prefs.setString('auth_token', token);
        await _prefs.setBool('remember_me', true);
        await _prefs.setString('user_data', json.encode(userData.toJson()));

        user.value = userData;
        isLoggedIn.value = true;
        Get.offAllNamed('/HomePage');
      }
    } on DioException catch (e) {
      String errorMessage = 'Login failed';
      if (e.response?.statusCode == 401) {
        errorMessage = 'Invalid email or password';
      }
      Get.snackbar('Error', errorMessage);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    }
  }
}
