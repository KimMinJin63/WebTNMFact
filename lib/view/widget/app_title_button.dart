import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class AppTitleButton extends StatelessWidget {
  const AppTitleButton(
      {super.key, this.onPressed, required this.color, required this.title});
  final Function()? onPressed;
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: AutoSizeText(title,
            maxFontSize: 13,
            minFontSize: 10, // 너무 작게 줄이지 않게 제한

            style: AppTextStyle.koBold13().copyWith(
              color: color,
            )));
  }
}
