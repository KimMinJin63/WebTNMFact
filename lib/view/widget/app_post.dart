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
      required this.status,
      this.onTap,
      this.onContentTap,
      this.onDeleteTap
      });
  final String title;
  final String author;
  final String category;
  final String createdAt;
  final String status;
  final Function()? onTap;
  final Function()? onContentTap;
  final Function()? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 15,
            child: InkWell(
              onTap: onContentTap,
              child: Text(
                title,
                style: TextStyle(fontSize: 16.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Text(
              author,
              style: TextStyle(fontSize: 16.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 10,
            child: Text(
              category,
              style: TextStyle(fontSize: 16.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 14,
            child: Text(
              createdAt,
              style: TextStyle(fontSize: 16.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 10,
            child: Text(
              status,
              style: TextStyle(fontSize: 16.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: const Icon(Icons.edit),
                  onPressed: onTap,
                ),
                SizedBox(width: 16.w),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: const Icon(Icons.delete),
                  onPressed: onDeleteTap
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
