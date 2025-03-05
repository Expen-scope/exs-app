import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/RegisterController.dart';

class RegisterPage extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2e495e), Color(0xFF507da0)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: [
                  SizedBox(height: 50),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "أبو نجيب",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                        Text(
                          "ABO NAJIB",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Gmail',
                      errorText: controller.emailError.value,
                    ),
                    onChanged: (value) => controller.email.value = value,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      errorText: controller.passwordError.value,
                    ),
                    onChanged: (value) => controller.password.value = value,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      errorText: controller.confirmPasswordError.value,
                    ),
                    onChanged: (value) =>
                        controller.confirmPassword.value = value,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      errorText: controller.nameError.value,
                    ),
                    onChanged: (value) => controller.name.value = value,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => controller.registerUser(),
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Register'),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("لديك حساب؟ "),
                      GestureDetector(
                        onTap: () => Get.toNamed('/login'),
                        child: Text(
                          "تسجيل الدخول",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
