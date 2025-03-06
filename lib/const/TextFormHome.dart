import 'package:flutter/material.dart';

class TextFormFieldClass extends StatelessWidget {
  TextFormFieldClass(
      {super.key,
      this.obscureTe = false,
      required this.hinttext,
      this.onchange,
      this.suffixIcon,
      this.errorText});

  String hinttext;
  bool? obscureTe;
  Function(String)? onchange;
  final Widget? suffixIcon;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureTe!,
      validator: (value) {
        if (value!.isEmpty) {
          return 'field';
        }
      },
      onChanged: onchange,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        // hintText: hinttext,
        // hintStyle: TextStyle(color: Colors.blue.shade900, fontSize: 16,fontFamily:'RobotoSlab'),
        labelText: hinttext,
        labelStyle: TextStyle(
          fontFamily: 'Tajawal-Regular',
          color: Colors.black54, // اللون عند التواجد في الأسفل
          fontSize: 16,
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade900)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade900)),
        suffixIcon: suffixIcon,
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
