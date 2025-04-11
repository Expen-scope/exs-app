import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../const/AppBarC.dart';
import '../const/Constants.dart';
import '../const/Drawer.dart';
import '../controller/user_controller.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final UserController controller = Get.put(UserController());
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
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
                    onTap: controller.pickImage,
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
                          Obx(() => CircleAvatar(
                                radius: width(context) * 0.16,
                                backgroundImage: controller
                                            .selectedImage.value !=
                                        null
                                    ? FileImage(controller.selectedImage.value!)
                                        as ImageProvider
                                    : const AssetImage('assets/Photo/me.jpg'),
                              )),
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
                              child: const Icon(
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
                  Obx(() {
                    return controller.selectedImage.value != null
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(width(context) * 0.2, 50),
                              backgroundColor: Color(0xFF507da0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                            onPressed: () async {
                              await controller.updateProfileImage(
                                  controller.selectedImage.value!.path);
                              Get.snackbar('Success',
                                  'Profile image updated successfully');
                            },
                            child: Text(
                              'Change your photo',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )
                        : SizedBox.shrink();
                  }),
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
                      controller: _oldPasswordController,
                    ),
                    SizedBox(height: hight(context) * 0.02),
                    _buildPasswordField(
                      context,
                      label: 'new password',
                      icon: Icons.lock_reset,
                      controller: _newPasswordController,
                    ),
                    SizedBox(height: hight(context) * 0.02),
                    _buildPasswordField(
                      context,
                      label: 'confirm password',
                      icon: Icons.lock_clock,
                      controller: _confirmPasswordController,
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
                        onPressed: () async {
                          if (_oldPasswordController.text.isEmpty ||
                              _newPasswordController.text.isEmpty ||
                              _confirmPasswordController.text.isEmpty) {
                            Get.snackbar('Error', 'Please fill all fields',
                                snackPosition: SnackPosition.BOTTOM);
                            return;
                          }
                          if (_newPasswordController.text !=
                              _confirmPasswordController.text) {
                            Get.snackbar('Error', 'Passwords do not match',
                                snackPosition: SnackPosition.BOTTOM);
                            return;
                          }
                          await controller.changePassword(
                            currentPassword: _oldPasswordController.text,
                            newPassword: _newPasswordController.text,
                          );
                        },
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

  Widget _buildPasswordField(
    BuildContext context, {
    required String label,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return TextFormField(
      cursorColor: Color(0xFF264653),
      controller: controller,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF507da0)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF507da0), width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }
}
