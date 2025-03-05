import 'package:flutter/material.dart';

class Appbarofpage extends StatelessWidget implements PreferredSizeWidget {
  final String TextPage;

  /// 🔹 إضافة `super.key`
  const Appbarofpage({super.key, required this.TextPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2e495e), Color(0xFF507da0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            /// 🔙 زر الرجوع
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            /// 🏆 العنوان في المنتصف
            Align(
              alignment: Alignment.center,
              child: Text(
                TextPage,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 هذا يجعل الكود يعمل بدون أخطاء
  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
