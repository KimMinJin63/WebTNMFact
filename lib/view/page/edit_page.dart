import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/controller/edit_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';
import 'package:tnm_fact/view/page/admin_layout_page.dart';
import 'package:tnm_fact/view/page/admin_page.dart';
import 'package:tnm_fact/view/widget/%08app_checkbox.dart';

class EditPage extends GetView<EditController> {
  const EditPage({super.key});
  static const String route = '/edit';

  @override
  Widget build(BuildContext context) {
    final AdminController adminController = Get.find<AdminController>();
    // final box = GetStorage();
    // final post = box.read('post');
    // final post = Get.arguments;
    // final post = adminController.currentPost.value!;

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

    return Obx(() {
      final post = adminController.currentPost.value;
      if (post == null) {
        return const Scaffold(
          body: Center(child: Text('게시글 데이터가 없습니다.')),
        );
      }

      // post 값이 확실히 있을 때만 컨트롤러 값 세팅
      // controller.titleController.text = post['title'] ?? '';
      controller.contentController.text = post['final_article'] ?? '';
      controller.selectedCategory.value = post['category'] ?? '';
      controller.selectedPublish.value = post['status'] ?? '';
      controller.titleController.text = getDisplayTitle(post);

      print('에딧 페이지 잘 받아오나?? : ${post['title']}');
      print('에딧 페이지 잘 받아오나?? : ${post['final_article']}');
      print('에딧 페이지 잘 받아오나?? : ${post['category']}');
      print('에딧 페이지 잘 받아오나?? : ${post['status']}');
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

                // ✅ 현재 탭이 어디서 왔는지 확인
                final origin = adminController.originTabIndex?.value ?? 1;

                // ✅ 편집 모드 종료
                adminController.isEditing.value = false;
                adminController.currentPost.value = null;

                // ✅ 원래 탭으로 돌아가기
                adminController.menuSelectedIndex.value = origin;

                // adminController.menuSelectedIndex.value = 1; // 콘텐츠 관리 탭으로 돌아가기
              },
            ),
          ), // title: Text('제목 없음 · 글'),
          centerTitle: false,

          foregroundColor: AppColor.white,
          actions: [
            // Obx(
            //   () =>
            TextButton(
              onPressed: () {
                print('수정 버튼 클릭됨: ${post['id']}');
                adminController.postList.refresh();
                adminController.originalPostList.refresh();
                controller.editPost(
                  docId: post['id'],
                  title: controller.titleController.text,
                  final_article: controller.contentController.text,
                  category: controller.selectedCategory.value,
                  status: controller.selectedPublish.value,
                  editor: '김병국',
                );

                Get.dialog(
                  AlertDialog(
                    title: const Text('게시글 수정 완료'),
                    content: const Text('게시글이 성공적으로 수정되었습니다.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back(); // 다이얼로그 닫기

                          final adminController = Get.find<AdminController>();

                          // ✅ 데이터 새로고침
                          adminController.fetchAllPosts();
                          adminController.fetchAllPostCounts();
                          adminController.fetchDonePosts();
                          adminController.fetchNotPosts();

                          // ✅ 이동 탭 설정
                          final targetTab =
                              controller.selectedPublish.value == '발행' ? 1 : 2;
                          adminController.selectTab(targetTab);
                          print('🔥 수정 후 이동할 탭 인덱스: $targetTab');
                          // adminController.menuSelectedIndex.value =
                          //     targetTab; // 🔥 명시적 탭 갱신
                          adminController.isEditing.value = false; // 🔥 편집모드 종료
                          adminController.update();

                          // ✅ 입력값 초기화
                          controller.titleController.clear();
                          controller.contentController.clear();
                          controller.selectedCategory.value = '';
                          controller.selectedPublish.value = '';
                        },
                        child: const Text('확인'),
                      ),
                    ],
                  ),
                );

                // final adminController = Get.find<AdminController>();
                // adminController.fetchAllPosts();
                // adminController.fetchAllPostCounts();
                // adminController.fetchDonePosts(); // ✅ 발행 글 갱신
                // adminController.fetchNotPosts();
                // adminController.selectTab(
                //   controller.selectedPublish.value == '발행' ? 1 : 2,
                // );

                // adminController.selectedIndex.canUpdate;
                // // adminController.update();
                // // adminController.isCreate.value = false;
              },
              child: Text('수정',
                  style: AppTextStyle.koSemiBold16()
                      .copyWith(color: AppColor.black)),
            ) // )
          ],
          backgroundColor: Colors.white,
          // backgroundColor: Colors.grey[900],
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
                    padding: EdgeInsets.all(16.0.w),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.w, vertical: 32.h),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('설정',
                              style: AppTextStyle.koBold20()
                                  .copyWith(color: AppColor.black)),
                          SizedBox(height: 16.h),
                          Divider(),
                          SizedBox(height: 16.h),
                          AppCheckboxTile(
                            label: '데일리 팩트',
                            value:
                                controller.selectedCategory.value == '데일리 팩트',
                            onChanged: (v) {
                              controller.selectedCategory.value =
                                  v! ? '데일리 팩트' : '';
                            },
                          ),
                          AppCheckboxTile(
                            label: '인사이트 팩트',
                            value:
                                controller.selectedCategory.value == '인사이트 팩트',
                            onChanged: (v) {
                              controller.selectedCategory.value =
                                  v! ? '인사이트 팩트' : '';
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
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
                                style: AppTextStyle.koBold20()
                                    .copyWith(color: AppColor.black)),
                            SizedBox(height: 16.h),
                            AppCheckboxTile(
                              label: '발행',
                              shape: CircleBorder(),
                              value: controller.selectedPublish.value == '발행',
                              onChanged: (v) {
                                controller.selectedPublish.value =
                                    v! ? '발행' : '';
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
                            // CheckboxListTile(
                            //   title: Text('발행',
                            //       style: AppTextStyle.koRegular18()
                            //           .copyWith(color: AppColor.black)),
                            //   // checkboxScaleFactor: 0.8,
                            //   // visualDensity: VisualDensity.compact,
                            //   value: controller.selectedPublish.value == '발행',
                            //   onChanged: (val) {
                            //     controller.selectedPublish.value =
                            //         val! ? '발행' : ''; // 선택/해제
                            //   },
                            //   controlAffinity: ListTileControlAffinity.leading,
                            //   contentPadding: EdgeInsets.zero,
                            // ),
                            // CheckboxListTile(
                            //   title: Text('미발행',
                            //       style: AppTextStyle.koRegular18()
                            //           .copyWith(color: AppColor.black)),
                            //   visualDensity: VisualDensity.compact,
                            //   value: controller.selectedPublish.value == '미발행',
                            //   onChanged: (val) {
                            //     controller.selectedPublish.value =
                            //         val! ? '미발행' : '';
                            //   },
                            //   controlAffinity: ListTileControlAffinity.leading,
                            //   contentPadding: EdgeInsets.zero,
                            // ),
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
    });
  }
}
