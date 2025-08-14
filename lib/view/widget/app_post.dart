import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class AppPost extends StatelessWidget {
  const AppPost(
      {super.key,
      required this.title,
      required this.author,
      required this.category,
      required this.createdAt});
  final String title;
  final String author;
  final String category;
  final String createdAt;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 16.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            author,
            style: TextStyle(fontSize: 16.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            category,
            style: TextStyle(fontSize: 16.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            createdAt,
            style: TextStyle(fontSize: 16.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // 수정 페이지로 이동
                // print('수정 클릭: ${post['id']}');
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // 삭제 처리
                // print('삭제 클릭: ${post['id']}');
              },
            ),
          ],
        ),
      ],
    );
  }
}
