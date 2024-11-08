import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager_app/ui/controller/auth_controller.dart';
import 'package:task_manager_app/ui/screens/main_bottom_nav_bar.dart';
import 'package:task_manager_app/ui/screens/sing_in_screen.dart';
import 'package:task_manager_app/ui/utils/assets_path.dart';
import 'package:task_manager_app/ui/widgets/screens_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _moveNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    await AuthController.getAccessToken();
    if(AuthController.isLoggedIn()){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainBottomNavBar(),
          ),
              (value) => false);
    }else{
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SingInScreen(),
          ),
              (value) => false);
    }
  }

  @override
  void initState() {
    _moveNextScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreensBackground(
      child: Center(
        child: SvgPicture.asset(
          AssetsPath.logoSvg,
        ),
      ),
    );
  }
}
