import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/screens/splash_screen.dart';
import 'package:task_manager_app/ui/utils/app_colors.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: TaskManagerApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(
        colorSchemeSeed: AppColors.themeColor,
        floatingActionButtonTheme: _buildFloatingActionButtonThemeData(),
        inputDecorationTheme: _buildInputDecorationTheme(),
        elevatedButtonTheme: _buildElevatedButtonThemeData(),
        textButtonTheme: _buildTextButtonThemeData(),
        navigationBarTheme: _buildNavigationBarThemeData(),
      ),
    );
  }

  FloatingActionButtonThemeData _buildFloatingActionButtonThemeData() {
    return const FloatingActionButtonThemeData(
      elevation: 0,
      shape: CircleBorder(),
    );
  }

  NavigationBarThemeData _buildNavigationBarThemeData() {
    return const NavigationBarThemeData(
      indicatorColor: AppColors.themeColor,
      backgroundColor: Colors.transparent,
    );
  }

  TextButtonThemeData _buildTextButtonThemeData() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey,
      ),
    );
  }

  InputDecorationTheme _buildInputDecorationTheme() {
    return InputDecorationTheme(
      fillColor: Colors.white,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
      filled: true,
      border: _outlineInputBorder(),
      focusedBorder: _outlineInputBorder(),
      enabledBorder: _outlineInputBorder(),
      disabledBorder: _outlineInputBorder(),
      errorBorder: _outlineInputBorder(),
      focusedErrorBorder: _outlineInputBorder(),
    );
  }

  OutlineInputBorder _outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    );
  }

  ElevatedButtonThemeData _buildElevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: AppColors.themeColor,
        fixedSize: const Size.fromWidth(double.maxFinite),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
