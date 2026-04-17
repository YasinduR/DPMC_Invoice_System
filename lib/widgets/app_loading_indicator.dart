import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';

class AppLoadingIndicator extends StatelessWidget {
  final Color? indicatorColor;
  final double indicatorSize;
  final double indicatorStrokeWidth;

  const AppLoadingIndicator({
    super.key,
    this.indicatorColor,
    this.indicatorSize = 60.0,
    this.indicatorStrokeWidth = 6.0,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: indicatorSize,
        height: indicatorSize,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(indicatorColor ?? AppColors.primary),
          strokeWidth: indicatorStrokeWidth,
        ),
      ),
    );
  }
}
