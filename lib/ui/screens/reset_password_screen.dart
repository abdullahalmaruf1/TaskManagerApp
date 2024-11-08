import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/screens/sing_in_screen.dart';
import 'package:task_manager_app/ui/utils/app_colors.dart';
import 'package:task_manager_app/ui/widgets/screens_background.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email, required this.otp});
  final String email;
  final String otp;


  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _setPasswordInProgress = false;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ScreensBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Password',
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Minimum length password 8 character with Latter and number combination',
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _buildSingInForm(),
            const SizedBox(height: 56),
            _buildHaveAccountSection(textTheme),
          ],
        ),
    );
  }

  Widget _buildSingInForm() {
    return Column(
      children: [
        TextFormField(
          controller: _newPasswordController,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Password'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _newPasswordController,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Confirm Password'),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _onTapNextScreen,
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  Widget _buildHaveAccountSection(TextTheme textTheme) {
    return Center(
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              text: 'Have account?  ',
              style: textTheme.titleSmall,
              children: [
                TextSpan(
                  text: 'Sing In',
                  style: const TextStyle(
                    color: AppColors.themeColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = _onTapSingInScreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onTapSingInScreen() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SingInScreen(),
        ),
        (value) => false);
  }

  Future<void> _setPassword() async {
    _setPasswordInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": widget.email,
      "OTP": widget.otp,
      "password": _confirmPasswordController.text
    };
    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.recoverResetPassword,
      body: requestBody,
    );
    _setPasswordInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      snackBarMessage(context, response.responseBody['data']);
    } else {
      snackBarMessage(context, response.errorMessage, true);
    }
  }

  void _onTapNextScreen() {
    if (!_globalKey.currentState!.validate()) {
      return;
    }
    _setPassword();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SingInScreen(),
      ),
    );
  }
}
