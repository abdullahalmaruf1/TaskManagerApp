import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/screens/sing_in_screen.dart';
import 'package:task_manager_app/ui/utils/app_colors.dart';
import 'package:task_manager_app/ui/widgets/circular_progress.dart';
import 'package:task_manager_app/ui/widgets/screens_background.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key});

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
            'Join With Us',
            style: textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          _buildSingUpForm(),
          const SizedBox(height: 56),
          _buildHaveAccountSection(textTheme),
        ],
      ),
    );
  }

  Widget _buildSingUpForm() {
    return Form(
      key: _globalKey,
      child: Column(
        children: [
          TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(hintText: 'Email'),
              validator: (String? value) {
                if (value?.isEmpty ?? true) {
                  return 'Enter valid email';
                }
                return null;
              }),
          const SizedBox(height: 16),
          TextFormField(
              controller: _firstNameController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(hintText: 'First Name'),
              validator: (String? value) {
                if (value?.isEmpty ?? true) {
                  return 'Enter valid first name';
                }
                return null;
              }),
          const SizedBox(height: 16),
          TextFormField(
              controller: _lastNameController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(hintText: 'Last Name'),
              validator: (String? value) {
                if (value?.isEmpty ?? true) {
                  return 'Enter valid last name';
                }
                return null;
              }),
          const SizedBox(height: 16),
          TextFormField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                hintText: 'Mobile',
              ),
              validator: (String? value) {
                if (value?.isEmpty ?? true) {
                  return 'Enter valid mobile';
                }
                return null;
              }),
          const SizedBox(height: 16),
          TextFormField(
              controller: _passwordController,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(hintText: 'Password'),
              validator: (String? value) {
                if (value?.isEmpty ?? true) {
                  return 'Enter valid password';
                }
                return null;
              }),
          const SizedBox(height: 24),
          Visibility(
            visible: !_inProgress,
            replacement: const CircularProgress(),
            child: ElevatedButton(
              onPressed: _onTapSingUpButton,
              child: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHaveAccountSection(TextTheme textTheme) {
    return Center(
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              text: 'have account?  ',
              style: textTheme.titleSmall,
              children: [
                TextSpan(
                  text: 'Sing In',
                  style: const TextStyle(
                    color: AppColors.themeColor,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = _onTapInScreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onTapSingUpButton() {
    if (_globalKey.currentState!.validate()) {
      _singUp();
    }
  }

  Future<void> _singUp() async {
    _inProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": int.parse(_mobileController.text),
      "password": _passwordController.text,
    };
    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.registration,
      body: requestBody,
    );
    _inProgress = false;
    setState(() {});

    if (response.isSuccess) {
      snackBarMessage(context, 'New account created');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SingInScreen()),
          (predicate) => false);
      _clearField();
    } else {
      snackBarMessage(context, response.errorMessage, true);
    }
  }

  void _clearField() {
    _emailController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _mobileController.clear();
    _passwordController.clear();
  }

  void _onTapInScreen() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SingInScreen(),
        ),
        (value) => false);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
