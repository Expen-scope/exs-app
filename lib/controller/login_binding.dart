import 'package:get/get.dart';
import '../controller/LoginController.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
