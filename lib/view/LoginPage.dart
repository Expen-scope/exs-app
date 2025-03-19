import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/LoginController.dart';

class LoginPage extends GetView<LoginController> {
  final _formKey = GlobalKey<FormState>();

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
            key: controller.formKey, // تأكد من استخدام نفس المفتاح
            child: ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                _buildLogo(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                _buildLoginForm(),
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

  Widget _buildLoginForm() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF1e3a4b), width: 2),
        borderRadius: BorderRadius.all(Radius.circular(22)),
      ),
      child: Column(
        children: [
          _buildTextField(
              "Gmail", controller.emailController, "أدخل بريدًا صحيحًا"),
          SizedBox(height: 10),
          _buildPasswordField(),
          SizedBox(height: 20),
          _buildLoginButton(),
          _buildRegisterText(),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController textController,
      String validationMsg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
        SizedBox(height: 5),
        TextFormField(
          controller: textController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return validationMsg;
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password", style: TextStyle(color: Colors.white, fontSize: 16)),
        SizedBox(height: 5),
        Obx(() => TextFormField(
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                suffixIcon: IconButton(
                  icon: Icon(controller.isPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return "أدخل كلمة المرور";
                return null;
              },
            )),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Obx(() => ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            backgroundColor: Color(0xFF2e495e),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: controller.validateInputs,
          child: controller.isLoading.value
              ? CircularProgressIndicator(color: Colors.white)
              : Text("Login",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
        ));
  }

  Widget _buildRegisterText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?", style: TextStyle(color: Colors.white)),
        TextButton(
          onPressed: () => Get.toNamed("/Register"),
          child: Text("Register", style: TextStyle(color: Color(0xFF2e495e))),
        ),
      ],
    );
  }
}
