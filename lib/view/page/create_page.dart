import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/controller/create_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';
import 'package:tnm_fact/view/page/admin_page.dart';
import 'package:tnm_fact/view/widget/%08app_checkbox.dart';

class CreatePage extends GetView<CreateController> {
  const CreatePage({super.key});
  // static const String route = '/create';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '콘텐츠관리',
          style: AppTextStyle.koSemiBold16(),
        ),
        leadingWidth: 54.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 24.w),
          child: IconButton(
            padding: EdgeInsets.zero, // 🔹 아이콘 자체 패딩 제거
            icon: Icon(
              Icons.arrow_back,
              color: AppColor.black,
              size: 28.w,
            ),
            onPressed: () {
              final adminController = Get.find<AdminController>();
              adminController.isCreate.value = false;
              // adminController.menuSelectedIndex.value = 1; // 콘텐츠 관리 탭으로 돌아가기
            },
          ),
        ), // title: Text('제목 없음 · 글'),
        centerTitle: false,

        foregroundColor: AppColor.white,
        actions: [
          // Obx(
          //   () =>
          Obx(() {
            return GestureDetector(
              onTap: controller.isButtonActivate.value
                  ? () {
                      print('입력이 완료됨');
                      controller.createPost(
                        title: controller.titleController.text,
                        final_article: controller.contentController.text,
                        category: controller.selectedCategory.value,
                        status: controller.selectedPublish.value,
                        // focus: controller.selectedFocus.value,
                        // people: controller.selectedPeople.value,
                        editor: '김병국',
                        viewpoint: 0,
                      );
                      Get.dialog(
                        AlertDialog(
                          title: const Text('게시글 작성 완료'),
                          content: const Text('게시글이 성공적으로 작성되었습니다.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back(); // 다이얼로그 닫기
                                final adminController =
                                    Get.find<AdminController>();
                                adminController.fetchAllPosts();
                                adminController.fetchAllPostCounts();
                                adminController.fetchDonePosts(); // ✅ 발행 글 갱신
                                adminController.fetchNotPosts();

                                adminController.selectTab(
                                  controller.selectedPublish.value == '발행'
                                      ? 1
                                      : 2,
                                );
                                adminController.selectedIndex.canUpdate;
                                adminController.update();
                                adminController.isCreate.value = false;
                                controller.titleController.clear();
                                controller.contentController.clear();
                                controller.selectedCategory.value = '';
                                controller.selectedPublish.value = '';
                                // controller.selectedFocus.value = '';
                                // controller.selectedPeople.value = '';
                              },
                              child: const Text('확인'),
                            ),
                          ],
                        ),
                      );
                    }
                  : null,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
                child: Container(
                  // width: 50.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: controller.isButtonActivate.value
                        ? AppColor.navy
                        : AppColor.lightGrey,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Center(
                        child:
                            Text('공개', style: TextStyle(color: Colors.white))),
                  ),
                ),
              ),
            );
          }),
          // )
        ],
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: AppColor.lightGrey,
        padding: EdgeInsets.all(20.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 왼쪽: 본문 입력 영역
            Expanded(
              flex: 3,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: AppColor.white,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 32.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 제목
                      TextField(
                        controller: controller.titleController,
                        style: AppTextStyle.koBold35(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '제목 추가',
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // 본문
                      Expanded(
                        child: TextField(
                          controller: controller.contentController,
                          maxLines: null,
                          expands: true,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: '/을 입력하여 블록 선택',
                            border: InputBorder.none,
                          ),
                          style: AppTextStyle.koRegular18()
                              .copyWith(color: AppColor.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20.w,
            ),

            // 오른쪽: 카테고리 사이드바
            Container(
              width: 200.w,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: AppColor.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Column(
                children: [
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('설정',
                            style: AppTextStyle.koBold20()
                                .copyWith(color: AppColor.black)),
                        SizedBox(height: 16.h),
                        Divider(),
                        SizedBox(height: 16.h),
                        AppCheckboxTile(
                          label: '데일리 팩트',
                          value: controller.selectedCategory.value == '데일리 팩트',
                          onChanged: (v) {
                            controller.selectedCategory.value =
                                v! ? '데일리 팩트' : '';
                          },
                        ),
                        AppCheckboxTile(
                          label: '포커스 팩트',
                          value: controller.selectedCategory.value == '포커스 팩트',
                          onChanged: (v) {
                            controller.selectedCategory.value = v! ? '포커스 팩트' : '';
                          },
                        ),
                        AppCheckboxTile(
                          label: '인사이트 팩트',
                          value: controller.selectedCategory.value == '인사이트 팩트',
                          onChanged: (v) {
                            controller.selectedCategory.value =
                                v! ? '인사이트 팩트' : '';
                          },
                        ),
                        AppCheckboxTile(
                          label: '피플&뷰',
                          value: controller.selectedCategory.value == '피플&뷰',
                          onChanged: (v) {
                            controller.selectedCategory.value = v! ? '피플&뷰' : '';
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Theme(
                    data: Theme.of(context).copyWith(
                      checkboxTheme: CheckboxThemeData(
                        shape: CircleBorder(), // 🔹 체크박스 자체를 원형으로
                      ),
                    ),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('발행여부',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 16.h),
                          AppCheckboxTile(
                            label: '발행',
                            shape: CircleBorder(),
                            value: controller.selectedPublish.value == '발행',
                            onChanged: (v) {
                              controller.selectedPublish.value = v! ? '발행' : '';
                            },
                          ),
                          AppCheckboxTile(
                            label: '미발행',
                            shape: CircleBorder(),
                            value: controller.selectedPublish.value == '미발행',
                            onChanged: (v) {
                              controller.selectedPublish.value =
                                  v! ? '미발행' : '';
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
