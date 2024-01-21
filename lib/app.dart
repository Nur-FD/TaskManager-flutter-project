import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/pages/add_task_page.dart';
import 'package:task_manager_app/ui/pages/bottom_nav_base_page.dart';
import 'package:task_manager_app/ui/pages/auth/email_verification_page.dart';
import 'package:task_manager_app/ui/pages/auth/login_page.dart';
import 'package:task_manager_app/ui/pages/auth/otp_verification_page.dart';
import 'package:task_manager_app/ui/pages/auth/reset_password_page.dart';
import 'package:task_manager_app/ui/pages/auth/signup_page.dart';
import 'package:task_manager_app/ui/pages/splash_page.dart';
import 'package:task_manager_app/ui/pages/user_profile_update_page.dart';

class TaskManager extends StatefulWidget {
  static GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();
  const TaskManager({super.key});

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: TaskManager.globalKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
      themeMode: ThemeMode.light,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        EmailVerificationScreen.routeName: (_) =>
            const EmailVerificationScreen(),
        SignUpScreen.routeName: (_) => const SignUpScreen(),
        BottomNavBaseScreen.routeName: (_) => const BottomNavBaseScreen(),
        AddNewTaskScreen.routeName: (_) => const AddNewTaskScreen(),
        UserProfileUpdateScreen.routeName: (_) =>
            const UserProfileUpdateScreen(),
      },
    );
  }
}
