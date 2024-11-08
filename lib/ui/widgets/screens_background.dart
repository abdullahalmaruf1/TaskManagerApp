import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager_app/ui/utils/assets_path.dart';

class ScreensBackground extends StatelessWidget {
  const ScreensBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            AssetsPath.backgroundSvg,
            fit: BoxFit.cover,
            height: screenSize.height,
            width: screenSize.width,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: _buildBody(context),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildBody(BuildContext context) {
    final fixedHeight = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          minHeight: fixedHeight.size.height - fixedHeight.viewInsets.bottom,
        ),
        child: child,
      ),
    );
  }
}
