import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/widgets/screens_background.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';

class AddNewScreen extends StatefulWidget {
  const AddNewScreen({super.key});

  @override
  State<AddNewScreen> createState() => _AddNewScreenState();
}

class _AddNewScreenState extends State<AddNewScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  bool _inProgress = false;
  bool shouldRefreshPreviousPage = false;


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop,result){
        if(didPop) return;
        Navigator.pop(context, shouldRefreshPreviousPage);
      },
      child: ScreensBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 56),
            Text(
              'Add New Task',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 24),
            _buildAddNewForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewForm() {
    return Form(
      key: _globalKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(hintText: 'Subject'),
            validator: (String? value) {
              if (value?.trim().isEmpty == true) {
                return 'Enter valid value';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLines: 8,
            decoration: const InputDecoration(hintText: 'Description'),
            validator: (String? value) {
              if (value?.trim().isEmpty == true) {
                return 'Enter valid value';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Visibility(
            visible: !_inProgress,
            replacement: const CircularProgressIndicator(),
            child: ElevatedButton(
              onPressed: _onTapAddButton,
              child: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapAddButton() {
    if (!_globalKey.currentState!.validate()) {
      return;
    }
    _createTask();
  }

  Future<void> _createTask() async {
    _inProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status": "New"
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.createTask,
      body: requestBody,
    );
    _inProgress = false;
    setState(() {});
    if(response.isSuccess){
      Navigator.pop(context,shouldRefreshPreviousPage = true);
      //shouldRefreshPreviousPage = true;
      _clearField();
      snackBarMessage(context, 'New task create successfully');
    }else{
      snackBarMessage(context, response.errorMessage,true);
    }
  }

  void _clearField(){
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
