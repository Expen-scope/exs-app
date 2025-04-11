import 'package:abo_najib_2/controller/ExpensesController.dart';
import 'package:abo_najib_2/controller/GoalController.dart';
import 'package:abo_najib_2/controller/ReminderController.dart';
import 'package:abo_najib_2/view/AddExpense.dart';
import 'package:abo_najib_2/view/AddGoalScreen.dart';
import 'package:abo_najib_2/view/AddIncomes.dart';
import 'package:abo_najib_2/view/EditGoalScreen.dart';
import 'package:abo_najib_2/view/ExpencesScreens.dart';
import 'package:abo_najib_2/view/GoalScreen.dart';
import 'package:abo_najib_2/view/HomePage.dart';
import 'package:abo_najib_2/view/IncomesPage.dart';
import 'package:abo_najib_2/view/LoginPage.dart';
import 'package:abo_najib_2/view/RegisterPage.dart';
import 'package:abo_najib_2/view/ReminderPage.dart';
import 'package:abo_najib_2/view/Setting.dart';
import 'package:abo_najib_2/view/SplashScreen.dart';
import 'package:abo_najib_2/view/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../controller/IncomesController.dart';
import 'controller/LoginController.dart';
import 'controller/RegisterController.dart';
import 'controller/login_binding.dart';
import 'controller/user_controller.dart';
import 'controller/FinancialController.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone
  tz.initializeTimeZones();

  // Initialize notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      print('Notification clicked: ${response.payload}');
    },
  );

  // Create notification channel for Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'reminder_channel',
    'Reminder Notifications',
    description: 'Channel for reminder notifications',
    importance: Importance.max,
    enableVibration: true,
    enableLights: true,
    ledColor: Colors.blue,
    playSound: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await Get.putAsync(() => SharedPreferences.getInstance());

  final userController = Get.put(UserController());
  await userController.loadUserData();
  await userController.initializeUser();

  Get.put(ExpencesController());
  Get.put(IncomesController());
  Get.put(GoalController());
  Get.put(ReminderController());

  Get.lazyPut(() => LoginController());
  Get.lazyPut(() => RegisterController());

  Get.put(FinancialController());

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
          name: '/Login',
          page: () => LoginPage(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: ("/Register"),
          page: () => RegisterPage(),
        ),
        GetPage(
          name: ("/HomePage"),
          page: () => HomePage(),
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
        GetPage(
          name: ("/Goals"),
          page: () => GoalsScreen(),
        ),
        GetPage(
          name: ("/AddGoal"),
          page: () => AddGoalScreen(),
        ),

        GetPage(
          name: "/MyCustomSplashScreen",
          page: () => MyCustomSplashScreen(),
        ),
        GetPage(
          name: "/Setting",
          page: () => Setting(),
        ),
        GetPage(
          name: ("/Reminder"),
          page: () => RegisterPage(),
        ),
        GetPage(
          name: ("/WelcomeScreen"),
          page: () => WelcomeScreen(),
        ),
      ],
      initialRoute: '/MyCustomSplashScreen',
    );
  }
}
