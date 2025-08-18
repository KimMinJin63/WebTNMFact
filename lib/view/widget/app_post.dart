import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class AppPost extends StatelessWidget {
  const AppPost(
      {super.key,
      required this.title,
      required this.author,
      required this.category,
      required this.createdAt,
      this.onTap});
  final String title;
  final String author;
  final String category;
  final String createdAt;
  final Function()? onTap;

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
              onPressed: onTap
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
