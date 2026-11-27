import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/utils/admin_breakpoint.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class AppAdminTopBar extends StatelessWidget {
  final int totalCount;
  final int publishedCount;
  final int pendingCount;
  final VoidCallback? onTapAll;
  final VoidCallback? onTapPublished;
  final VoidCallback? onTapPending;
  final TextEditingController searchController;
  final int selectedIndex;
  final Function()? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const AppAdminTopBar({
    super.key,
    required this.totalCount,
    required this.publishedCount,
    required this.pendingCount,
    required this.searchController,
    required this.selectedIndex,
    this.onTapAll,
    this.onTapPublished,
    this.onTapPending,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();
    const double searchBarHeight = 36;

    // 왼쪽 탭 필터 영역
    final Widget tabs = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Obx(() => _buildTab(
              '모두', totalCount, onTapAll, 0, controller.selectedIndex.value)),
          _divider(),
          Obx(() => _buildTab('발행됨', publishedCount, onTapPublished, 1,
              controller.selectedIndex.value)),
          _divider(),
          Obx(() => _buildTab('대기중', pendingCount, onTapPending, 2,
              controller.selectedIndex.value)),
        ],
      ),
    );

    // 🔹 검색 입력창
    final Widget searchField = SizedBox(
      height: searchBarHeight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: AppColor.black.withOpacity(0.8),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        child: TextField(
          controller: searchController,
          maxLines: 1,
          minLines: 1,
          textAlignVertical: TextAlignVertical.center,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: AppTextStyle.koRegular16(),
          decoration: const InputDecoration(
            isDense: true,
            border: InputBorder.none, // ✅ TextField 자체 테두리는 끔
            hintText: '검색어를 입력하세요',
          ),
        ),
      ),
    );

    // 🔹 검색 버튼
    final Widget searchButton = SizedBox(
      height: searchBarHeight,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColor.primary),
          minimumSize: const Size(0, searchBarHeight),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: onTap,
        child: Text(
          '글 검색',
          style: AppTextStyle.koSemiBold16().copyWith(color: AppColor.primary),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // ✅ 좁은 화면: 탭 줄 아래에 검색창을 가로 전체로
        if (constraints.maxWidth < AdminBreakpoint.mobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              tabs,
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: searchField),
                  const SizedBox(width: 8),
                  searchButton,
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: tabs),
            const SizedBox(width: 20),
            SizedBox(width: 220, child: searchField),
            const SizedBox(width: 8),
            searchButton,
          ],
        );
      },
    );
  }

  Widget _buildTab(String label, int count, VoidCallback? onTap, int index,
      int selectedIndex) {
    return InkWell(
      onTap: onTap,
      child: Text(
        '$label ($count)',
        style: AppTextStyle.koRegular14().copyWith(
          color: selectedIndex == index ? AppColor.black : AppColor.primary,
          fontWeight:
              selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Text('|', style: TextStyle(color: Colors.grey.shade400)),
    );
  }
}
