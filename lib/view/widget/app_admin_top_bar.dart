import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';

class AppAdminTopBar extends StatelessWidget {
  final int totalCount;
  final int publishedCount;
  final int pendingCount;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onTapAll;
  final VoidCallback? onTapPublished;
  final VoidCallback? onTapPending;
  final TextEditingController searchController;
  final int selectedIndex;
  

  const AppAdminTopBar({
    super.key,
    required this.totalCount,
    required this.publishedCount,
    required this.pendingCount,
    required this.searchController,
    required this.selectedIndex,
    this.onSearch,
    this.onTapAll,
    this.onTapPublished,
    this.onTapPending,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 왼쪽 탭 필터 영역
          Row(
            children: [
              _buildTab('모두', totalCount, onTapAll, 0),
              _divider(),
              _buildTab('발행됨', publishedCount, onTapPublished, 1),
              _divider(),
              _buildTab('대기중', pendingCount, onTapPending, 2),
            ],
          ),

          // 오른쪽 검색 영역
          Row(
            children: [
              SizedBox(
                width: 180.w,
                height: 36.h,
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    hintText: '검색어를 입력하세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    isDense: true,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                ),
                onPressed: () {
                  if (onSearch != null) {
                    onSearch!(searchController.text);
                  }
                },
                child: const Text('글 검색', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ],
      ),
    );
  }

Widget _buildTab(String label, int count, VoidCallback? onTap, int index) {
  final controller = Get.find<AdminController>();
  final isSelected = controller.selectedIndex == index;
  return InkWell(
    onTap: onTap,
    child: Text(
      '$label ($count)',
      style: TextStyle(
        fontSize: 14,
        color: isSelected ? AppColor.black : AppColor.primary, // 선택된 탭 색상
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
