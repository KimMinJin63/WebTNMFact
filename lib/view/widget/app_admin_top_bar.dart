import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class AppAdminTopBar extends StatelessWidget {
  final int totalCount;
  final int publishedCount;
  final int pendingCount;
  // final ValueChanged<String>? onSearch;
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
    // this.onSearch,
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 왼쪽 탭 필터 영역
        Row(
          children: [
            Obx(() => _buildTab('모두', totalCount, onTapAll, 0,
                controller.selectedIndex.value)),
            _divider(),
            Obx(() => _buildTab('발행됨', publishedCount, onTapPublished, 1,
                controller.selectedIndex.value)),
            _divider(),
            Obx(() => _buildTab('대기중', pendingCount, onTapPending, 2,
                controller.selectedIndex.value)),
          ],
        ),
    
        // 오른쪽 검색 영역
        Row(
          children: [
            SizedBox(
              width: 180.w,
              height: ScreenUtil().screenHeight * 0.045,
              // height: 36.h,
              child: TextField(
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                controller: searchController,
                style: AppTextStyle.koRegular16(),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  hintText: '검색어를 입력하세요',
                  hintStyle: AppTextStyle.koRegular16(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  
                  isDense: true,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            SizedBox(
              width: 90.w,
                            height: ScreenUtil().screenHeight * 0.045,

              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColor.primary),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                ),
                onPressed: onTap,
                child: Text('글 검색', style: AppTextStyle.koSemiBold16().copyWith(color: AppColor.primary),
                
                overflow: TextOverflow.ellipsis,),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTab(String label, int count, VoidCallback? onTap, int index,
      int selectedIndex) {
        print('Selected Index: $selectedIndex, Current Index: $index');
    return InkWell(
      onTap: onTap,
      child: Text(
        '$label ($count)',
        style: TextStyle(
          fontSize: 14,
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
