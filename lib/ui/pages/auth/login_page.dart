import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/auth_utility.dart';
import 'package:task_manager_app/data/models/login_model.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/ui/custom_widgets/screen_background.dart';
import 'package:task_manager_app/ui/pages/auth/email_verification_page.dart';
import 'package:task_manager_app/ui/pages/auth/signup_page.dart';
import 'package:task_manager_app/ui/utils/showMessage.dart';

import '../../../data/utils/urls.dart';
import '../bottom_nav_base_page.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login_page';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscure = true;
  bool _loginInProgress = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fromKey = GlobalKey<FormState>();

  Future<void> login() async {
    _loginInProgress = true;
    if (mounted) {
      setState(() {});
    }
    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text,
    };
    final NetworkResponse response = await NetworkCaller()
        .postRequest(Urls.login, requestBody, isLogin: true);
    _loginInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      LoginModel model = LoginModel.fromJson(response.body!);
      await AuthUtility.saveUserInfo(model);
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, BottomNavBaseScreen.routeName, (route) => false);
      }
    } else {
      if (mounted) {
        showMsg(context, 'Incorrect email or password');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _fromKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 120,
                    ),
                    Text(
                      'Get Started With',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (String? value) {
                          if (value?.isEmpty ?? true) {
                            return 'Enter your email';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: isObscure,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                              icon: Icon(isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility))),
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: _loginInProgress == false,
                        replacement:
                            const Center(child: CircularProgressIndicator()),
                        child: ElevatedButton(
                            onPressed: () {
                              login();
                            },
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Center(
                      child: TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, EmailVerificationScreen.routeName),
                          child: const Text(
                            'Forget Password?',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, SignUpScreen.routeName),
                          child: const Text('Sign up'),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
