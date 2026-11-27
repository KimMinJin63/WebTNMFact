import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/helpers/app_category_helper.dart';
import 'package:tnm_fact/utils/admin_breakpoint.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';
import 'package:tnm_fact/view/widget/app_admin_top_bar.dart';
import 'package:tnm_fact/view/widget/app_post.dart';
import 'package:tnm_fact/view/widget/app_post_title.dart';

class AdminPage extends GetView<AdminController> {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RxBool isReady = false.obs; // ✅ 초기 로딩 상태
    final controller = Get.find<AdminController>();
    final box = GetStorage();

    // ✅ 첫 프레임 후 200ms 지연 → 자연스럽게 렌더
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!isReady.value) isReady.value = true;
    });

    return Obx(() {
      // ✅ 로딩 인디케이터 (폰트 + 데이터 초기화 대기)
      if (!isReady.value) {
        return Scaffold(
          backgroundColor: AppColor.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Colors.blueAccent,
                  strokeWidth: 3,
                ),
                SizedBox(height: 16.h),
                Text('관리 페이지를 불러오는 중입니다...',
                    style: AppTextStyle.koSemiBold14()
                        .copyWith(color: AppColor.grey)),
              ],
            ),
          ),
        );
      }

      // ✅ 본문 렌더링
      final bool isNarrow =
          MediaQuery.sizeOf(context).width < AdminBreakpoint.mobile;
      return Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          children: [
            // -------------------------------
            // 상단 헤더 영역
            // -------------------------------
            Padding(
              padding: isNarrow
                  ? const EdgeInsets.fromLTRB(16, 16, 8, 12)
                  : EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 제목
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('콘텐츠 관리',
                            style: (isNarrow
                                    ? AppTextStyle.koBold20()
                                    : AppTextStyle.koBold28())
                                .copyWith(color: AppColor.black)),
                        Text('게시물을 관리하고 새 글을 작성합니다.',
                            style: (isNarrow
                                    ? AppTextStyle.koRegular14()
                                    : AppTextStyle.koSemiBold16())
                                .copyWith(color: AppColor.grey)),
                      ],
                    ),
                  ),
                  // 작성 버튼
                  Padding(
                    padding: EdgeInsets.only(right: isNarrow ? 0 : 20.w),
                    child: TextButton(
                      onPressed: () {
                        controller.isCreate.value = true;
                        print('✏️ [관리자] 새 기사 작성 버튼 클릭됨');
                      },
                      child: Text(
                        '기사 작성',
                        style: AppTextStyle.koSemiBold16()
                            .copyWith(color: AppColor.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // -------------------------------
            // 본문 콘텐츠
            // -------------------------------
            Expanded(
              child: Container(
                color: AppColor.lightGrey,
                padding: EdgeInsets.all(isNarrow ? 8 : 20.w),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: AppColor.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isNarrow ? 12 : 16.0.w),
                    child: Column(
                      children: [
                        // 🔹 상단 탭 & 검색 바
                        Obx(() {
                          return AppAdminTopBar(
                            totalCount: controller.totalCount.value,
                            publishedCount: controller.publishedCount.value,
                            pendingCount: controller.pendingCount.value,
                            selectedIndex: controller.selectedIndex.value,
                            searchController: controller.searchController,
                            onTap: () {
                              if (controller.selectedIndex == 0) {
                                controller.searchController.text.isNotEmpty
                                    ? controller.findPost()
                                    : controller.fetchAllPosts();
                              } else if (controller.selectedIndex == 1) {
                                controller.searchController.text.isNotEmpty
                                    ? controller.findPost()
                                    : controller.fetchDonePosts();
                              } else if (controller.selectedIndex == 2) {
                                controller.searchController.text.isNotEmpty
                                    ? controller.findPost()
                                    : controller.fetchNotPosts();
                              }
                            },
                            onSubmitted: (_) async {
                              controller.clearFocus();
                              if (controller.searchController.text
                                  .trim()
                                  .isNotEmpty) {
                                await controller.findPost();
                              } else {
                                if (controller.selectedIndex.value == 0) {
                                  await controller.fetchAllPosts();
                                } else if (controller.selectedIndex.value ==
                                    1) {
                                  await controller.fetchDonePosts();
                                } else {
                                  await controller.fetchNotPosts();
                                }
                              }
                            },
                            onChanged: (value) {
                              if (value.isEmpty) {
                                if (controller.selectedIndex == 0) {
                                  controller.postList.value =
                                      controller.originalPostList.toList();
                                } else if (controller.selectedIndex == 1) {
                                  controller.donePostList.value =
                                      controller.originalDonePostList.toList();
                                } else {
                                  controller.notPostList.value =
                                      controller.originalNotPostList.toList();
                                }
                              }
                            },
                            onTapAll: () => controller.selectTab(0),
                            onTapPublished: () => controller.selectTab(1),
                            onTapPending: () => controller.selectTab(2),
                          );
                        }),

                        SizedBox(height: 12.h),

                        // 🔹 카테고리 필터 (이슈 팩트 선택 시 세부 분류 필터 표시)
                        Obx(() => _buildCategoryFilter(controller)),

                        SizedBox(height: 16.h),

                        // 🔹 헤더
                        AppPostTitle(),
                        SizedBox(height: 5.h),

                        // 🔹 리스트
                        Expanded(
                          child: Obx(() {
                            List<Map<String, dynamic>> visibleList;
                            switch (controller.selectedIndex.value) {
                              case 1:
                                visibleList = controller.donePostList;
                                break;
                              case 2:
                                visibleList = controller.notPostList;
                                break;
                              case 0:
                              default:
                                visibleList = controller.postList;
                                break;
                            }
                            visibleList =
                                controller.applyCategoryFilter(visibleList);

                            // ✅ 빈 목록 처리
                            if (visibleList.isEmpty) {
                              return Center(
                                child: Text(
                                  '게시글이 없습니다.',
                                  style: AppTextStyle.koSemiBold14()
                                      .copyWith(color: AppColor.grey),
                                ),
                              );
                            }

                            // ✅ 리스트 표시
                            return ListView.builder(
                              itemCount: visibleList.length,
                              itemBuilder: (context, index) {
                                final post = visibleList[index];
                                final title =
                                    _getDisplayTitle(post, controller);

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: isNarrow ? 4 : 8.h),
                                  child: AppPost(
                                    title: title,
                                    author: CategoryHelper.getCategoryName(
                                        post['category']),
                                    // author:
                                    //     post['editor'] ?? '편집장 김병국',
                                    category: post['category'],
                                    createdAt:
                                        post['date'] ?? post['createdAt'],
                                    status: post['status'] ?? '발행',
                                    textColor: post['status'] == '발행'
                                        ? AppColor.deepGreen
                                        : AppColor.black,
                                    color: post['status'] == '발행'
                                        ? AppColor.green.withOpacity(0.2)
                                        : AppColor.lightGrey,
                                    onContentTap: () {
                                      controller.openEditPage(post);
                                      controller.isEditing.value = true;
                                      controller.originTabIndex!.value =
                                          controller.menuSelectedIndex.value;
                                    },
                                    onDeleteTap: () {
                                      Get.dialog(
                                        AlertDialog(
                                          title: const Text('게시글 삭제'),
                                          content: const Text(
                                              '정말로 이 게시글을 삭제하시겠습니까?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Get.back(),
                                              child: const Text('취소'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                controller
                                                    .deletePost(post['id']);
                                                controller.fetchAllPosts();
                                                controller.fetchAllPostCounts();
                                                Get.back();
                                              },
                                              child: const Text('삭제'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    onTap: () {
                                      controller.openEditPage(post);
                                      controller.isEditing.value = true;
                                    },
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  /// 🔹 현재 상태 탭(모두/발행됨/대기중)의 목록
  List<Map<String, dynamic>> _statusList(AdminController controller) {
    switch (controller.selectedIndex.value) {
      case 1:
        return controller.donePostList;
      case 2:
        return controller.notPostList;
      default:
        return controller.postList;
    }
  }

  /// 🔹 카테고리 필터 줄 + (이슈 팩트일 때) 세부 분류 필터 줄
  Widget _buildCategoryFilter(AdminController controller) {
    final list = _statusList(controller);
    const categories = ['이슈 팩트', '포커스 팩트', '인사이트 팩트', '피플&뷰'];
    final issuePosts = list.where((p) => p['category'] == '이슈 팩트').toList();

    Widget row(String label, List<(String, int)> items, String selected,
        ValueChanged<String> onSelect) {
      return Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(label,
                style:
                    AppTextStyle.koSemiBold14().copyWith(color: AppColor.grey)),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    if (i > 0)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text('|',
                            style: TextStyle(color: Colors.grey.shade400)),
                      ),
                    InkWell(
                      onTap: () => onSelect(items[i].$1),
                      child: Text(
                        '${items[i].$1} (${items[i].$2})',
                        style: AppTextStyle.koRegular14().copyWith(
                          color: selected == items[i].$1
                              ? AppColor.black
                              : AppColor.primary,
                          fontWeight: selected == items[i].$1
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        row(
          '카테고리',
          [
            ('전체', list.length),
            for (final c in categories)
              (c, list.where((p) => p['category'] == c).length),
          ],
          controller.categoryFilter.value,
          controller.selectCategoryFilter,
        ),
        if (controller.categoryFilter.value == '이슈 팩트') ...[
          SizedBox(height: 8.h),
          row(
            '세부 분류',
            [
              ('전체', issuePosts.length),
              for (final sub in CategoryHelper.issueSubCategories)
                (sub, issuePosts.where((p) => p['subCategory'] == sub).length),
              (
                '미분류',
                issuePosts
                    .where((p) => (p['subCategory'] ?? '').toString().isEmpty)
                    .length
              ),
            ],
            controller.subCategoryFilter.value,
            (v) => controller.subCategoryFilter.value = v,
          ),
        ],
      ],
    );
  }

  /// 🔹 타이틀 변환 로직 분리
  String _getDisplayTitle(
      Map<String, dynamic> post, AdminController controller) {
    final title = (post['title'] ?? '').toString().trim();
    final rawDate = (post['date'] ?? '').toString().trim();
    final category = (post['category'] ?? '').toString();

    String formattedDate = rawDate;
    try {
      final parsed = DateTime.tryParse(rawDate);
      if (parsed != null) {
        formattedDate = DateFormat('yy.MM.dd').format(parsed);
      }
    } catch (_) {
      formattedDate = rawDate;
    }

    if (category == '이슈 팩트') {
      if (title.isEmpty) {
        return formattedDate;
      }
      // if (title.startsWith('[오늘의 주요 이슈 TOP 3]')) {
      //   return title;
      // }
      return title;
    }
    return title.isEmpty ? formattedDate : title;
  }
}
