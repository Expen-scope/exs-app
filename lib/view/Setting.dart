import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../const/AppBarC.dart';
import '../const/Constants.dart';
import '../const/Drawer.dart'; // تأكد من إضافة الحزمة

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerClass(
        accountName: 'ss',
        accountEmail: '',
        profileImageUrl: '',
      ),
      appBar: Appbarofpage(TextPage: "Setting"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(hight(context) * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      // إضافة منطق اختيار الصورة
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      // معالجة الصورة المختارة هنا
                    },
                    child: Container(
                      width: width(context) * 0.35,
                      height: width(context) * 0.35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFF507da0),
                          width: 3,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: width(context) * 0.16,
                            backgroundImage: AssetImage(
                                'assets/Photo/me.jpg'), // استبدل بالصورة المختارة
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Color(0xFF507da0),
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: hight(context) * 0.02),
                  Text(
                    'Change your photo',
                    style: TextStyle(
                      color: Color(0xFF507da0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: hight(context) * 0.05),
            Card(
              color: Colors.grey[200],
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(hight(context) * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Change your password',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF264653),
                        ),
                      ),
                    ),
                    SizedBox(height: hight(context) * 0.02),
                    _buildPasswordField(
                      context,
                      label: 'old password',
                      icon: Icons.lock_outline,
                    ),
                    SizedBox(height: hight(context) * 0.02),
                    _buildPasswordField(
                      context,
                      label: 'new password',
                      icon: Icons.lock_reset,
                    ),
                    SizedBox(height: hight(context) * 0.02),
                    _buildPasswordField(
                      context,
                      label: 'confirm password',
                      icon: Icons.lock_clock,
                    ),
                    SizedBox(height: hight(context) * 0.04),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(width(context) * 0.7, 50),
                          backgroundColor: Color(0xFF507da0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        onPressed: () {},
                        child: Text(
                          'Update',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context,
      {required String label, required IconData icon}) {
    return TextFormField(
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF507da0)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF507da0), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }
}
