import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnm_fact/utils/admin_breakpoint.dart';
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
      this.color,
      this.textColor});
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
    return LayoutBuilder(
      builder: (context, constraints) =>
          constraints.maxWidth < AdminBreakpoint.mobile
              ? _buildCompact()
              : _buildRow(),
    );
  }

  /// 좁은 화면: 제목 한 줄 + (카테고리 · 작성자 · 날짜) + 발행여부 / 관리 버튼
  Widget _buildCompact() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onContentTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.koSemiBold15()
                        .copyWith(color: AppColor.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: AppTextStyle.koSemiBold12()
                              .copyWith(color: textColor),
                        ),
                      ),
                      Text(
                        '$category · $author · $createdAt',
                        style: AppTextStyle.koRegular12()
                            .copyWith(color: const Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.edit, size: 22, color: AppColor.primary),
            onPressed: onTap,
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.delete, size: 22, color: AppColor.red),
            onPressed: onDeleteTap,
          ),
        ],
      ),
    );
  }

  /// 넓은 화면: 기존 표 형태 한 줄
  Widget _buildRow() {
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
                  style: AppTextStyle.koSemiBold14()
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
                  style: AppTextStyle.koRegular14()
                      .copyWith(color: AppColor.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Center(
                child: Text(
                  category,
                  style: AppTextStyle.koRegular14()
                      .copyWith(color: AppColor.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              flex: 14,
              child: Center(
                child: Text(
                  createdAt,
                  style: AppTextStyle.koRegular14()
                      .copyWith(color: AppColor.black),
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
                      color: color, borderRadius: BorderRadius.circular(20.r)),
                  alignment: Alignment.center,
                  child: Text(
                    status,
                    style:
                        AppTextStyle.koSemiBold14().copyWith(color: textColor),
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
                  Expanded(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.edit, size: 25, color: AppColor.primary),
                      onPressed: onTap,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.delete, size: 25, color: AppColor.red),
                        onPressed: onDeleteTap),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
