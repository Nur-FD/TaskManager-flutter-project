import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_app/data/models/auth_utility.dart';
import 'package:task_manager_app/ui/custom_widgets/screen_background.dart';
import 'package:task_manager_app/ui/custom_widgets/user_profile_appBar.dart';

import '../../data/models/login_model.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/showMessage.dart';

class UserProfileUpdateScreen extends StatefulWidget {
  static const String routeName = '/update_profile';
  const UserProfileUpdateScreen({super.key});

  @override
  State<UserProfileUpdateScreen> createState() =>
      _UserProfileUpdateScreenState();
}

class _UserProfileUpdateScreenState extends State<UserProfileUpdateScreen> {
  UserData userData = AuthUtility.userInfo.data!;
  final _emailController = TextEditingController();

  final _firstController = TextEditingController();

  final _lastController = TextEditingController();

  final _mobileController = TextEditingController();

  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? imageFile;
  ImagePicker picker = ImagePicker();

  @override
  void initState() {
    _emailController.text = userData.email ?? '';
    _firstController.text = userData.firstName ?? '';
    _lastController.text = userData.lastName ?? '';
    _mobileController.text = userData.mobile ?? '';
    super.initState();
  }

  bool _profileInProgress = false;
  Future<void> updateProfile() async {
    _profileInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final Map<String, dynamic> requestBody = {
      "firstName": _firstController.text.trim(),
      "lastName": _lastController.text.trim(),
      "mobile": _mobileController.text.trim(),
      "photo": ""
    };
    if (_passwordController.text.isNotEmpty) {
      requestBody['password'] = _passwordController.text;
    }
    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.updateProfile, requestBody);
    _profileInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      userData.firstName=_firstController.text.trim();
      userData.lastName=_lastController.text.trim();
      userData.mobile=_mobileController.text.trim();
      AuthUtility.updateUserInfo(userData);
      _passwordController.clear();
      if (mounted) {
        showMsg(context, 'Profile update!');
      }
    } else {
      if (mounted) {
        showMsg(context, 'Profile update failed! try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UserProfileAppBar(isUpdateScreen: true),
                const SizedBox(
                  height: 24.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Update Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          selectImage();
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                color: Colors.grey,
                                child: const Text('Photos'),
                              ),
                              Visibility(
                                  visible: imageFile != null,
                                  child: Text(imageFile?.name ?? '')),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        readOnly: true,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                        validator: (String? value) {
                          if (value?.isEmpty ?? true) {
                            return 'Enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        controller: _firstController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'First name',
                        ),
                        validator: (String? value) {
                          if (value?.isEmpty ?? true) {
                            return 'Enter your first name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        controller: _lastController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'Last name',
                        ),
                        validator: (String? value) {
                          if (value?.isEmpty ?? true) {
                            return 'Enter your last name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Mobile',
                        ),
                        validator: (String? value) {
                          if ((value?.isEmpty ?? true) || value!.length < 11) {
                            return 'Enter your valid mobile no';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                        ),
                        validator: (String? value) {
                          if ((value?.isEmpty ?? true) || value!.length <= 5) {
                            return 'Enter a password more then 6 letters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: _profileInProgress
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  updateProfile();
                                },
                                child: const Text(
                                  'Update',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectImage() {
    picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = xFile;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }
}
