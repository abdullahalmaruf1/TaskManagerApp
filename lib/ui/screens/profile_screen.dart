import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/models/user_model.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/controller/auth_controller.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_app/ui/widgets/tm_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  bool _inProgress = false;

  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _setUseData();
  }

  void _setUseData() {
    _emailController.text = AuthController.userData?.email ?? '';
    _firstNameController.text = AuthController.userData?.firstName ?? '';
    _lastNameController.text = AuthController.userData?.lastName ?? '';
    _mobileController.text = AuthController.userData?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(
        isProfileScreenOpen: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Profile',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 24),
              _buildPhotoPicker(),
              const SizedBox(height: 16),
              _buildUpdateForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 100,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(8),
              ),
            ),
            child: const Text(
              'Photo',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 24),
          const Text('Select Photo')
        ],
      ),
    );
  }

  Widget _buildUpdateForm() {
    return Form(
      key: _globalKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Email'),
            validator: (String? value){
              if(value?.trim().isEmpty == true){
                return 'Enter valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _firstNameController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(hintText: 'First Name'),
            validator: (String? value){
              if(value?.trim().isEmpty == true){
                return 'Enter valid first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _lastNameController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(hintText: 'Last Name'),
            validator: (String? value){
              if(value?.trim().isEmpty == true){
                return 'Enter valid last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _mobileController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: 'Mobile'),
            validator: (String? value){
              if(value?.trim().isEmpty == true){
                return 'Enter valid mobile';
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
          ),
          const SizedBox(height: 24),
          Visibility(
            visible: !_inProgress,
            replacement: const CircularProgressIndicator(),
            child: ElevatedButton(
              onPressed: _onTapSaveButton,
              child: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapSaveButton() {
    if (!_globalKey.currentState!.validate()) {
      return;
    }
    _updateProfile();
  }

  Future<void> _updateProfile() async {
    _inProgress = true;
    setState(() {});
    Map<String, dynamic> responseBody = {
      "email": _emailController.text.trim(),
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": _mobileController.text.trim(),
    };
    if (_passwordController.text != '') {
      responseBody['password'] = _passwordController.text;
    }
    if (_selectedImage != null) {
      //List<int> imageFile = (_selectedImage.path);
        //String convertedImage = base64Encode(imageFile);
        //responseBody['photo'] = convertedImage;
      }

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.profileUpdate,
      body: responseBody,
    );
    _inProgress = false;
    setState(() {});
    if (response.isSuccess) {
      UserModel userModel = UserModel.fromJson(responseBody);
      await AuthController.saveUserData(userModel);
      snackBarMessage(context, 'profile updated');
    } else {
      snackBarMessage(context, response.errorMessage, true);
    }
  }

  Future<void> _getProfileImage() async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage =
    await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _selectedImage = pickedImage;
      setState(() {});
    }
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
