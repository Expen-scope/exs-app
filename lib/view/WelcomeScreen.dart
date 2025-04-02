import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

const Color primaryDarkColor = Color(0xFF2e495e);
const Color primaryLightColor = Color(0xFF507da0);
const Color whiteColor = Colors.white;

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryDarkColor, primaryLightColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Image.asset('assets/Photo/Personal finance-bro.png'),
                    const SizedBox(height: 30),
                    Text(
                      'Welcome to Abo Najib',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Managing money has never been easier.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: whiteColor.withOpacity(0.85),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    _buildAuthButton(
                      context: context,
                      label: 'Login',
                      onPressed: () {
                        Get.offAllNamed('/Login');
                      },
                      backgroundColor: whiteColor,
                      textColor: primaryDarkColor,
                    ),
                    const SizedBox(height: 15),
                    _buildAuthButton(
                      context: context,
                      label: 'Register',
                      onPressed: () {
                        Get.toNamed("/Register");
                      },
                      backgroundColor: Colors.transparent,
                      textColor: whiteColor,
                      borderColor: whiteColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء أزرار متجانسة
  Widget _buildAuthButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: borderColor != null
                ? BorderSide(color: borderColor, width: 1.5)
                : BorderSide.none,
          ),
          elevation: backgroundColor == Colors.transparent ? 0 : 5,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
