import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '관리 페이지',
            style: AppTextStyle.koBold28().copyWith(color: AppColor.black),
          ),
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 32.w),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: TextButton(
                  child: Text('기사 작성'),
                  onPressed: () {
                    Get.toNamed(CreatePage.route); // 글 작성 페이지로 이동
                    // 여기에 글 작성 로직 추가
                    print('글 작성 버튼 클릭됨');
                  },
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          child: Column(
            children: [
              Obx(() {
                return AppAdminTopBar(
                  totalCount: controller.totalCount.value,
                  publishedCount: controller.publishedCount.value,
                  pendingCount: controller.pendingCount.value,
                  selectedIndex: controller.selectedIndex.value,
                  searchController: controller.searchController,
                  onTap: () {
                    if (controller.selectedIndex == 0) {
                      print('모두 탭 클릭');
                      if (controller.searchController.text.isNotEmpty) {
                        controller.findPost();
                      } else {
                        controller.fetchAllPosts();
                      }
                    } else if (controller.selectedIndex == 1) {
                      print('발행됨 탭 클릭');
                      if (controller.searchController.text.isNotEmpty) {
                        controller.findPost();
                      } else {
                        controller.fetchDonePosts();
                      }
                    } else if (controller.selectedIndex == 2) {
                      print('대기중 탭 클릭');
                      if (controller.searchController.text.isNotEmpty) {
                        controller.findPost();
                      } else {
                        controller.fetchNotPosts();
                      }
                    }
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      // 원복
                      if (controller.selectedIndex == 0) {
                        print('모두 탭 원복');
                        controller.postList.value =
                            controller.originalPostList.toList();
                      } else if (controller.selectedIndex == 1) {
                        print('발행됨 탭 원복');
                        controller.donePostList.value =
                            controller.originalDonePostList.toList();
                      } else {
                        print('대기중 탭 원복');
                        controller.notPostList.value =
                            controller.originalNotPostList.toList();
                      }
                      return;
                    }
                  },
                  onTapAll: () {
                    controller.selectTab(0);
                    print('모두 탭 클릭');
                  },
                  onTapPublished: () {
                    controller.selectTab(1);
                  },
                  onTapPending: () {
                    controller.selectTab(2);
                    print('대기중 클릭');
                  },
                );
              }),
              Container(),
              SizedBox(height: 16.h),
              AppPostTitle(),
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
                      print('게시글 수: ${controller.postList.length}');
                      final post = visibleList[index];
                      return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: AppPost(
                              title: post['title'] ?? '',
                              author: post['author'] ?? '',
                              category: post['category'] ?? '',
                              createdAt: post['updatedAt'] ?? post['createdAt'],
                              status: post['status'] ?? '',
                              onContentTap: () =>
                                  Get.toNamed(EditPage.route, arguments: post),
                              onDeleteTap: () {
                                print('삭제 버튼 클릭됨: ${post['id']}');
                                Get.dialog(
                                  AlertDialog(
                                    title: const Text('게시글 삭제'),
                                    content: const Text('정말로 이 게시글을 삭제하시겠습니까?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back(); // 다이얼로그 닫기
                                        },
                                        child: const Text('취소'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          controller.deletePost(post['id']);
                                          controller.fetchAllPosts();
                                          controller.fetchAllPostCounts();
                                          Get.back(); // 다이얼로그 닫기
                                        },
                                        child: const Text('삭제'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onTap: () => Get.toNamed(EditPage.route,
                                  arguments: post)));
                    },
                  );
                }),
              )
            ],
          ),
        ));
  }
}
