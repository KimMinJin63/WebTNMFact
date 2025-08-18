import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/controller/create_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';
import 'package:tnm_fact/view/page/admin_page.dart';

class CreatePage extends GetView<CreateController> {
  const CreatePage({super.key});
  static const String route = '/create';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('제목 없음 · 글'),
        centerTitle: true,
        actions: [
          // Obx(
          //   () => 
            TextButton(
              onPressed: () {
                controller.createPost(
                    title: controller.titleController.text,
                    content: controller.contentController.text,
                    category: controller.selectedCategory.value,
                    status: controller.selectedPublish.value,
                    author: '김병국');
                Get.find<AdminController>().fetchAllPosts();
                Get.find<AdminController>().fetchAllPostCounts();
                Get.offNamed(AdminPage.route); // 글 작성 후 관리자 페이지로 이동
              },
              child: Text(
                '공개',
                style: TextStyle(color: Colors.white),
              ),
            ),
          // )
        ],
        backgroundColor: Colors.grey[900],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽: 본문 입력 영역
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 32.h),
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

          // 오른쪽: 카테고리 사이드바
          Container(
            width: 200.w,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.grey[300]!)),
              color: Colors.grey[50],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            child: Column(
              children: [
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('카테고리',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 16.h),
                      CheckboxListTile(
                        title: Text('데일리 팩트'),
                        value: controller.selectedCategory.value == '데일리 팩트',
                        onChanged: (val) {
                          controller.selectedCategory.value =
                              val! ? '데일리 팩트' : ''; // 선택/해제
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      CheckboxListTile(
                        title: Text('인사이트 팩트'),
                        value: controller.selectedCategory.value == '인사이트 팩트',
                        onChanged: (val) {
                          controller.selectedCategory.value =
                              val! ? '인사이트 팩트' : '';
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 18.h,
                ),
                Divider(),
                SizedBox(
                  height: 18.h,
                ),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('발행여부',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 16.h),
                      CheckboxListTile(
                        title: Text('발행'),
                        value: controller.selectedPublish.value == '발행',
                        onChanged: (val) {
                          controller.selectedPublish.value =
                              val! ? '발행' : ''; // 선택/해제
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      CheckboxListTile(
                        title: Text('미발행'),
                        value: controller.selectedPublish.value == '미발행',
                        onChanged: (val) {
                          controller.selectedPublish.value = val! ? '미발행' : '';
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
