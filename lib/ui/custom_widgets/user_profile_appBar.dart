import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/auth_utility.dart';
import 'package:task_manager_app/ui/pages/auth/login_page.dart';
import 'package:task_manager_app/ui/pages/user_profile_update_page.dart';

class UserProfileAppBar extends StatefulWidget {
  final bool? isUpdateScreen;
  const UserProfileAppBar({
    super.key,
    required this.isUpdateScreen,
  });

  @override
  State<UserProfileAppBar> createState() => _UserProfileAppBarState();
}

class _UserProfileAppBarState extends State<UserProfileAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.cyan,
      title: GestureDetector(
        onTap: () {
          if ((widget.isUpdateScreen ?? false) == false) {
            Navigator.pushNamed(context, UserProfileUpdateScreen.routeName);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Visibility(
              visible: (widget.isUpdateScreen ?? false) == false,
              child: Row(
                children: [
                  CachedNetworkImage(
                    placeholder: (_, __) => const Icon(Icons.account_circle_outlined,size: 40,),
                    imageUrl:AuthUtility.userInfo.data?.photo ?? '',
                    errorWidget: (_, __,___) => const Icon(Icons.account_circle_outlined,size: 40,),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '${AuthUtility.userInfo.data?.firstName ?? ''} ${AuthUtility.userInfo.data?.lastName ?? ''}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  AuthUtility.userInfo.data?.email ?? 'Unknown',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            await AuthUtility.clearUserInfo();
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.routeName, (route) => false);
            }
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
