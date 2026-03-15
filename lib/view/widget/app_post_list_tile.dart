import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/controller/home_controller.dart';
import 'package:tnm_fact/helpers/app_category_helper.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';
import 'package:tnm_fact/view/page/home_page.dart';

// ✅ 모바일용 리스트 타일 (제목만 표시)
class AppPostListTile extends StatelessWidget {
  const AppPostListTile({super.key, required this.title, required this.category, required this.date, required this.postID, this.onTap, required this.post});
  
  final String title;
  final String category;
  final String date;
  final String postID;
  final VoidCallback? onTap;
  final Map<String, dynamic> post;

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          border: Border(
            bottom: BorderSide(
              color: AppColor.border.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리 배지
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: CategoryHelper.getCategoryBackgroundColor(category),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                category,
                style: AppTextStyle.koSemiBold12().copyWith(
                  color: CategoryHelper.getCategoryColor(category),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 제목과 날짜
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.isNotEmpty ? title : '[오늘의 교육 뉴스] $date',
                    style: AppTextStyle.koSemiBold16(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: AppTextStyle.koRegular12()
                        .copyWith(color: AppColor.grey),
                  ),
                ],
              ),
            ),
            // 화살표 아이콘
            Icon(
              Icons.chevron_right,
              color: AppColor.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
