import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/login_model.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/models/user_details_model.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/controller/auth_controller.dart';
import 'package:task_manager_app/ui/screens/forgot_email_screen.dart';
import 'package:task_manager_app/ui/screens/sing_up_screen.dart';
import 'package:task_manager_app/ui/screens/main_bottom_nav_bar.dart';
import 'package:task_manager_app/ui/utils/app_colors.dart';
import 'package:task_manager_app/ui/widgets/circular_progress.dart';
import 'package:task_manager_app/ui/widgets/screens_background.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';

class SingInScreen extends StatefulWidget {
  const SingInScreen({super.key});

  @override
  State<SingInScreen> createState() => _SingInScreenState();
}

class _SingInScreenState extends State<SingInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ScreensBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get Started With',
            style: textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          _buildSingInForm(),
          const SizedBox(height: 56),
          _buildForgotOrAccountSection(textTheme),
        ],
      ),
    );
  }

  Widget _buildSingInForm() {
    return Form(
      key: _globalKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Email'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter a valid email';
              }
              if (!value!.contains('@')) {
                return "Enter a valid email '@'";
              }
              if (!value.contains('.com')) {
                return "Enter a valid email '.com'";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Password'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter a valid password';
              }
              if (value!.length < 6) {
                return 'Enter a password more then 6 character';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Visibility(
            visible: !_inProgress,
            replacement: const CircularProgress(),
            child: ElevatedButton(
              onPressed: _onTapSingInButton,
              child: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotOrAccountSection(TextTheme textTheme) {
    return Center(
      child: Column(
        children: [
          TextButton(
            onPressed: _onTapForgotScreen,
            child: const Text('Forgot Password?'),
          ),
          RichText(
            text: TextSpan(
              text: "Don't have account?  ",
              style: textTheme.titleSmall,
              children: [
                TextSpan(
                  text: 'Sing Up',
                  style: const TextStyle(
                    color: AppColors.themeColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = _onTapSingUpScreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onTapSingInButton() {
    if (!_globalKey.currentState!.validate()) {
      return;
    }
    _singIn();
  }

  Future<void> _singIn() async {
    _inProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
    };

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.login,
      body: requestBody,
    );
    _inProgress = false;
    setState(() {});
    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseBody);
      await AuthController.saveAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.data!);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainBottomNavBar()),
              (_) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.errorMessage),
        ),
      );
    }
  }

  void _onTapSingUpScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SingUpScreen(),
      ),
    );
  }

  void _onTapForgotScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotEmailScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
