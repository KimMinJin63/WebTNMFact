import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/utils/admin_breakpoint.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';
import 'package:tnm_fact/view/page/admin_page.dart';
import 'package:tnm_fact/view/page/create_page.dart';
import 'package:tnm_fact/view/page/dash_board_page.dart';
import 'package:tnm_fact/view/page/edit_page.dart';
import 'package:tnm_fact/view/page/home_page.dart';

class AdminLayoutPage extends StatelessWidget {
  const AdminLayoutPage({super.key});
  static const String route = '/admin/home';

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/admin');
      });
      return const SizedBox();
    }

    final AdminController controller = Get.find<AdminController>();

    /// 우측(또는 모바일 본문) 콘텐츠 영역
    final Widget content = Obx(() {
      final admin = controller;
      final tab = controller.menuSelectedIndex.value;
      if (admin.isEditing.value && tab == 1) {
        final post = admin.currentPost.value;
        if (post != null) {
          return WillPopScope(
            onWillPop: () async {
              admin.isEditing.value = false;
              return false;
            },
            child: const EditPage(),
          );
        } else {
          return const Center(child: Text('게시글을 선택하세요.'));
        }
      }

      if (admin.isCreate.value && tab == 1) {
        return WillPopScope(
          onWillPop: () async {
            admin.isCreate.value = false;
            return false;
          },
          child: const CreatePage(),
        );
      }

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
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // ✅ 좁은 화면: 상단바 + 햄버거 메뉴(Drawer)
        if (width < AdminBreakpoint.sidebar) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.navy,
              foregroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Text(
                'TNM ADMIN',
                style: AppTextStyle.koSemiBold18()
                    .copyWith(color: Colors.white, letterSpacing: 0.5),
              ),
            ),
            drawer: Drawer(
              backgroundColor: AppColor.navy,
              width: 240,
              child: SafeArea(
                child: Builder(
                  builder: (drawerContext) => Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        for (final m in _menus)
                          _buildMenuItem(
                            m.icon,
                            m.label,
                            m.index,
                            extended: true,
                            onBeforeSelect: () =>
                                Navigator.of(drawerContext).pop(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: content,
          );
        }

        // ✅ 넓은 화면: 왼쪽 사이드바 (아주 넓으면 메뉴 이름까지 표시)
        final bool extended = width >= AdminBreakpoint.sidebarExtended;
        return Scaffold(
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: extended ? 200 : 72,
                color: AppColor.navy,
                child: Column(
                  children: [
                    if (extended)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
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
                      )
                    else
                      const SizedBox(height: 20),
                    Expanded(
                      child: Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final m in _menus)
                              _buildMenuItem(m.icon, m.label, m.index,
                                  extended: extended),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: content),
            ],
          ),
        );
      },
    );
  }
}

const List<({IconData icon, String label, int index})> _menus = [
  (icon: Icons.dashboard, label: '대시보드', index: 0),
  (icon: Icons.description, label: '콘텐츠 관리', index: 1),
  (icon: Icons.settings, label: '설정', index: 2),
];

Future<bool> showTNMMoveGuardDialog(BuildContext context) async {
  final w = MediaQuery.of(context).size.width;
  // 화면에 따라 92% 이내로, 최대 480(또는 420)까지로 제한
  final double maxWidth = 480.w; // 원하는 최대 가로폭
  final double dialogWidth = w * 0.92 > maxWidth ? maxWidth : w * 0.92;

  return await showDialog<bool>(
        context: context,
        barrierDismissible: true, // 바깥 탭해도 닫기
        builder: (_) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: dialogWidth, // ✅ 가로 최대폭 제한
              // 필요하면 minWidth도 줄 수 있음: minWidth: 320.w,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 헤더 아이콘 배지
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      color: AppColor.primary.withOpacity(.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.edit_note_rounded,
                        size: 32.w, color: AppColor.primary),
                  ),
                  SizedBox(height: 16.h),

                  // 제목 / 서브텍스트
                  Text('수정을 완료해야 이동할 수 있어요',
                      style: AppTextStyle.koSemiBold18()),
                  SizedBox(height: 8.h),
                  Text(
                    '이동하면 현재 수정 중인 내용은 저장되지 않습니다.\n그래도 이동하시겠어요?',
                    style: AppTextStyle.koRegular14()
                        .copyWith(color: AppColor.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),

                  // 버튼들
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColor.shadowGrey),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r)),
                            foregroundColor: AppColor.black,
                            textStyle: AppTextStyle.koSemiBold16(),
                          ),
                          onPressed: () =>
                              Navigator.pop(context, false), // 닫기(계속 편집)
                          child: const Text('닫기'),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r)),
                            textStyle: AppTextStyle.koSemiBold16()
                                .copyWith(color: AppColor.white),
                          ),
                          onPressed: () =>
                              Navigator.pop(context, true), // 이동(저장 안 함)
                          child: const Text('이동',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ) ??
      false;
}

Widget _buildMenuItem(IconData icon, String label, int index,
    {bool extended = true, VoidCallback? onBeforeSelect}) {
  final AdminController controller = Get.find<AdminController>();
  final isSelected = controller.menuSelectedIndex.value == index;

  return GestureDetector(
    onTap: () async {
      // 모바일 Drawer에서 누른 경우 먼저 메뉴를 닫는다.
      onBeforeSelect?.call();
      final admin = controller;
      final currentTab = controller.menuSelectedIndex.value;

      if ((admin.isEditing.value || admin.isCreate.value) &&
          currentTab != index) {
        final go = await showTNMMoveGuardDialog(Get.context!);
        if (!go) return;
        admin.isEditing.value = false;
        admin.isCreate.value = false;
        admin.currentPost.value = null;
      }

      if (index == 1) {
        admin.isEditing.value = false;
        admin.isCreate.value = false;
        admin.currentPost.value = null;
      }

      controller.menuSelectedIndex.value = index;
      controller.selectedIndex.value = 0;
      controller.searchController.clear();
      controller.fetchAllPosts();
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColor.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment:
            extended ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Tooltip(
            message: label,
            child: Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
          if (extended) ...[
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: isSelected
                    ? AppTextStyle.koSemiBold15().copyWith(color: Colors.white)
                    : AppTextStyle.koRegular13()
                        .copyWith(color: Colors.white70),
              ),
            ),
          ]
        ],
      ),
    ),
  );
}
