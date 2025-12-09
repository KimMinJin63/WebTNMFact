import 'package:flutter/material.dart';
import 'package:tnm_fact/controller/home_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class AppSectionList extends StatelessWidget {
  const AppSectionList({
    super.key,
    required this.title,
    required this.posts,
    required this.controller,
    required this.accentColor,
    required this.onMore,
    required this.buildPostTile,
    this.maxItems,
  });

  final String title;
  final List<Map<String, dynamic>> posts;
  final HomeController controller;
  final Color accentColor;
  final int? maxItems;
  final VoidCallback onMore;

  /// 외부에서 리스트 타일 UI를 전달받음
  final Widget Function(Map<String, dynamic> post) buildPostTile;

  @override
  Widget build(BuildContext context) {
    final int displayMax = maxItems ?? 9999;
    final bool showMore = posts.length > displayMax;
    final int itemCount = posts.length > displayMax ? displayMax : posts.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 상단 타이틀 + 더보기
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyle.koBold18().copyWith(color: accentColor),
            ),
            if (showMore)
              TextButton(
                onPressed: () {
                  onMore();
                  controller.scrollController.jumpTo(0);
                },
                child: Text(
                  '>> 더보기',
                  style: AppTextStyle.koSemiBold14().copyWith(
                    color: accentColor,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 8),

        /// 게시글 없을 때
        if (posts.isEmpty)
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              '게시글이 없습니다.',
              style:
                  AppTextStyle.koRegular18().copyWith(color: AppColor.grey),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final post = posts[index];
              return buildPostTile(post); // ⭐ 외부 타일 UI 적용
            },
          ),
      ],
    );
  }
}
