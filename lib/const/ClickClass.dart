import 'package:flutter/material.dart';

import 'Constants.dart';

class conclickclass extends StatelessWidget {
  conclickclass({super.key, required this.Texts, this.ontap});
  VoidCallback? ontap;
  String Texts;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
            color: kPrimarycolor, borderRadius: BorderRadius.circular(8)),
        width: double.infinity,
        height: hight(context) * .06,
        child: Center(
            child: Text(
          Texts,
          style: TextStyle(
              fontSize: 22, color: Color(0xFF507da0), fontFamily: kboldTajwal),
        )),
      ),
    );
  }
}
