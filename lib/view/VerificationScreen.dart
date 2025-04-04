import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class VerificationScreen extends StatelessWidget {
  final String email;

  VerificationScreen({required this.email});

  final TextEditingController _codeController = TextEditingController();

  void _verifyCode() async {
    try {
      final response = await Dio().post(
        'http://10.0.2.2:8000/api/verify-code',
        data: {
          'email': email,
          'code': _codeController.text,
        },
      );

      if (response.statusCode == 200) {
        Get.offAllNamed('/login');
        Get.snackbar('Success', 'Account activated!');
      }
    } on DioException catch (e) {
      // حدد DioException هنا
      String errorMessage = 'Unknown error';
      if (e.response != null) {
        errorMessage = e.response!.data['message'] ?? 'Server error';
      } else {
        errorMessage = 'Network error: ${e.message}';
      }
      Get.snackbar('Error', errorMessage);
    } catch (e) {
      Get.snackbar('Error', 'Unexpected error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify Code')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Verification Code'),
            ),
            ElevatedButton(
              onPressed: _verifyCode,
              child: Text('Verify'),
            )
          ],
        ),
      ),
    );
  }
}
