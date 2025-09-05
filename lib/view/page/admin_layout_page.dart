import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';
import 'package:tnm_fact/view/page/admin_page.dart';
import 'package:tnm_fact/view/page/create_page.dart';
import 'package:tnm_fact/view/page/dash_board_page.dart';
import 'package:tnm_fact/view/page/edit_page.dart';
import 'package:tnm_fact/view/page/home_page.dart';

class AdminLayoutPage extends StatelessWidget {
  const AdminLayoutPage({super.key});
  static const String route = '/layout';

  @override
  Widget build(BuildContext context) {
    final AdminController controller = Get.find<AdminController>();
    final screenWidth = ScreenUtil().screenWidth;
    final bool isExtended = screenWidth > 600; // 기준 너비
    final double railWidth = isExtended ? 240.w : 72.w;
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: railWidth,
            color: AppColor.navy,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'TNM ADMIN',
                      style: AppTextStyle.koSemiBold22().copyWith(
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                // Expanded(
                //   child: Obx(
                //     () => NavigationRail(
                //       useIndicator: false,
                //       selectedIconTheme:
                //           IconThemeData(size: 32.w, color: Colors.white),
                //       unselectedIconTheme:
                //           IconThemeData(size: 28.w, color: Colors.white70),
                //       extended: isExtended, // 반응형 제어
                //       // indicatorColor: AppColor.shadowGrey,
                //       selectedLabelTextStyle: AppTextStyle.koSemiBold16()
                //           .copyWith(color: Colors.white),
                //       unselectedLabelTextStyle: AppTextStyle.koRegular14()
                //           .copyWith(color: Colors.white70),
                //       backgroundColor: Colors.transparent,
                //       groupAlignment: -1.0,
                //       destinations: [
                //         NavigationRailDestination(
                //           icon: Icon(Icons.space_dashboard_outlined,
                //               color: Colors.white70),
                //           selectedIcon: Container(
                //             // padding: EdgeInsets.symmetric(horizontal: 8.w),
                //               width: 60.w,
                //               height: 45.h,
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(10.w),
                //                 color: AppColor.shadowGrey,
                //               ),
                //               child: Icon(Icons.space_dashboard)),
                //           label: Padding(
                //             padding: EdgeInsets.only(left: 4.w),
                //             child: Text('대시보드'),
                //           ),
                //         ),
                //         NavigationRailDestination(
                //           icon: Icon(Icons.description_outlined,
                //               color: Colors.white70),
                //           selectedIcon: Icon(
                //             Icons.description,
                //           ),
                //           label: Text('콘텐츠 관리'),
                //         ),
                //         NavigationRailDestination(
                //           icon: Icon(Icons.settings_outlined,
                //               color: Colors.white70),
                //           selectedIcon: Icon(Icons.settings, size: 30.w),
                //           label: Text('설정'),
                //         ),
                //         NavigationRailDestination(
                //           icon: Icon(Icons.space_dashboard_outlined,
                //               color: Colors.white70),
                //           selectedIcon: Container(
                //             // padding: EdgeInsets.symmetric(horizontal: 8.w),
                //               width: 60.w,
                //               height: 45.h,
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(10.w),
                //                 color: AppColor.shadowGrey,
                //               ),
                //               child: Icon(Icons.space_dashboard)),
                //           label: Padding(
                //             padding: EdgeInsets.only(left: 4.w),
                //             child: Text('대시보드'),
                //           ),
                //         ),
                //         NavigationRailDestination(
                //           icon: Icon(Icons.description_outlined,
                //               color: Colors.white70),
                //           selectedIcon: Icon(
                //             Icons.description,
                //           ),
                //           label: Text('콘텐츠 관리'),
                //         ),
                //         NavigationRailDestination(
                //           icon: Icon(Icons.settings_outlined,
                //               color: Colors.white70),
                //           selectedIcon: Icon(Icons.settings, size: 30.w),
                //           label: Text('설정'),
                //         ),
                //       ],
                //       selectedIndex: (controller.menuSelectedIndex.value >= 0 &&
                //               controller.menuSelectedIndex.value < 3)
                //           ? controller.menuSelectedIndex.value
                //           : 0,
                //       onDestinationSelected: (index) {
                //         controller.menuSelectedIndex.value = index;
                //       },
                //     ),
                //   ),
                // ),
                Expanded(
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMenuItem(Icons.dashboard, "대시보드", 0),
                        _buildMenuItem(Icons.description, "콘텐츠 관리", 1),
                        _buildMenuItem(Icons.settings, "설정", 2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 우측 콘텐츠 영역
          Expanded(
            child: Obx(() {
              print('${controller.menuSelectedIndex.value}');
              final AdminController adminController =
                  Get.find<AdminController>();
              if (adminController.isEditing.value) {
                final post = adminController.currentPost.value;
                if (post != null) {
                  return WillPopScope(
                    onWillPop: () async {
                      adminController.isEditing.value = false;
                      return false;
                    },
                    child: EditPage(),
                  );
                } else {
                  return const Center(child: Text('게시글을 선택하세요.'));
                }
              }
              if (adminController.isCreate.value) {
                return WillPopScope(
                  onWillPop: () async {
                    adminController.isCreate.value = false;
                    return false;
                  },
                  child: CreatePage(),
                );
              }

              // final box = GetStorage();

              switch (controller.menuSelectedIndex.value) {
                case 0:
                  return const DashBoardPage();
                case 1:
                  return const AdminPage();
                case 2:
                  return const HomePage();
                default:
                  return const DashBoardPage();
              }
            }),
          ),
        ],
      ),
    );
  }
}

Widget _buildMenuItem(IconData icon, String label, int index,
    {bool extended = true}) {
  final AdminController controller = Get.find<AdminController>();
  final isSelected = controller.menuSelectedIndex.value == index;

  return GestureDetector(
    onTap: () => controller.menuSelectedIndex.value = index,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColor.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: isSelected ? 32.w : 28.w,
            color: isSelected ? Colors.white : Colors.white70,
          ),
          if (extended) ...[
            SizedBox(width: 8),
            Text(
              label,
              style: isSelected
                  ? AppTextStyle.koSemiBold16().copyWith(color: Colors.white)
                  : AppTextStyle.koRegular14().copyWith(color: Colors.white70),
            ),
          ]
        ],
      ),
    ),
  );
}
