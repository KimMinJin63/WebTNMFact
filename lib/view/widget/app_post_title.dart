import 'package:flutter/material.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class AppPostTitle extends StatelessWidget {
  const AppPostTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '제목',
            style: AppTextStyle.koSemiBold16(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            '작성자',
            style: AppTextStyle.koSemiBold16(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            '카테고리',
            style: AppTextStyle.koSemiBold16(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            '날짜',
            style: AppTextStyle.koSemiBold16(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: [
            Text(
              '수정',
              style: AppTextStyle.koSemiBold16(),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '삭제',
              style: AppTextStyle.koSemiBold16(),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}
