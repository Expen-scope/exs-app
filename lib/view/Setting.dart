import 'package:flutter/material.dart';

import '../const/AppBarC.dart';
import '../const/Constants.dart';
import '../const/Drawer.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerClass(
        accountName: 'ss',
        accountEmail: '',
        accountInitial: '',
      ),
      appBar: Appbarofpage(TextPage: "Setting"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: hight(context) * .02),
          Center(
            child: Container(
              width: width(context) * .4,
              decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Image.asset('assets/Photo/khader (1).png', height: 160),
            ),
          ),
          SizedBox(height: hight(context) * .08),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hight(context) * .03),
            child: Container(
              child: Text(
                "change your password",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: hight(context) * .009),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hight(context) * .03),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter old password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: hight(context) * .02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hight(context) * .03),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter new password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: hight(context) * .02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hight(context) * .03),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "confirm your new password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: hight(context) * .04),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hight(context) * .13),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
                backgroundColor: Color(0xFF507da0),
                shadowColor: Colors.transparent,
              ),
              onPressed: () {},
              child: const Text(
                "reset",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
