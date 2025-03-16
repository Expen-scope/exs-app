import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../view/ReminderPage.dart';

class DrawerClass extends StatelessWidget {
  final String accountName;
  final String accountEmail;
  final String profileImageUrl;

  const DrawerClass({
    super.key,
    required this.accountName,
    required this.accountEmail,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            accountName: Text(
              'kheder',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              'kheder@gmail.com',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            currentAccountPicture: GestureDetector(
              onTap: () async {
                // إضافة منطق تغيير الصورة
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                );
                // معالجة الصورة هنا
              },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.black,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : const AssetImage('assets/Photo/me.jpg')
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: -0.3,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
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
                          color: Color(0xFF2e495e),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF2e495e),
              image: const DecorationImage(
                image: AssetImage('assets/drawer_bg.png'),
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
          ),
          // List Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.access_alarm,
                  title: 'Reminders',
                  route: () => Get.to(Reminders()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.flag,
                  title: 'Goals',
                  route: () => Get.toNamed("/Goals"),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.attach_money,
                  title: 'Incomes',
                  route: () => Get.toNamed("/IncomesScreens"),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.money_off,
                  title: 'Expenses',
                  route: () => Get.toNamed("/ExpencesScreens"),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  route: () => Get.toNamed("/Setting"),
                ),
                const Divider(height: 20),
                _buildDrawerItem(
                  context,
                  icon: Icons.logout,
                  title: 'Log Out',
                  color: Colors.red,
                  route: () => _showLogoutDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Function() route,
    Color? color,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color?.withOpacity(0.1) ??
              const Color(0xFF2e495e).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color ?? const Color(0xFF2e495e)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color ?? Colors.grey[800],
        ),
      ),
      onTap: route,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      visualDensity: const VisualDensity(vertical: 0),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await logoutUser();
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Logout failed: ${e.toString()}');
    }
  }
}
