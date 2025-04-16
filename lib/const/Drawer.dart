import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/user_controller.dart';
import '../view/ReminderPage.dart';
import 'Constants.dart';

class CustomDrawer extends StatelessWidget {
  final UserController controller = Get.put(UserController());
  CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return Drawer(
      child: Column(
        children: [
          Obx(() => UserAccountsDrawerHeader(
                accountName: Text(
                  userController.user.value?.name ?? 'Guest',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  userController.user.value?.email ?? 'No email',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  radius: width(context) * 0.16,
                  backgroundImage: controller.selectedImage.value != null
                      ? FileImage(controller.selectedImage.value!)
                          as ImageProvider
                      : const AssetImage('assets/Photo/me.jpg'),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF2e495e),
                ),
              )),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.access_alarm,
                  title: 'Reminders',
                  route: () => Get.to(() => Reminders()),
                ),
                _buildDrawerItem(
                  icon: Icons.flag,
                  title: 'Goals',
                  route: () => Get.toNamed("/Goals"),
                ),
                _buildDrawerItem(
                  icon: Icons.attach_money,
                  title: 'Incomes',
                  route: () => Get.toNamed("/IncomesScreens"),
                ),
                _buildDrawerItem(
                  icon: Icons.money_off,
                  title: 'Expenses',
                  route: () => Get.toNamed("/ExpencesScreens"),
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  route: () => Get.toNamed("/Setting"),
                ),
                const Divider(height: 20),
                _buildDrawerItem(
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

  Widget _buildProfileImage(UserController userController) {
    return GestureDetector(
      onTap: () async => await _handleImageUpdate(userController),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: _getProfileImage(userController),
            ),
            Positioned(
              bottom: 0,
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
    );
  }

  ImageProvider _getProfileImage(UserController userController) {
    if (userController.user.value?.profileImageUrl?.isNotEmpty == true) {
      return controller.selectedImage.value != null
          ? FileImage(controller.selectedImage.value!) as ImageProvider
          : const AssetImage('assets/Photo/me.jpg');
    }
    return const AssetImage('assets/Photo/me.jpg');
  }

  Future<void> _handleImageUpdate(UserController userController) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      userController.updateProfileImage(image.path);
    }
  }

  Widget _buildDrawerItem({
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
              Get.toNamed("/Login");
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
}
