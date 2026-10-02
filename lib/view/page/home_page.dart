import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/controller/home_controller.dart';
import 'package:tnm_fact/helpers/app_category_helper.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_date.dart';
import 'package:tnm_fact/utils/app_routes.dart';
import 'package:tnm_fact/utils/app_text_style.dart';
import 'package:tnm_fact/view/widget/app_footer.dart';
import 'package:tnm_fact/view/widget/app_issue_post_list_tile.dart';
import 'package:tnm_fact/view/widget/app_side_banner_layout.dart';
import 'package:tnm_fact/view/widget/app_post_list.dart';
import 'package:tnm_fact/view/widget/app_post_list_tile.dart';
import 'package:tnm_fact/view/widget/app_section_list.dart';
import 'package:tnm_fact/view/widget/app_title_button.dart';

// ✅ 내부 상세 페이지 위젯 import 제거됨
// import 'package:tnm_fact/view/page/detail_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  static const route = '/';

  @override
  Widget build(BuildContext context) {
    final AdminController adminController = Get.find<AdminController>();

    return Scaffold(
      backgroundColor: AppColor.white,
      // backgroundColor: AppColor.background,
      // backgroundColor: AppColor.primary.withOpacity(0.2),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        titleSpacing: 0,
        leadingWidth: ScreenUtil().screenWidth > 1000 ? 272 : 56,
        leading: const SizedBox.shrink(),
        title: GestureDetector(
          onTap: () => _onLogoTap(controller),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'TNM FACT',
                style:
                    AppTextStyle.koBold35().copyWith(color: AppColor.primary),
              ),
              const SizedBox(height: 4),
              Text(
                '세상을 읽는 새로운 방법',
                style: AppTextStyle.koRegular13().copyWith(
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        actions: [
          _buildSearchAction(context, controller),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(49),
          child: Column(
            children: [
              Container(
                color: AppColor.background,
                height: 48,
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() {
                          return AppTitleButton(
                            title: '전체기사',
                            color: controller.selectedIndex.value == 0
                                ? AppColor.primary
                                : AppColor.black,
                            onPressed: () {
                              controller.selectTab(0);
                              controller.currentPage.value = 'home';

                              if (controller.scrollController.hasClients) {
                                controller.scrollController.jumpTo(0);
                              }
                            },
                          );
                        }),
                        SizedBox(width: 16.w),
                        Obx(() {
                          return AppTitleButton(
                            title: '이슈 팩트',
                            color: controller.selectedIndex.value == 4
                                ? AppColor.primary
                                : AppColor.black,
// 이슈 팩트
                            onPressed: () {
                              controller.selectTab(4);
                              controller.currentPage.value = 'home';

                              if (controller.scrollController.hasClients) {
                                controller.scrollController.jumpTo(0);
                              }
                            },
                          );
                        }),
                        SizedBox(width: 16.w),
                        Obx(() {
                          return AppTitleButton(
                            title: '포커스 팩트',
                            color: controller.selectedIndex.value == 2
                                ? AppColor.primary
                                : AppColor.black,
// 포커스 팩트
                            onPressed: () {
                              controller.selectTab(2);
                              controller.currentPage.value = 'home';

                              if (controller.scrollController.hasClients) {
                                controller.scrollController.jumpTo(0);
                              }
                            },
                          );
                        }),
                        SizedBox(width: 16.w),
                        Obx(() {
                          return AppTitleButton(
                            title: '인사이트 팩트',
                            color: controller.selectedIndex.value == 3
                                ? AppColor.primary
                                : AppColor.black,
                            onPressed: () {
                              controller.selectTab(3);
                              controller.currentPage.value = 'home';

                              if (controller.scrollController.hasClients) {
                                controller.scrollController.jumpTo(0);
                              }
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColor.border),
            ],
          ),
        ),
      ),

      // ✅ BODY 분기
      body: Stack(
        children: [
          /// ① 기존 본문 전체를 Column으로 그대로 유지
          Column(
            children: [
              // ✅ 상단 라인 로딩바
              Obx(() => controller.isLoadingDetail.value
                  ? const LinearProgressIndicator(
                      minHeight: 3,
                      color: Colors.blueAccent,
                      backgroundColor: Colors.transparent,
                    )
                  : const SizedBox(height: 3)),
              Expanded(
                child: PopScope(
                  canPop: false,
                  onPopInvoked: (didPop) {
                    final controller = Get.find<HomeController>();
                
                    if (!didPop) {
                      // 1️⃣ 검색 결과 상태 → 검색 해제 + 원본 복구
                      if (controller.isSearching.value) {
                        controller.isSearching.value = false;
                        controller.searchController.clear();
                        _resetListForTab(
                            controller, controller.selectedIndex.value);
                        return;
                      }
                
                      // 2️⃣ 다른 탭 → 전체기사 탭으로 복귀
                      if (controller.selectedIndex.value != 0) {
                        controller.selectTab(0);
                        controller.currentPage.value = 'home';
                        if (controller.scrollController.hasClients) {
                          controller.scrollController.jumpTo(0);
                        }
                        return;
                      }
                
                      // 3️⃣ 홈 상태 → 앱 종료
                      Get.back();
                    }
                  },
                  child: _buildHomeContent(controller, adminController),
                ),
              ),
            ],
          ),

          /// ② 데이터 로딩 중일 때 화면 덮는 오버레이
          Obx(() {
            if (controller.isLoading.value) {
              return Positioned.fill(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(AppColor.primary),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "데이터를 불러오는 중입니다...",
                          style: AppTextStyle.koRegular15()
                              .copyWith(color: AppColor.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

// ✅ 기존 홈 콘텐츠 (Grid 포함)
Widget _buildHomeContent(
    HomeController controller, AdminController adminController) {
  return SafeArea(
    child: SingleChildScrollView(
      controller: controller.scrollController,
      child: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1260),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double width = constraints.maxWidth;
                        final bool isMobileLayout = width <= 600;
                        final int crossCount = width <= 800 ? 2 : 3;
                        const double aspectRatio = 1.4; // ✅ 카드 비율 고정

                        Widget buildGrid({
                          required List<Map<String, dynamic>> posts,
                          int? maxRows,
                        }) {
                          final maxItems =
                              maxRows == null ? null : crossCount * maxRows;
                          return _buildPostGrid(
                            posts: posts,
                            controller: controller,
                            crossAxisCount: crossCount,
                            aspectRatio: aspectRatio,
                            maxItems: maxItems,
                          );
                        }

                        Widget buildList({
                          required List<Map<String, dynamic>> posts,
                          int? maxItems,
                        }) {
                          return AppPostList(
                            posts: posts,
                            maxItems: maxItems,
                            itemBuilder: (post) {
                              final String title =
                                  (post['title'] ?? '').toString();
                              final String category =
                                  (post['category'] ?? '').toString();
                              final String postID =
                                  (post['id'] ?? '').toString();
                              final String date = AppDate.format(post['date']);

                              return AppPostListTile(
                                title: title,
                                onTap: () => controller.handlePostTap(post),
                                category: category,
                                date: date,
                                postID: postID,
                                post: post,
                              );
                            },
                          );
                        }

                        return Obx(() {
                          List<Map<String, dynamic>> visibleList;
                          switch (controller.selectedIndex.value) {
                            case 2:
                              visibleList = controller.focusPostList;
                              break;
                            case 3:
                              visibleList = controller.insightPostList;
                              break;
                            case 4:
                              visibleList = controller.dailyPostList;
                              break;
                            default:
                              visibleList = controller.postList;
                          }
                          final bool isIssueFact =
                              controller.selectedIndex.value == 4;
                          if (controller.isLoading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (visibleList.isEmpty) {
                            return Center(
                              child: Text('게시글이 없습니다.',
                                  style: AppTextStyle.koRegular18()),
                            );
                          }

                          if (controller.selectedIndex.value == 0 &&
                              !controller.isSearching.value) {
                            final sections = [
                              (
                                title: '이슈 팩트',
                                posts: controller.dailyPostList,
                                accent: AppColor.primary,
                                maxRows: 1,
                                maxItems: 5,
                                tabIndex: 4,
                              ),
                              (
                                title: '포커스 팩트',
                                posts: controller.focusPostList,
                                accent: AppColor.focusFact,
                                tabIndex: 2,
                                maxRows: 1,
                                maxItems: isMobileLayout ? 5 : null,
                              ),
                              (
                                title: '인사이트 팩트',
                                posts: controller.insightPostList,
                                accent: AppColor.yellow,
                                tabIndex: 3,
                                maxRows: 1,
                                maxItems: isMobileLayout ? 3 : null,
                              ),
                            ];

                            return Column(
                              children: [
                                for (int i = 0; i < sections.length; i++)
                                  if (sections[i].posts.isNotEmpty) ...[
                                    // 모바일은 전부 리스트
                                    // PC에서는 이슈 팩트만 리스트
                                    (isMobileLayout ||
                                            sections[i].tabIndex == 4)
                                        ? AppSectionList(
                                            title: sections[i].title,
                                            posts: sections[i].posts,
                                            accentColor: sections[i].accent,
                                            controller: controller,
                                            maxItems: sections[i].maxItems,
                                            showTitleDivider:
                                                sections[i].tabIndex == 4,
                                            onMore: () => controller.selectTab(
                                                sections[i].tabIndex),
                                            buildPostTile: (post) {
                                              // 이슈 팩트
                                              if (sections[i].tabIndex == 4) {
                                                return _buildNewsListTile(
                                                  controller: controller,
                                                  post: post,
                                                  highlightTitle: false,
                                                );
                                              }

                                              // 포커스 팩트 / 인사이트 팩트
                                              final String title =
                                                  (post['title'] ?? '')
                                                      .toString();
                                              final String category =
                                                  (post['category'] ?? '')
                                                      .toString();
                                              final String postID =
                                                  (post['id'] ?? '').toString();
                                              final String date =
                                                  AppDate.format(post['date']);

                                              return AppPostListTile(
                                                title: title,
                                                category: category,
                                                date: date,
                                                postID: postID,
                                                post: post,
                                                onTap: () => controller
                                                    .handlePostTap(post),
                                              );
                                            },
                                          )

                                        // PC 포커스 팩트 / 인사이트 팩트는 기존 Grid
                                        : _buildSectionGrid(
                                            title: sections[i].title,
                                            posts: sections[i].posts,
                                            accentColor: sections[i].accent,
                                            controller: controller,

                                            // 인사이트 팩트는 가로 전체를 사용하는 1열
                                            crossAxisCount:
                                                sections[i].tabIndex == 3
                                                    ? 1
                                                    : crossCount,

                                            // 인사이트 팩트는 와이드 카드
                                            aspectRatio:
                                                sections[i].tabIndex == 3
                                                    ? 4.5
                                                    : aspectRatio,

                                            maxRows: sections[i].maxRows,
                                            onMore: () => controller.selectTab(
                                                sections[i].tabIndex),
                                          ),
                                    // 다음 비어있지 않은 섹션이 있을 때만 구분선
                                    if (sections
                                        .skip(i + 1)
                                        .any((s) => s.posts.isNotEmpty)) ...[
                                      SizedBox(
                                          height: isMobileLayout ? 24 : 40),
                                      const Divider(),
                                      SizedBox(
                                          height: isMobileLayout ? 24 : 40),
                                    ],
                                  ],
                              ],
                            );
                          }

                          if (controller.selectedIndex.value == 4) {
                            return AppSectionList(
                              title: '이슈 팩트',
                              posts: visibleList,
                              accentColor: AppColor.primary,
                              controller: controller,
                              showTitleDivider: true,
                              onMore: () {},
                              buildPostTile: (post) {
                                return _buildNewsListTile(
                                  controller: controller,
                                  post: post,
                                  highlightTitle: false,
                                );
                              },
                            );
                          }

                          if (controller.selectedIndex.value == 2) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 48,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '포커스 팩트',
                                      style: AppTextStyle.koBold20().copyWith(
                                        color: AppColor.focusFact,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Divider(
                                  height: 1,
                                  thickness: 2,
                                  color: AppColor.focusFact,
                                ),
                                const SizedBox(height: 16),
                                isMobileLayout
                                    ? buildList(posts: visibleList)
                                    : buildGrid(posts: visibleList),
                              ],
                            );
                          }

                          if (controller.selectedIndex.value == 3) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 48,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '인사이트 팩트',
                                      style: AppTextStyle.koBold20().copyWith(
                                        color: AppColor.yellow,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Divider(
                                  height: 1,
                                  thickness: 2,
                                  color: AppColor.yellow,
                                ),
                                const SizedBox(height: 16),
                                isMobileLayout
                                    ? buildList(posts: visibleList)
                                    : _buildPostGrid(
                                        posts: visibleList,
                                        controller: controller,
                                        crossAxisCount: 1,
                                        aspectRatio: 4.5,
                                      ),
                              ],
                            );
                          }

                          return buildGrid(posts: visibleList);
                        });
                      },
                    ),
                    const SizedBox(height: 60),
                    // const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          AppFooter(
            logo: 'TNM FACT',
            companyInfo: '제호: TNM 팩트 (TNM Fact)',
            name: '발행인: 김민진 | 편집인: 김민진',
            publeInfo: '등록번호: 금천 라00261 | 등록일: 2026.02.23',
            address: '발행소: 서울시 금천구 벚꽃로 73',
            contact: '연락처: tnmfact@gmail.com',
            service: '이용약관',
            privacy: '개인정보처리방침',
            copyright: '© 2026 TNM Fact. All rights reserved.',
            serviceTap: () => Get.toNamed(AppRoutes.service),
            privacyTap: () => Get.toNamed(AppRoutes.privacy),
          )
          // _buildFooter(),
        ],
      ),
    ),
  );
}

Future<void> _onLogoTap(HomeController controller) async {
  if (controller.isSearching.value) {
    controller.isSearching.value = false;
    controller.searchController.clear();
    _resetListForTab(controller, controller.selectedIndex.value);
  }
  controller.selectTab(0);
  controller.currentPage.value = 'home';
  if (controller.scrollController.hasClients) {
    controller.scrollController.jumpTo(0);
  }
  await _reloadTabData(controller, controller.selectedIndex.value);
}

Widget _buildSearchAction(
  BuildContext context,
  HomeController controller,
) {
  return Padding(
    padding: const EdgeInsets.only(
      right: 16,
      top: 12,
      bottom: 12,
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double hintFontSize = width > 1000 ? 14 : 10;

        if (ScreenUtil().screenWidth > 1000) {
          return Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              border: Border.all(
                color: AppColor.grey,
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(100.r),
            ),
            width: ScreenUtil().screenWidth / 4.5,
            height: 32,
            alignment: Alignment.center,
            child: TextField(
              focusNode: controller.searchFocusNode,
              controller: controller.searchController,
              textAlignVertical: TextAlignVertical.center,
              style: AppTextStyle.koRegular15().copyWith(
                color: AppColor.grey,
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  controller.isSearching.value = false;
                  _resetListForTab(
                    controller,
                    controller.selectedIndex.value,
                  );
                }
              },
              onSubmitted: (_) async {
                controller.clearFocus();

                if (controller.searchController.text.trim().isNotEmpty) {
                  await controller.findPost();
                } else {
                  await _reloadTabData(
                    controller,
                    controller.selectedIndex.value,
                  );
                }
              },
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                suffixIcon: LayoutBuilder(
                  builder: (context, iconConstraints) {
                    final double iconSize = iconConstraints.maxHeight * 0.6;

                    return IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        if (controller.searchController.text.isNotEmpty) {
                          await controller.findPost();
                        } else {
                          await _reloadTabData(
                            controller,
                            controller.selectedIndex.value,
                          );
                        }
                      },
                      icon: Icon(
                        Icons.search,
                        size: iconSize,
                        color: AppColor.grey,
                      ),
                    );
                  },
                ),
                hintText: '관심있는 키워드를 검색하세요',
                hintStyle: AppTextStyle.koRegular14().copyWith(
                  color: AppColor.grey,
                  fontSize: hintFontSize,
                ),
                border: InputBorder.none,
              ),
            ),
          );
        }

        return IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            _showSearchOverlay(context, controller);
          },
          icon: const Icon(
            Icons.search,
            size: 25,
            color: AppColor.grey,
          ),
        );
      },
    ),
  );
}

Widget _buildNewsListTile({
  required HomeController controller,
  required Map<String, dynamic> post,
  bool highlightTitle = false,
}) {
  final String title = (post['title'] ?? '').toString();
  final String date = AppDate.format(post['date']);
  final String excerpt =
      AppIssuePostListTile.firstSentence(post['final_article']);

  return AppIssuePostListTile(
    title: title,
    date: date,
    excerpt: excerpt,
    highlightTitle: highlightTitle,
    onTap: () => controller.handlePostTap(post),
  );
}

void _resetListForTab(HomeController controller, int tabIndex) {
  switch (tabIndex) {
    case 0:
      controller.postList.value = controller.originalPostList.toList();
      break;
    case 1:
      controller.dailyPostList.value =
          controller.originalDailyPostList.toList();
      break;
    case 2:
      controller.focusPostList.value =
          controller.originalFocusPostList.toList();
      break;
    case 3:
      controller.insightPostList.value =
          controller.originalInsightPostList.toList();
      break;
    case 4:
      controller.dailyPostList.value =
          controller.originalDailyPostList.toList();
      break;
  }
}

Future<void> _reloadTabData(HomeController controller, int tabIndex) async {
  switch (tabIndex) {
    case 0:
      await controller.loadAllPosts();
      break;
    case 1:
      await controller.loadDailyPosts();
      break;
    case 2:
      await controller.loadFocusPosts();
      break;
    case 3:
      await controller.loadInsightPosts();
      break;
    case 4:
      await controller.loadDailyPosts();
      break;
    default:
      await controller.loadAllPosts();
  }
}

void _showSearchOverlay(BuildContext context, HomeController controller) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '검색',
    barrierColor: Colors.black26,
    pageBuilder: (context, animation, secondaryAnimation) {
      return MediaQuery(
        // ✅ 키보드 인셋을 무시하도록 복제
        data: MediaQuery.of(context).removeViewInsets(removeBottom: true),
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 56.h, 16.w, 0),
            child: Material(
              borderRadius: BorderRadius.circular(16.r),
              color: AppColor.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: controller.searchController,
                        style: AppTextStyle.koRegular15()
                            .copyWith(color: AppColor.black),
                        decoration: InputDecoration(
                          hintText: "관심있는 교육 키워드를 검색하세요",
                          hintStyle: AppTextStyle.koRegular14()
                              .copyWith(color: AppColor.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: AppColor.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide:
                                BorderSide(color: AppColor.primary, width: 2.w),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                        onSubmitted: (_) async {
                          Navigator.of(context).pop();
                          await Future.delayed(
                              const Duration(milliseconds: 100));
                          await _performSearch(controller);
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    IconButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await _performSearch(controller);
                      },
                      icon:
                          Icon(Icons.search, color: AppColor.primary, size: 28),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        )),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        ),
      );
    },
  );
}

Future<void> _performSearch(HomeController controller) async {
  controller.clearFocus();
  final query = controller.searchController.text.trim();

  if (query.isNotEmpty) {
    // ✅ 검색 모드 진입
    controller.isSearching.value = true;

    // ✅ 기존 리스트 유지 → 검색결과로 덮기
    await controller.findPost();

    // ✅ 검색 후 항상 최상단으로 이동
    controller.scrollController.jumpTo(0);
  } else {
    // ✅ 검색어 없으면 원래 탭 복구
    controller.isSearching.value = false;
    controller.searchController.clear();
    _resetListForTab(controller, controller.selectedIndex.value);
  }
}

Widget _buildSectionGrid({
  required String title,
  required List<Map<String, dynamic>> posts,
  required HomeController controller,
  required int crossAxisCount,
  required double aspectRatio,
  required int maxRows,
  required VoidCallback onMore,
  required Color accentColor,
}) {
  final int maxItems = crossAxisCount * maxRows;
  final bool showMore = posts.length > maxItems;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: AppTextStyle.koBold20().copyWith(color: accentColor)),
            if (showMore)
              TextButton(
                onPressed: () {
                  onMore();
                  // ✅ 부드러운 스크롤 대신 즉시 최상단으로 이동
                  controller.scrollController.jumpTo(0);
                },
                child: Text('>> 더보기',
                    style: AppTextStyle.koSemiBold14()
                        .copyWith(color: accentColor)),
              ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Divider(
        height: 1,
        thickness: 2,
        color: accentColor,
      ),
      const SizedBox(height: 32),
      posts.isEmpty
          ? Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text('게시글이 없습니다.',
                  style: AppTextStyle.koRegular18()
                      .copyWith(color: AppColor.grey)),
            )
          : _buildPostGrid(
              posts: posts,
              controller: controller,
              crossAxisCount: crossAxisCount,
              aspectRatio: aspectRatio,
              maxItems: maxItems,
            ),
    ],
  );
}

Widget _buildPostGrid({
  required List<Map<String, dynamic>> posts,
  required HomeController controller,
  required int crossAxisCount,
  required double aspectRatio,
  int? maxItems,
}) {
  if (posts.isEmpty) {
    return Center(
      child: Text('게시글이 없습니다.', style: AppTextStyle.koRegular18()),
    );
  }

  final int itemCount =
      maxItems == null ? posts.length : min(posts.length, maxItems);

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: itemCount,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 32,
      mainAxisSpacing: 32,
      childAspectRatio: aspectRatio,
    ),
    itemBuilder: (context, index) {
      final post = posts[index];
      return _buildPostCard(controller: controller, post: post);
    },
  );
}

Widget _buildPostCard({
  required HomeController controller,
  required Map<String, dynamic> post,
}) {
  final timestamp = post['date'];
  String formattedDate = '';

  if (timestamp != null) {
    if (timestamp is Timestamp) {
      formattedDate = DateFormat('yyyy-MM-dd').format(timestamp.toDate());
    } else if (timestamp is String) {
      final parsed = DateTime.tryParse(timestamp);
      if (parsed != null) {
        formattedDate = DateFormat('yyyy.MM.dd').format(parsed);
      } else {
        formattedDate = timestamp;
      }
    }
  }

  final title = (post['title'] ?? '').toString();
  final category = (post['category'] ?? '').toString();

  return GestureDetector(
    onTap: () => controller.handlePostTap(post),
    child: Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadow,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColor.border,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: CategoryHelper.getCategoryBackgroundColor(category),
              borderRadius: BorderRadius.circular(80),
            ),
            child: Text(
              category,
              style: AppTextStyle.koSemiBold14().copyWith(
                color: CategoryHelper.getCategoryColor(category),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title.isNotEmpty ? title : formattedDate,
            style: AppTextStyle.koSemiBold18(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Text(
              (post['final_article'] ?? '')
                  .toString()
                  .replaceAll(RegExp(r'<br\s*/?>'), '\n')
                  .replaceAll(RegExp(r'</p>'), '\n\n')
                  .replaceAll(RegExp(r'<[^>]*>'), '')
                  .trim(),
              style: AppTextStyle.koRegular15().copyWith(
                color: AppColor.grey,
              ),
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              formattedDate,
              style: AppTextStyle.koRegular12().copyWith(color: AppColor.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}
