import 'package:flutter/material.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class AppTitleButton extends StatelessWidget {
  const AppTitleButton({super.key, this.onPressed, required this.color, required this.title});
  final Function()? onPressed;
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Text(title,
            style: AppTextStyle.koBold18().copyWith(
              color: color
            )));
    
  }
}
