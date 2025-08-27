import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class AppPostTitle extends StatelessWidget {
  const AppPostTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 20,
              child: Text(
                '제목',
                style: AppTextStyle.koSemiBold16(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 8,
              child: Text(
                '작성자',
                style: AppTextStyle.koSemiBold16(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 10,
              child: Text(
                '카테고리',
                style: AppTextStyle.koSemiBold16(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 14,
              child: Text(
                '날짜',
                style: AppTextStyle.koSemiBold16(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 10,
              child: Text(
                '발행여부',
                style: AppTextStyle.koSemiBold16(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: Text(
                  '관리',
                  style: AppTextStyle.koSemiBold16(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
