import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tnm_fact/helpers/app_category_helper.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_navigation.dart';
import 'package:tnm_fact/utils/app_text_style.dart';
import 'package:tnm_fact/view/widget/post_article_feedback.dart';
import 'package:web/web.dart' as web;

class DetailView extends StatelessWidget {
  final Map<String, dynamic> post;
  const DetailView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSeo();
    });
    final rawDate = post['date'];
    String titleDate = '';

    if (rawDate is Timestamp) {
      titleDate = DateFormat('yy.MM.dd').format(rawDate.toDate());
    } else if (rawDate is String) {
      try {
        final parsedDate = DateTime.parse(rawDate);
        titleDate = DateFormat('yy.MM.dd').format(parsedDate);
      } catch (e) {
        print('⚠️ 날짜 파싱 실패: $rawDate');
      }
    }

    print('post date: ${post['date']}');
    print('titleDate: $titleDate');

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Center(
          child: ConstrainedBox(
            // 뉴스 기사형 본문 폭 (좌우 여백 확보)
            constraints: const BoxConstraints(maxWidth: 680),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  GestureDetector(
                    onTap: () => navigateBackToHome(context: context),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back, color: AppColor.primary),
                        SizedBox(width: 4.w),
                        Text('목록으로 돌아가기',
                            style: AppTextStyle.koSemiBold14()
                                .copyWith(color: AppColor.primary)),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: CategoryHelper.getCategoryBackgroundColor(
                          post['category'] ?? ''),
                      borderRadius: BorderRadius.circular(80.r),
                    ),
                    child: Text(
                      post['category'] ?? '',
                      style: AppTextStyle.koSemiBold14().copyWith(
                        color: CategoryHelper.getCategoryColor(
                            post['category'] ?? ''),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(post['title'] ?? titleDate,
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          color: AppColor.black)),
                  SizedBox(height: 8.h),
                  Text(
                      '작성자: ${CategoryHelper.getCategoryName(post['category'])} | $titleDate',
                      // Text('작성자: ${post['editor']} | $titleDate',
                      style: AppTextStyle.koRegular14()),
                  SizedBox(height: 24.h),
                  Text(post['final_article'],
                      style: AppTextStyle.koRegular18()
                          .copyWith(color: AppColor.black)),
                  PostArticleFeedback(
                    postId: (post['id'] ?? '').toString(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateSeo() {
    final title = post['title']?.toString() ?? '';
    final article = (post['final_article'] ?? '').toString();

    // 줄바꿈, 연속 공백 제거
    final cleanText =
        article.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

    // description은 160자 정도만 사용
    final description = cleanText.length > 160
        ? '${cleanText.substring(0, 160)}...'
        : cleanText;

    // 브라우저 탭 제목
    web.document.title = '$title | TNM팩트';

    // 기존 description 찾기
    var metaDescription =
        web.document.querySelector('meta[name="description"]');

    // 없으면 새로 생성
    if (metaDescription == null) {
      metaDescription = web.document.createElement('meta');
      metaDescription.setAttribute('name', 'description');
      web.document.head?.append(metaDescription);
    }

    // description 적용
    metaDescription.setAttribute('content', description);
  }
}
