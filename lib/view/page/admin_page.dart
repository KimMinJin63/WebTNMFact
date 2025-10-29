import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';
import 'package:tnm_fact/view/page/create_page.dart';
import 'package:tnm_fact/view/page/edit_page.dart';
import 'package:tnm_fact/view/widget/app_admin_top_bar.dart';
import 'package:tnm_fact/view/widget/app_post.dart';
import 'package:tnm_fact/view/widget/app_post_title.dart';

class AdminPage extends GetView<AdminController> {
  const AdminPage({super.key});
  static const String route = '/admin';

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenUtil().screenWidth;
    final bool isExtended = screenWidth > 600; // 기준 너비
    final double railWidth = isExtended ? 240.w : 72.w;
    final box = GetStorage();

    String getDisplayTitle(Map<String, dynamic> post) {
      final title = (post['title'] ?? '').toString().trim();
      final rawDate = (post['date'] ?? '').toString().trim();
      final category = (post['category'] ?? '').toString();

      // 🔹 날짜 포맷 변환 ("2025-10-22 15:19" → "25-10-22")
      String formattedDate = rawDate;
      try {
        final parsed = DateTime.tryParse(rawDate);
        if (parsed != null) {
          formattedDate = DateFormat('yy.MM.dd').format(parsed);
        }
      } catch (_) {
        // 파싱 실패 시 원본 유지
        formattedDate = rawDate;
      }

      // 🔹 데일리 팩트인 경우
      if (category == '데일리 팩트') {
        if (title.isEmpty || title == '[오늘의 교육 뉴스]' || title == '[오늘의 교육 뉴스]') {
          return '[오늘의 교육 뉴스] $formattedDate';
        }

        if (title.startsWith('[오늘의 교육 뉴스]')) {
          return title;
        }

        return '[오늘의 교육 뉴스] $title';
      }

      // 🔹 인사이트 팩트 등 다른 카테고리
      return title.isEmpty ? formattedDate : title;
    }

    return Scaffold(
      backgroundColor: AppColor.white,
      body:

          /// 우측 콘텐츠 영역
          Column(
        children: [
          /// 상단 타이틀
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            child: SizedBox(
              width: double.infinity,
              height: 70.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('콘텐츠 관리',
                          style: AppTextStyle.koBold28()
                              .copyWith(color: AppColor.black)),
                      Text('게시물을 관리하고 새 글을 작성합니다.',
                          style: AppTextStyle.koSemiBold12()
                              .copyWith(color: AppColor.grey)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20.w),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: TextButton(
                        child: Text('기사 작성', style: AppTextStyle.koBold13()),
                        onPressed: () {
                          controller.isCreate.value = true;
                          // Get.toNamed(CreatePage.route); // 글 작성 페이지로 이동
                          // 여기에 글 작성 로직 추가
                          print('글 작성 버튼 클릭됨');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 본문
          Expanded(
            child: Container(
              color: AppColor.lightGrey,
              padding: EdgeInsets.all(20.w),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: AppColor.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: Column(
                    children: [
                      /// 상단 탭/검색 바
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
                            controller.clearFocus(); // ✅ 포커스 해제
                            if (controller.searchController.text
                                .trim()
                                .isNotEmpty) {
                              await controller.findPost(); // ✅ 엔터 입력 시 검색 실행
                            } else {
                              // ✅ 검색어가 비어있으면 탭에 맞는 전체 목록 불러오기
                              if (controller.selectedIndex.value == 0) {
                                await controller.fetchAllPosts();
                              } else if (controller.selectedIndex.value == 1) {
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
                      SizedBox(height: 16.h),

                      /// 헤더
                      AppPostTitle(),
                      SizedBox(height: 5.h),

                      /// 리스트
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
                          return ListView.builder(
                            itemCount: visibleList.length,
                            itemBuilder: (context, index) {
                              final post = visibleList[index];

                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: AppPost(
                                  title: getDisplayTitle(post),
                                  // author: '편집장 김병국',
                                  author: post['editor'] ?? '편집장 김병국',
                                  category: post['category'],
                                  createdAt: post['date'] ?? post['createdAt'],
                                  status: post['status'] ?? '발행',
                                  textColor: post['status'] == '발행'
                                      ? AppColor.deepGreen
                                      : AppColor.black,
                                  color: post['status'] == '발행'
                                      ? AppColor.green.withOpacity(0.2)
                                      : AppColor.lightGrey,
                                  onContentTap: () {
                                    // box.write('post', post);

                                    controller.openEditPage(post);
                                    print(
                                        '어드민 페이지 잘 받아오나?? : ${getDisplayTitle(post)}');
                                    print(
                                        '어드민 페이지 잘 받아오나?? : ${post['content']}');
                                    print(
                                        '어드민 페이지 잘 받아오나?? : ${post['category']}');
                                    print(
                                        '어드민 페이지 잘 받아오나?? : ${post['status']}');
                                    controller.isEditing.value =
                                        true; // 🔹 편집 모드 ON
 controller.originTabIndex!.value = controller.menuSelectedIndex.value;
                                    // print(
                                    //     '잘 받아오나?? : ${box.read('post')['title']}');
                                    // print(
                                    //     '잘 받아오나?? : ${box.read('post')['content']}');
                                    // print(
                                    //     '잘 받아오나?? : ${box.read('post')['category']}');
                                    // print(
                                    //     '잘 받아오나?? : ${box.read('post')['status']}');

                                    // onContentTap: () => Get.toNamed(
                                    //     EditPage.route,
                                    //     arguments: post),
                                  },
                                  onDeleteTap: () {
                                    Get.dialog(
                                      AlertDialog(
                                        title: const Text('게시글 삭제'),
                                        content:
                                            const Text('정말로 이 게시글을 삭제하시겠습니까?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Get.back(), // 다이얼로그 닫기
                                            child: const Text('취소'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              controller.deletePost(
                                                post['id'],
                                              );
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
                                    controller.isEditing.value =
                                        true; // 🔹 편집 모드 ON
                                  },

                                  // onTap: () => Get.toNamed(EditPage.route,
                                  //     arguments: post),
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
  }
}
