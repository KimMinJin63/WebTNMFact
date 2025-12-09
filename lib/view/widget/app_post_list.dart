import 'package:flutter/material.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

// ✅ 모바일용 섹션 리스트
class AppPostList extends StatelessWidget {
  const AppPostList({
    super.key,
    required this.posts,
    required this.itemBuilder,
    this.maxItems,
  });

  final List<Map<String, dynamic>> posts;
  final Widget Function(Map<String, dynamic>) itemBuilder; // 🔥 외부에서 UI 제공
  final int? maxItems;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Center(
        child: Text('게시글이 없습니다.', style: AppTextStyle.koRegular18()),
      );
    }

    final int itemCount = maxItems == null
        ? posts.length
        : posts.length > maxItems!
            ? maxItems!
            : posts.length;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final post = posts[index];
        return itemBuilder(post);  // 🔥 외부에서 받은 함수 실행
      },
    );
  }
}
