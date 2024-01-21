import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/ui/pages/auth/login_page.dart';
import 'package:task_manager_app/ui/pages/auth/reset_password_page.dart';
import 'package:task_manager_app/ui/utils/showMessage.dart';

import '../../../data/utils/urls.dart';
import '../../custom_widgets/screen_background.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  static const String routeName = '/otp_verification_page';
  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  bool _otpVerificationInProgress = false;
  Future<void> verifyOtp() async {
    _otpVerificationInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.verifyOtp(
      widget.email,
      _otpController.text,
    ));
    _otpVerificationInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResetPasswordScreen(
                      email: widget.email,
                      otp: _otpController.text,
                    )));
      }
    } else {
      if (mounted) {
        showMsg(context, 'Opt verification has been failed!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScreenBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  Text(
                    'PIN Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text('A 6 digits pin will sent to your email address',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          )),
                  const SizedBox(
                    height: 24,
                  ),
                  PinCodeTextField(
                    controller: _otpController,
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 50,
                      activeColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      inactiveColor: Colors.red,
                      selectedColor: Colors.green,
                      selectedFillColor: Colors.white,
                      activeFillColor: Colors.white,
                    ),
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please check your email on otp ';
                      }
                      return null;
                    },
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    cursorColor: Colors.green,
                    enablePinAutofill: true,
                    onCompleted: (value) {},
                    onChanged: (value) {},
                    appContext: context,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _otpVerificationInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          verifyOtp();
                        },
                        child: const Text(
                          'VERIFY',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Have an account?',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      TextButton(
                          onPressed: () => Navigator.pushNamedAndRemoveUntil(
                              context,
                              LoginScreen.routeName,
                              (route) => false),
                          child: const Text('Sign in')),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
