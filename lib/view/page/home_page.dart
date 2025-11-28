import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/controller/home_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';
import 'package:tnm_fact/view/widget/app_title_button.dart';

// ✅ 내부 상세 페이지 위젯 import 제거됨
// import 'package:tnm_fact/view/page/detail_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  static const route = '/homepage';

  // 카테고리별 색상 반환 함수
  static Color getCategoryColor(String category) {
    switch (category) {
      case '데일리 팩트':
        return AppColor.primary;
      case '인사이트 팩트':
        return AppColor.yellow;
      case '포커스 팩트':
        return AppColor.focusFact;
      case '피플&뷰':
        return AppColor.peopleView;
      default:
        return AppColor.grey;
    }
  }

  // 카테고리별 배경색 반환 함수
  static Color getCategoryBackgroundColor(String category) {
    switch (category) {
      case '데일리 팩트':
        return AppColor.primary.withOpacity(0.1);
      case '인사이트 팩트':
        return AppColor.yellow.withOpacity(0.2);
      case '포커스 팩트':
        return AppColor.focusFact.withOpacity(0.1);
      case '피플&뷰':
        return AppColor.peopleView.withOpacity(0.2);
      default:
        return AppColor.grey.withOpacity(0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdminController adminController = Get.find<AdminController>();

    return Scaffold(
      backgroundColor: AppColor.background,
      // backgroundColor: AppColor.primary.withOpacity(0.2),
      appBar: AppBar(
        leadingWidth: ScreenUtil().screenWidth / 5,
        backgroundColor: AppColor.white,
        titleSpacing: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: GestureDetector(
            onTap: () {
              controller.selectTab(0);
              controller.currentPage.value = 'home';
            },
            child: SvgPicture.asset(
              'assets/images/logo.svg',
              height: 32.h,
              fit: BoxFit.contain,
            ),
            // child: Image.asset(
            //   'assets/images/logo.png',
            //   height: 32.h,
            //   fit: BoxFit.contain,
            // ),
          ),
        ),
        title: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Obx(() {
                return AppTitleButton(
                  color: controller.selectedIndex.value == 0
                      ? AppColor.primary
                      : AppColor.black,
                  onPressed: () {
                    controller.selectTab(0);
                    controller.currentPage.value = 'home'; // ✅ 홈으로 전환
                  },
                  title: '전체기사',
                );
              }),
              SizedBox(width: 16.w),
              Obx(() {
                return AppTitleButton(
                  title: '데일리팩트',
                  color: controller.selectedIndex.value == 1
                      ? AppColor.primary
                      : AppColor.black,
                  onPressed: () {
                    controller.selectTab(1);
                    controller.currentPage.value = 'home'; // ✅ 홈으로 전환
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
                  onPressed: () {
                    controller.selectTab(2);
                    controller.currentPage.value = 'home'; // ✅ 홈으로 전환
                  },
                );
              }),
              SizedBox(width: 16.w),
              Obx(() {
                return AppTitleButton(
                  title: '인사이트팩트',
                  color: controller.selectedIndex.value == 3
                      ? AppColor.primary
                      : AppColor.black,
                  onPressed: () {
                    controller.selectTab(3);
                    controller.currentPage.value = 'home'; // ✅ 홈으로 전환
                  },
                );
              }),
              SizedBox(width: 16.w),
              Obx(() {
                return AppTitleButton(
                  title: '피플&뷰',
                  color: controller.selectedIndex.value == 4
                      ? AppColor.primary
                      : AppColor.black,
                  onPressed: () {
                    controller.selectTab(4);
                    controller.currentPage.value = 'home'; // ✅ 홈으로 전환
                  },
                );
              }),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16, top: 12, bottom: 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                double hintFontSize = width > 1000 ? 14 : 10;

                if (ScreenUtil().screenWidth > 1000) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      border: Border.all(color: AppColor.grey, width: 1.w),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    width: ScreenUtil().screenWidth / 4.5,
                    alignment: Alignment.center,
                    child: TextField(
                      focusNode: controller.searchFocusNode,
                      controller: controller.searchController,
                      textAlignVertical: TextAlignVertical.center,
                      style: AppTextStyle.koRegular15().copyWith(
                        color: AppColor.grey,
                        // fontSize: hintFontSize,
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
                        controller.clearFocus(); // ✅ 포커스 해제
                        if (controller.searchController.text
                            .trim()
                            .isNotEmpty) {
                          await controller.findPost(); // ✅ 엔터 입력 시 검색 실행
                        } else {
                          // ✅ 검색어가 비어있으면 탭에 맞는 전체 목록 불러오기
                          await _reloadTabData(
                              controller, controller.selectedIndex.value);
                        }
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        suffixIcon: LayoutBuilder(
                          builder: (context, iconConstraints) {
                            final double iconSize =
                                iconConstraints.maxHeight * 0.6;
                            return IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                print('검색 아이콘 클릭됨');
                                if (controller.searchController.text
                                    .isNotEmpty) {
                                  await controller.findPost();
                                } else {
                                  await _reloadTabData(
                                      controller, controller.selectedIndex.value);
                                }
                              },
                              icon: Icon(Icons.search,
                                  size: iconSize, color: AppColor.grey),
                            );
                          },
                        ),
                        hintText: "관심있는 교육 키워드를 검색하세요",
                        hintStyle: AppTextStyle.koRegular14().copyWith(
                          color: AppColor.grey,
                          fontSize: hintFontSize,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  );
                } else {
                  return IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _showSearchOverlay(context, controller);
                    },
                    icon: Icon(Icons.search, size: 25, color: AppColor.grey),
                  );
                }
              },
            ),
          ),
        ],
      ),

      // ✅ BODY 분기
      body: Obx(() {
        if (controller.currentPage.value == 'detail' &&
            controller.selectedPost != null) {
          return DetailView(post: controller.selectedPost!);
        } else {
          return _buildHomeContent(controller, adminController);
        }
      }),
    );
  }

  // ✅ 기존 홈 콘텐츠 (Grid 포함)
  Widget _buildHomeContent(
      HomeController controller, AdminController adminController) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1260),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 48),
                      AutoSizeText(
                        '진실을 전달하는 미디어',
                        maxFontSize: 60,
                        minFontSize: 20,
                        style: AppTextStyle.koBold35(),
                      ),
                      const SizedBox(height: 48),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final double width = constraints.maxWidth;
                          final int crossCount = width <= 680
                              ? 2
                              : width <= 1000
                                  ? 3
                                  : 4;
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

                          return Obx(() {
                            List<Map<String, dynamic>> visibleList;
                            switch (controller.selectedIndex.value) {
                              case 1:
                                visibleList = controller.dailyPostList;
                                break;
                              case 2:
                                visibleList = controller.focusPostList;
                                break;
                              case 3:
                                visibleList = controller.insightPostList;
                                break;
                              case 4:
                                visibleList = controller.peoplePostList;
                                break;
                              default:
                                visibleList = controller.postList;
                            }

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
                                  title: '데일리 팩트',
                                  posts: controller.dailyPostList,
                                  accent: AppColor.primary,
                                  maxRows: 2,
                                  tabIndex: 1,
                                ),
                                (
                                  title: '포커스 팩트',
                                  posts: controller.focusPostList,
                                  accent: AppColor.focusFact,
                                  maxRows: 1,
                                  tabIndex: 2,
                                ),
                                (
                                  title: '인사이트 팩트',
                                  posts: controller.insightPostList,
                                  accent: AppColor.yellow,
                                  maxRows: 1,
                                  tabIndex: 3,
                                ),
                                (
                                  title: '피플&뷰',
                                  posts: controller.peoplePostList,
                                  accent: AppColor.peopleView,
                                  maxRows: 1,
                                  tabIndex: 4,
                                ),
                              ];

                              return Column(
                                children: [
                                  for (int i = 0; i < sections.length; i++) ...[
                                    _buildSectionGrid(
                                      title: sections[i].title,
                                      posts: sections[i].posts,
                                      accentColor: sections[i].accent,
                                      controller: controller,
                                      crossAxisCount: crossCount,
                                      aspectRatio: aspectRatio,
                                      maxRows: sections[i].maxRows,
                                      onMore: () =>
                                          controller.selectTab(sections[i].tabIndex),
                                    ),
                                    if (i != sections.length - 1) ...[
                                      const SizedBox(height: 40),
                                      Divider(),
                                      const SizedBox(height: 40),
                                    ],
                                  ],
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
            _buildFooter(),
          ],
        ),
      ),
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
        controller.peoplePostList.value =
            controller.originalPeoplePostList.toList();
        break;
    }
  }

  Future<void> _reloadTabData(
      HomeController controller, int tabIndex) async {
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
        await controller.loadPeoplePosts();
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
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 56.h, 16.w, 0),
            child: Material(
              borderRadius: BorderRadius.circular(16.r),
              color: AppColor.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h)
                    .copyWith(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20),
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
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: AppColor.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                                color: AppColor.primary, width: 2.w),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            controller.isSearching.value = false;
                          }
                        },
                        onSubmitted: (_) async {
                          Navigator.of(context).pop();
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
                      icon: Icon(
                        Icons.search,
                        color: AppColor.primary,
                        size: 28
                        ,
                      ),
                    ),
                  ],
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
    if (controller.searchController.text.trim().isNotEmpty) {
      controller.isSearching.value = true;
      await controller.findPost();
    } else {
      controller.isSearching.value = false;
      await _reloadTabData(controller, controller.selectedIndex.value);
    }
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
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: AppTextStyle.koBold20().copyWith(color: accentColor)),
          if (showMore)
            TextButton(
              onPressed: onMore,
              child: Text('>> 더보기',
                  style:
                      AppTextStyle.koSemiBold14().copyWith(color: accentColor)),
            ),
        ],
      ),
      const SizedBox(height: 16),
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
onTap: () async {
  print('onTap 눌림');
  final user = FirebaseAuth.instance.currentUser;
  final postId = post['id'];
  final AdminController adminController = Get.find<AdminController>();
  if (postId.isNotEmpty) {
  await adminController.incrementViewCount(postId);
}

  if (user == null) {
    print('로그인 안 된 상태, 익명 로그인 처리');
    final cred = await FirebaseAuth.instance.signInAnonymously();
    final userId = cred.user!.uid;
    await adminController.incrementViewCount(postId);
    controller.logVisit(userId);
  } else {
    final userId = user.uid;
    await adminController.incrementViewCount(postId);
    controller.logVisit(userId);
  }

  controller.selectedPost = post;
  controller.currentPage.value = 'detail';
},
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
              color: HomePage.getCategoryBackgroundColor(category),
              borderRadius: BorderRadius.circular(80),
            ),
            child: Text(
              category,
              style: AppTextStyle.koSemiBold14().copyWith(
                color: HomePage.getCategoryColor(category),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title.isNotEmpty ? title : '[오늘의 교육 뉴스] $formattedDate',
            style: AppTextStyle.koSemiBold18(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Text(
              (post['final_article'] ?? '').toString(),
              style: AppTextStyle.koRegular15().copyWith(color: AppColor.grey),
              maxLines: 3,
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

// ✅ 내부 전환용 DetailView
class DetailView extends StatelessWidget {
  final Map<String, dynamic> post;
  const DetailView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final rawDate = post['date'];
    String titleDate = '';

    if (rawDate is Timestamp) {
      titleDate = DateFormat('yy.MM.dd').format(rawDate.toDate());
    } else if (rawDate is String) {
      try {
        final parsedDate = DateTime.parse(rawDate);
        titleDate = DateFormat('yy.MM.dd').format(parsedDate);
      } catch (e) {
        print('⚠️ 날짜 파싱 실패: $rawDate');
      }
    }

    print('post date: ${post['date']}');
    print('titleDate: $titleDate');

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1260),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  GestureDetector(
                    onTap: () {
                      final controller = Get.find<HomeController>();
                      controller.currentPage.value = 'home';
                    },
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back, color: AppColor.primary),
                        SizedBox(width: 4.w),
                        Text('목록으로 돌아가기',
                            style: AppTextStyle.koSemiBold14()
                                .copyWith(color: AppColor.primary)),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: HomePage.getCategoryBackgroundColor(
                          post['category'] ?? ''),
                      borderRadius: BorderRadius.circular(80.r),
                    ),
                    child: Text(
                      post['category'] ?? '',
                      style: AppTextStyle.koSemiBold14().copyWith(
                        color: HomePage.getCategoryColor(post['category'] ?? ''),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(post['title'] ?? '[오늘의 교육 뉴스] $titleDate',
                      style: TextStyle(
                          fontFamily: 'PretendardBold',
                          fontSize: 30,
                          color: AppColor.black)),
                  SizedBox(height: 8.h),
                  Text('작성자: ${post['editor']} | $titleDate',
                      style: AppTextStyle.koRegular14()),
                  SizedBox(height: 24.h),
                  Text(post['final_article'],
                      style: AppTextStyle.koRegular18()
                          .copyWith(color: AppColor.black)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ✅ 하단 푸터
// ✅ 하단 푸터
Widget _buildFooter() {
  return Container(
    width: double.infinity,
    color: Colors.grey[100],
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 72),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1260),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 로고 & 제호 ---
              Text(
                'TNM FACT',
                style: AppTextStyle.koBold18(),
              ),
              const SizedBox(height: 8),

              // --- 발행 정보 ---
              Text(
                '제호: TNM 팩트 (TNM Fact)',
                style: AppTextStyle.koRegular14()
                    .copyWith(color: AppColor.grey),
              ),
              Text(
                '발행인: 김민진 | 편집인: 김병국',
                style: AppTextStyle.koRegular14()
                    .copyWith(color: AppColor.grey),
              ),
              const SizedBox(height: 4),
              Text(
                '등록번호: (등록 후 기재 예정) | 등록일: (등록 후 기재 예정)',
                style: AppTextStyle.koRegular14()
                    .copyWith(color: AppColor.grey),
              ),
              const SizedBox(height: 4),
              Text(
                '발행소: 서울시 금천구 벚꽃로 73',
                style: AppTextStyle.koRegular14()
                    .copyWith(color: AppColor.grey),
              ),
              const SizedBox(height: 4),
              Text(
                '연락처: tnmfact@gmail.com',
                style: AppTextStyle.koRegular14()
                    .copyWith(color: AppColor.grey),
              ),

              // --- 구분선 ---
              const SizedBox(height: 16),
              Divider(height: 32, color: AppColor.lightGrey),

              // --- 저작권 문구 ---
              Text(
                '© 2025 TNM Fact. All rights reserved.',
                style: AppTextStyle.koRegular12()
                    .copyWith(color: AppColor.grey),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
