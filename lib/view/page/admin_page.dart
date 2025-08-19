import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';
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
          title: const Text('어드민 페이지'),
          backgroundColor: AppColor.primary,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Get.toNamed(CreatePage.route); // 글 작성 페이지로 이동
                // 여기에 글 작성 로직 추가
                print('글 작성 버튼 클릭됨');
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
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
                    if (controller.searchController.text.isNotEmpty) {
                      controller.findPost();
                    }
                    else {
                      controller.fetchAllPosts();
                    }
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      controller.findPost();
                    } 
                  },
                  // searchController: controller.searchController,
                  // onSearch: (keyword) {
                  //   print('검색: $keyword');
                  // },
                  onTapAll: () {
                    controller.selectTab(0);
                    print('모두 탭 클릭');
                  },
                  onTapPublished: () {
                    controller.selectTab(1);
                    print('발행됨 클릭');
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
                  return ListView.builder(
                    itemCount: controller.postList.length,
                    itemBuilder: (context, index) {
                      print('게시글 수: ${controller.postList.length}');
                      final post = controller.postList[index];
                      return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: AppPost(
                              title: post['title'] ?? '',
                              author: post['author'] ?? '',
                              category: post['category'] ?? '',
                              createdAt: post['updatedAt'] ?? post['createdAt'],
                              status: post['status'] ?? '',
                              onContentTap: () => Get.toNamed(EditPage.route, arguments: post),
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
