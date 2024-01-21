import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager_app/data/models/auth_utility.dart';
import 'package:task_manager_app/ui/custom_widgets/screen_background.dart';
import 'package:task_manager_app/ui/pages/auth/login_page.dart';
import 'package:task_manager_app/ui/pages/bottom_nav_base_page.dart';
import 'package:task_manager_app/ui/utils/assets_utils.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigatorToLogin();
  }

  void navigatorToLogin() async {
    Future.delayed(const Duration(seconds: 3)).then((_) async {
      final bool isLoggedIn = await AuthUtility.checkIfUseLoggedIn();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => isLoggedIn
                    ? const BottomNavBaseScreen()
                    : const LoginScreen()),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: SvgPicture.asset(
            AssetsUtils.logoSVG,
            width: 90,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}
