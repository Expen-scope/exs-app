import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContentLE extends StatelessWidget {
  ContentLE({
    super.key,
    required this.iconcolor,
    required this.iconprimary,
    required this.nameofcategory,
    required this.onpres,
    required this.colorofmoney,
    required this.valueofmoney,
    required this.icondelete,
  });

  final Color iconcolor;
  final Color colorofmoney;
  final Icon? iconprimary;
  final String nameofcategory;
  final dynamic valueofmoney;
  final VoidCallback onpres;
  final Icon icondelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xffF2F0EF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // أيقونة الفئة
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: iconcolor,
                    shape: BoxShape.circle,
                  ),
                  child: iconprimary, // تأكد من أن الأيقونة ليست فارغة
                ),
                const SizedBox(width: 16),
                // النصوص (اسم الفئة والقيمة)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // اسم الفئة
                    Text(
                      nameofcategory,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF264653),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // القيمة
                    Text(
                      valueofmoney.toString(), // تأكد من أن القيمة ليست فارغة
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorofmoney,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // زر الحذف
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: icondelete,
                onPressed: onpres,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
