import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/screens/forgot_otp_screen.dart';
import 'package:task_manager_app/ui/utils/app_colors.dart';
import 'package:task_manager_app/ui/widgets/screens_background.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';

class ForgotEmailScreen extends StatefulWidget {
  const ForgotEmailScreen({super.key});

  @override
  State<ForgotEmailScreen> createState() => _ForgotEmailScreenState();
}

class _ForgotEmailScreenState extends State<ForgotEmailScreen> {

  final TextEditingController _emailController = TextEditingController();
  bool _verifyEmailInProgress = false;
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ScreensBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Email Address',
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A 6 digit verification pin will send to your email address',
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
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'Email'),
        ),
        const SizedBox(height: 24),
        Visibility(
          visible: !_verifyEmailInProgress,
          replacement: const CircularProgressIndicator(),
          child: ElevatedButton(
            onPressed: _onTapNextScreen,
            child: const Icon(Icons.arrow_forward_ios),
          ),
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
    Navigator.pop(context);
  }

  Future<void> _verifyEmail() async {
    _verifyEmailInProgress = true;
    setState(() {});
    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.recoverVerifyEmail(_emailController.text),
    );
    _verifyEmailInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      snackBarMessage(context, response.responseBody['data']);
    } else {
      snackBarMessage(context, response.errorMessage, true);
    }
  }

  void _onTapNextScreen() {
    if (_emailController.text != '') {
      _verifyEmail();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotOtpScreen(
            verifyEmail: _emailController.text.trim(),
          ),
        ),
      );
    }
  }
}
