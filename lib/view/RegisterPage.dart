import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/RegisterController.dart';

class RegisterPage extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2e495e), Color(0xFF507da0)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
          child: Form(
            key: _formKey, // Use the GlobalKey only here for this Form
            child: ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                _buildLogo(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                _buildRegisterForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text("أبو نجيب",
                style: TextStyle(fontSize: 26, color: Colors.white)),
            Text("ABO NAJIB",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: "Tajawal-Bold.ttf")),
          ],
        ),
        Image.asset('assets/Photo/khader (1).png', height: 160),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF1e3a4b), width: 2),
        borderRadius: BorderRadius.all(Radius.circular(22)),
      ),
      child: Column(
        children: [
          _buildTextField("Enter your name",
              (val) => controller.name.value = val, controller.nameError),
          SizedBox(height: 10),
          _buildTextField("Enter Gmail", (val) => controller.email.value = val,
              controller.emailError),
          SizedBox(height: 10),
          // _buildTextField("Enter your Salary", (val) => controller.salary.value = val, controller.salaryError, keyboardType: TextInputType.number),
          SizedBox(height: 10),
          _buildTextField(
              "Enter Password",
              (val) => controller.password.value = val,
              controller.passwordError,
              obscureText: true),
          SizedBox(height: 10),
          _buildTextField(
              "Confirm Password",
              (val) => controller.confirmPassword.value = val,
              controller.confirmPasswordError,
              obscureText: true),
          SizedBox(height: 20),
          _buildRegisterButton(),
          _buildLoginText(),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label, Function(String) onChanged, RxnString errorText,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
        SizedBox(height: 5),
        Obx(() => TextFormField(
              obscureText: obscureText
                  ? (label == "Enter Password"
                      ? !controller.isPasswordVisible.value
                      : !controller.isConfirmPasswordVisible.value)
                  : false, // تحديد حالة إظهار كلمة السر بناءً على الحقل
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: label,
                errorText: errorText.value,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF264653), width: 2),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                suffixIcon: label.contains(
                        "Password") // إضافة الأيقونة فقط في الحقول المرتبطة بكلمة السر
                    ? IconButton(
                        icon: Icon(
                          (label == "Enter Password"
                                  ? controller.isPasswordVisible.value
                                  : controller.isConfirmPasswordVisible.value)
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: label == "Enter Password"
                            ? controller.togglePasswordVisibility
                            : controller.toggleConfirmPasswordVisibility,
                      )
                    : null,
              ),
              onChanged: onChanged,
            )),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Obx(() => ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            backgroundColor: Color(0xFF2e495e),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed:
              controller.isLoading.value ? null : controller.registerUser,
          child: controller.isLoading.value
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : Text("Register",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
        ));
  }

  Widget _buildLoginText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account?", style: TextStyle(color: Colors.white)),
        TextButton(
          onPressed: () => Get.toNamed("/Login"),
          child: Text("Login", style: TextStyle(color: Color(0xFF2e495e))),
        ),
      ],
    );
  }
}
