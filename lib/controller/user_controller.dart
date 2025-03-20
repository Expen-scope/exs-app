import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/User.dart';
import 'dart:convert';

class UserController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = true.obs;

  late SharedPreferences _prefs;

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      String? userData = _prefs.getString('user_data');
      if (userData != null) {
        user.value = UserModel.fromJson(json.decode(userData));
        isLoggedIn.value = true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data: $e');
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
          }
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Initialization failed: $e');
      await clearUserData();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _verifyTokenWithServer() async {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearUserData() async {
    try {
      await _prefs.remove('user_data');
      await _prefs.remove('remember_me');
      user.value = null;
      isLoggedIn.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to clear data: $e');
    }
  }

  Future<void> updateProfileImage(String imageUrl) async {
    try {
      if (user.value != null) {
        user.value = user.value!.copyWith(profileImageUrl: imageUrl);
        await _saveToPrefs();
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
}