import 'package:abo_najib_2/view/ReminderPage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerClass extends StatelessWidget {
  final String accountName;
  final String accountEmail;
  final String accountInitial;

  const DrawerClass({
    super.key,
    required this.accountName,
    required this.accountEmail,
    required this.accountInitial,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          SafeArea(
            child: DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: Color(0xFF2e495e),
                      child: Text(
                        accountInitial,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    accountName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    accountEmail,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // List Items
          Expanded(
            child: ListView(
              children: [
                buildListItem(
                  icon: Icons.punch_clock_sharp,
                  title: 'Reminders',
                  onTap: () {
                    Get.to(Reminders());
                  },
                ),
                buildListItem(
                  icon: Icons.punch_clock_sharp,
                  title: 'Goals',
                  onTap: () {
                    Get.toNamed("/Goals");
                  },
                ),
                buildListItem(
                  icon: Icons.punch_clock_sharp,
                  title: 'IncomesScreens',
                  onTap: () {
                    Get.toNamed("/IncomesScreens");
                  },
                ),
                buildListItem(
                  icon: Icons.punch_clock_sharp,
                  title: 'Expences',
                  onTap: () {
                    Get.toNamed("/ExpencesScreens");
                  },
                ),
                const Divider(),
                buildListItem(
                  icon: Icons.logout,
                  title: 'Log Out',
                  onTap: () async {
                    // عرض حوار باستخدام AwesomeDialog لتأكيد الخروج
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.bottomSlide,
                      title: 'Log Out',
                      desc: 'Are you sure you want to log out?',
                      btnCancelOnPress: () {
                        // لا، لا تسجل الخروج
                      },
                      btnOkOnPress: () async {
                        // نعم، سجل الخروج
                        await logoutUser();
                      },
                      btnCancelText: 'No',
                      btnOkText: 'Yes',
                    ).show();
                  },
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Color(0xFF2e495e)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color ?? Color(0xFF482F37),
        ),
      ),
      onTap: onTap,
    );
  }

  Future<void> logoutUser() async {
    var auth = FirebaseAuth.instance;
    await auth.signOut();
    // مسح حالة تسجيل الدخول من SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');
  }
}
