import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});
  static const route = '/detail';

  @override
  Widget build(BuildContext context) {
    final post = Get.arguments;
    print('잘받아오나???');
    print('잘 받아오나?? : ${post['date']}');
    // print('잘 받아오나?? : ${post['final_article']}');
    print('잘 받아오나?? : ${post['category']}');
    print('잘 받아오나?? : ${post['status']}');
    // final timestamp = post['updatedAt'] ?? post['createdAt'];
    final rawDate = post['date']; // ✅ Timestamp 타입
    String titleDate = '';

    if (rawDate is Timestamp) {
      final date = rawDate.toDate(); // Timestamp → DateTime 변환
      titleDate = DateFormat('yy-MM-dd').format(date); // 원하는 형식으로 변환
    }

    print('🕒 변환된 날짜: $titleDate');

    // String formattedDate = '';
    // if (timestamp != null && timestamp is Timestamp) {
    //   final date = timestamp.toDate();
    //   formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(date);
    // }

    // final String displayDate =
    //     formattedDate.isNotEmpty ? formattedDate : (rawDateStr ?? '');

    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h, bottom: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: AppColor.primary,
                        ),
                        SizedBox(width: 2.w),
                        Text('목록으로 돌아가기',
                            style: AppTextStyle.koSemiBold14().copyWith(
                              color: AppColor.primary,
                            )),
                      ],
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Container(
                  margin: EdgeInsets.only(top: 8.h),
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: post['category'] == '데일리 팩트'
                        ? AppColor.primary.withOpacity(0.1)
                        : AppColor.yellow.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(80.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2.w),
                    child: Text(
                      '${post['category']}',
                      style: AppTextStyle.koSemiBold14().copyWith(
                          color: post['category'] == '데일리 팩트'
                              ? AppColor.primary
                              : AppColor.yellow),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              Text(
                '[오늘의 교육 뉴스] $titleDate',
                style: AppTextStyle.koBold35(),
              ),
              SizedBox(
                height: 16.h,
              ),
              Text(
                '작성자:${post['editor']}|$titleDate',
                style:
                    AppTextStyle.koRegular14().copyWith(color: AppColor.black),
              ),
              SizedBox(
                height: 36.h,
              ),
              Text(
                post['final_article'],
                style:
                    AppTextStyle.koRegular18().copyWith(color: AppColor.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
