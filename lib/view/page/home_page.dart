import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/controller/home_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';
import 'package:tnm_fact/view/page/detail_page.dart';
import 'package:tnm_fact/view/widget/app_title_button.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  static const route = '/homepage';

  @override
  Widget build(BuildContext context) {
    final AdminController adminController = Get.find<AdminController>();

    return Scaffold(
      appBar: AppBar(
          leadingWidth: ScreenUtil().screenWidth / 5,
          backgroundColor: AppColor.white,
          titleSpacing: 0,
          leading: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child:
                Center(child: Text('TNM FACT', style: AppTextStyle.koBold20())),
          ),
          title: Center(
            child: Row(
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
                      },
                      title: '전체기사');
                }),
                SizedBox(
                  width: 16.w,
                ),
                Obx(() {
                  return AppTitleButton(
                      title: '데일리팩트',
                      color: controller.selectedIndex.value == 1
                          ? AppColor.primary
                          : AppColor.black,
                      onPressed: () {
                        controller.selectTab(1);
                      });
                }),
                SizedBox(
                  width: 16.w,
                ),
                Obx(() {
                  return AppTitleButton(
                      title: '인사이트팩트',
                      color: controller.selectedIndex.value == 2
                          ? AppColor.primary
                          : AppColor.black,
                      onPressed: () {
                        controller.selectTab(2);
                      });
                }),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w, top: 12.h, bottom: 12.h),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  border: Border.all(color: AppColor.grey, width: 1.w),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                width: ScreenUtil().screenWidth / 4.5,
                height: ScreenUtil().screenWidth / 12,
                alignment: Alignment.centerRight,
                child: TextField(
                  focusNode: controller.searchFocusNode, // ✅ 연결
                  style: AppTextStyle.koRegular15().copyWith(
                    color: AppColor.grey,
                  ),
                  controller: controller.searchController,
                  textAlignVertical:
                      TextAlignVertical.center, // 텍스트와 힌트를 수직으로 가운데 정렬
                  onSubmitted: (text) {
                    controller.clearFocus(); // ✅ 포커스 해제
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 8.h, horizontal: 12.w), // 패딩 조정
                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        controller.clearFocus();
                      },
                      icon:
                          Icon(Icons.search, size: 20.sp, color: AppColor.grey),
                      splashRadius: 20, // 클릭 영역 조정
                    ),
                    hintText: "관심있는 교육 키워드를 검색하세요",
                    hintStyle: AppTextStyle.koRegular14().copyWith(
                      color: AppColor.grey,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ]),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 24.h),
          child: Column(
            children: [
              // 여기에 본문 내용 추가
              Center(
                child: Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Text(
                    '진실을 전달하는 미디어',
                    style: AppTextStyle.koBold35(),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 72.w),
                  child: Obx(() {
                    List<Map<String, dynamic>> visibleList;
                    switch (controller.selectedIndex.value) {
                      case 1:
                        visibleList = controller.dailyPostList;
                        break;
                      case 2:
                        visibleList = controller.insightPostList;
                        break;
                      case 0:
                      default:
                        visibleList = controller.postList;
                        break;
                    }
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (visibleList.isEmpty) {
                      return Center(
                        child: Text('게시글이 없습니다.',
                            style: AppTextStyle.koRegular18()),
                      );
                    }
                    print('maxLines: ${MediaQuery.of(context).size.width}');
                    return GridView.builder(
                      itemCount: visibleList.length, // 원하시는 개수로 변경하세요
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 40.w,
                        mainAxisSpacing: 32.h,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final timestamp = visibleList[index]['updatedAt'] ??
                            visibleList[index]['createdAt'];
                        final rawDateStr = visibleList[index]['date'];
                        final parsed = DateFormat('yy-MM-dd').parse(rawDateStr);
                        final titleDate = DateFormat('yy-MM-dd').format(parsed);

                        String formattedDate = '';
                        if (timestamp != null && timestamp is Timestamp) {
                          final date = timestamp.toDate();
                          formattedDate =
                              DateFormat('yyyy-MM-dd HH:mm').format(date);
                        }

                        final String displayDate = formattedDate.isNotEmpty
                            ? formattedDate
                            : (rawDateStr ?? '');

                        print('지금 게시글 목록 ${visibleList[index]['date']}');
                        return GestureDetector(
                          onTap: () async {
                            print('onTap 눌림');
                            final user = FirebaseAuth.instance.currentUser;
                            print('현재 유저 정보는?? : $user');
                            final post = visibleList[index];
                            final postId = post['id'];
                            if (user == null) {
                              print('로그인 안 된 상태, 익명 로그인 처리');
                              // 로그인 안 되어 있으면 여기서 즉시 로그인 처리
                              final cred = await FirebaseAuth.instance
                                  .signInAnonymously();
                              final userId = cred.user!.uid;
                              await adminController.incrementViewCount(postId);
                              controller.logVisit(userId);
                              Get.toNamed(DetailPage.route, arguments: post);
                            } else {
                              final userId = user.uid;
                              Get.toNamed(DetailPage.route, arguments: post);
                              await adminController.incrementViewCount(postId);
                              controller.logVisit(userId);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.grey.withOpacity(0.2),
                                  blurRadius: 4.r,
                                  offset: Offset(0, 2.h),
                                ),
                              ],
                            ),
                            child: Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Column(
                                  children: [
                                    // 상단 이미지 영역
                                    AspectRatio(
                                      aspectRatio: 5 / 3,
                                      child: Container(
                                        width: double.infinity,
                                        color: AppColor.grey,
                                        child: Center(
                                          child: Text('이미지 $index',
                                              style:
                                                  AppTextStyle.koRegular18()),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4.h),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(4.w),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(top: 8.h),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.w),
                                                  decoration: BoxDecoration(
                                                    color: visibleList[index]
                                                                ['category'] ==
                                                            '데일리 팩트'
                                                        ? AppColor.primary
                                                            .withOpacity(0.1)
                                                        : AppColor.yellow
                                                            .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80.r),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(2.w),
                                                    child: Text(
                                                      '${visibleList[index]['category']}',
                                                      style: AppTextStyle
                                                              .koSemiBold14()
                                                          .copyWith(
                                                              color: visibleList[
                                                                              index]
                                                                          [
                                                                          'category'] ==
                                                                      '데일리 팩트'
                                                                  ? AppColor
                                                                      .primary
                                                                  : AppColor
                                                                      .yellow),
                                                      textAlign: TextAlign.left,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            _buildFlexibleBox(
                                              '[오늘의 교육 뉴스] $titleDate',
                                              style:
                                                  AppTextStyle.koSemiBold18(),
                                              maxLines: 2,
                                              // flex: 2
                                            ),
                                            _buildFlexibleBox(
                                              '${visibleList[index]['final_article']}',
                                              style: AppTextStyle.koRegular14()
                                                  .copyWith(
                                                color: AppColor.grey,
                                              ),
                                              maxLines: MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      1000
                                                  ? 2
                                                  : 3,
                                              // flex: 3
                                            ),
                                            const Spacer(),
                                            _buildFlexibleBox(displayDate,
                                                style:
                                                    AppTextStyle.koRegular12()
                                                        .copyWith(
                                                            color:
                                                                AppColor.black),
                                                // flex: 1,
                                                maxLines: 1),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        );
                      },
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildFlexibleBox(
  String text, {
  // required int flex,
  required int maxLines,
  TextStyle? style, // ✅ 추가
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.left,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}
