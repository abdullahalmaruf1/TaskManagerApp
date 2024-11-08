import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/models/user_details.dart';
import 'package:task_manager_app/data/models/user_details_model.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/controller/auth_controller.dart';
import 'package:task_manager_app/ui/screens/profile_screen.dart';
import 'package:task_manager_app/ui/screens/sing_in_screen.dart';
import 'package:task_manager_app/ui/utils/app_colors.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key,
    this.isProfileScreenOpen = false,
  });

  final bool isProfileScreenOpen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isProfileScreenOpen) {
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      },
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.themeColor,
        title: ListTile(
          textColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
            backgroundImage: NetworkImage(AuthController.userData?.photo ?? ''),
            child: const Icon(
              Icons.person,
              color: Colors.grey,
            ),
          ),
          title:  Text(AuthController.userData?.fullName ?? ''),
          subtitle:  Text(AuthController.userData?.email ?? ''),
          trailing: IconButton(
            onPressed: () => _onTapLogout(context),
            icon: const Icon(Icons.logout),
          ),
        ),
      ),
    );
  }

  void _onTapLogout(BuildContext context) async {
    await AuthController.clearAccessToken();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SingInScreen(),
        ),
        (value) => false);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
