import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';
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
      this.onDeleteTap,
      this.color, this.textColor});
  final String title;
  final String author;
  final String category;
  final String createdAt;
  final String status;
  final Color? color;
  final Color? textColor;
  final Function()? onTap;
  final Function()? onContentTap;
  final Function()? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 20,
              child: InkWell(
                onTap: onContentTap,
                child: Text(
                  title,
                  style: AppTextStyle.koSemiBold16()
                      .copyWith(color: AppColor.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Center(
                child: Text(
                  author,
                  style: TextStyle(fontSize: 16.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(fontSize: 16.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              flex: 14,
              child: Center(
                child: Text(
                  createdAt,
                  style: TextStyle(fontSize: 16.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20.r)
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    status,
                    style: AppTextStyle.koSemiBold16().copyWith(color: textColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.edit, size: 30.w, color: AppColor.primary),
                    onPressed: onTap,
                  ),
                  SizedBox(width: 16.w),
                  IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.delete, size: 30.w, color: AppColor.red),
                      onPressed: onDeleteTap),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
