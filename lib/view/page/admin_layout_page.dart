import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';
import 'package:tnm_fact/view/page/admin_page.dart';
import 'package:tnm_fact/view/page/dash_board_page.dart';
import 'package:tnm_fact/view/page/edit_page.dart';
import 'package:tnm_fact/view/page/home_page.dart';

class AdminLayoutPage extends StatelessWidget {
  const AdminLayoutPage({super.key});
  static const String route = '/layout';

  @override
  Widget build(BuildContext context) {
    final AdminController controller = Get.put(AdminController());
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
                Expanded(
                  child: Obx(
                    () => NavigationRail(
                      extended: isExtended, // 반응형 제어
                      indicatorColor: AppColor.shadowGrey,
                      selectedLabelTextStyle: AppTextStyle.koSemiBold16()
                          .copyWith(color: Colors.white),
                      unselectedLabelTextStyle: AppTextStyle.koRegular14()
                          .copyWith(color: Colors.white70),
                      backgroundColor: Colors.transparent,
                      groupAlignment: -1.0,
                      destinations: [
                        NavigationRailDestination(
                          icon: Icon(Icons.space_dashboard_outlined,
                              size: 30.w, color: Colors.white70),
                          selectedIcon: Icon(Icons.space_dashboard, size: 30.w),
                          label: Text('대시보드'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.description_outlined,
                              size: 30.w, color: Colors.white70),
                          selectedIcon: Icon(Icons.description, size: 30.w),
                          label: Text('콘텐츠 관리'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.settings_outlined,
                              size: 30.w, color: Colors.white70),
                          selectedIcon: Icon(Icons.settings, size: 30.w),
                          label: Text('설정'),
                        ),
                      ],
                      selectedIndex: controller.menuSelectedIndex.value,
                      onDestinationSelected: (index) {
                        controller.menuSelectedIndex.value = index;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 우측 콘텐츠 영역
          Expanded(
            child: Obx(() {
              switch (controller.menuSelectedIndex.value) {
                case 0:
                  return const DashBoardPage();
                case 1:
                  return const AdminPage();
                case 2:
                  return const HomePage();
                case 3:
                  return EditPage();
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
