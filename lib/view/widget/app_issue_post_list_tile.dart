import 'package:flutter/material.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class AppIssuePostListTile extends StatelessWidget {
  const AppIssuePostListTile({
    super.key,
    required this.title,
    required this.date,
    required this.excerpt,
    this.highlightTitle = false,
    this.onTap,
  });

  final String title;
  final String date;
  final String excerpt;
  final bool highlightTitle;
  final VoidCallback? onTap;

  static String firstSentence(dynamic article) {
    final text = (article ?? '')
        .toString()
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (text.isEmpty) return '';

    final match = RegExp(r'.+?[.!?。]').firstMatch(text);

    if (match != null) {
      return match.group(0)!.trim();
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.white,
          border: Border(
            bottom: BorderSide(
              color: AppColor.border.withOpacity(0.6),
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: AppTextStyle.koSemiBold12().copyWith(
                color: AppColor.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title.isNotEmpty ? title : date,
              style: AppTextStyle.koSemiBold18().copyWith(
                color: highlightTitle
                    ? AppColor.primary
                    : AppColor.black,
                height: 1.35,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (excerpt.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                excerpt,
                style: AppTextStyle.koRegular14().copyWith(
                  color: const Color(0xFF6B7280),
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}