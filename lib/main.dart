import 'package:abo_najib_2/controller/ExpensesController.dart';
import 'package:abo_najib_2/view/AddExpense.dart';
import 'package:abo_najib_2/view/AddIncomes.dart';
import 'package:abo_najib_2/view/ExpencesScreens.dart';
import 'package:abo_najib_2/view/HomePage.dart';
import 'package:abo_najib_2/view/IncomesPage.dart';
import 'package:abo_najib_2/view/LoginPage.dart';
import 'package:abo_najib_2/view/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/IcomesContorller.dart';
import 'controller/LoginController.dart';
import 'controller/RegisterController.dart';

void main() async {
  Get.put(ExpencesController());
  Get.put(IncomesController());
  Get.lazyPut(() => LoginController());
  Get.lazyPut(() => RegisterController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xffF5F5F5),
          drawerTheme: DrawerThemeData(backgroundColor: Color(0xffF5F5F5))),
      debugShowCheckedModeBanner: false,
      title: 'My App',
      getPages: [
        // GetPage(name: ("/"), page: () => SplashScreen()),
        GetPage(
          name: ("/Login"),
          page: () => LoginPage(),
        ),
        GetPage(
          name: ("/Register"),
          page: () => RegisterPage(),
        ),
        GetPage(
          name: ("/HomePage"),
          page: () => Homepage(),
        ),
        GetPage(
          name: ("/IncomesScreens"),
          page: () => IncomesScreens(),
        ),
        GetPage(
          name: ("/AddIncomes"),
          page: () => AddIncomes(),
        ),
        GetPage(
          name: ("/ExpencesScreens"),
          page: () => ExpencesScreens(),
        ),
        GetPage(
          name: ("/AddExpences"),
          page: () => AddExpences(),
        ),
      ],
      initialRoute: "/IncomesScreens",
    );
  }
}
