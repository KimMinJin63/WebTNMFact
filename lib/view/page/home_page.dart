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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.w),
                        child: Text(
                          '진실을 전달하는 미디어',
                          style: AppTextStyle.koBold35(),
                        ),
                      ),
                    ),
                    Padding(
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
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (visibleList.isEmpty) {
                          return Center(
                            child: Text('게시글이 없습니다.',
                                style: AppTextStyle.koRegular18()),
                          );
                        }
                        print('maxLines: ${MediaQuery.of(context).size.width}');
                        return GridView.builder(
                          shrinkWrap: true, // ✅ 부모 스크롤에 맞게 높이 자동 조정
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: visibleList.length, // 원하시는 개수로 변경하세요
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 40.w,
                            mainAxisSpacing: 32.h,
                            childAspectRatio: 0.65,
                          ),
                          itemBuilder: (context, index) {
                            final timestamp = visibleList[index]['date'];

                            String formattedDate = '';
                            if (timestamp != null && timestamp is Timestamp) {
                              final date = timestamp.toDate();
                              formattedDate =
                                  DateFormat('yyyy-MM-dd HH:mm').format(date);
                            }
                            print('formattedDate: $formattedDate');
                            String getDisplayTitle(Map<String, dynamic> post) {
                              final title =
                                  (post['title'] ?? '').toString().trim();
                              final category =
                                  (post['category'] ?? '').toString();
                              final rawDate =
                                  post['date']; // ✅ 타입 그대로 받기 (toString() ❌)

                              // 🔹 날짜 포맷 변환 ("2025-10-22 15:19" → "25-10-22")
                              String formattedDate = '';

                              // ✅ 1. Timestamp 타입 처리
                              if (rawDate is Timestamp) {
                                final date = rawDate.toDate();
                                formattedDate =
                                    DateFormat('yy-MM-dd').format(date);
                              }
                              // ✅ 2. String 타입 처리 ("2025-10-22 15:19" 등)
                              else if (rawDate is String) {
                                final parsed = DateTime.tryParse(rawDate);
                                if (parsed != null) {
                                  formattedDate =
                                      DateFormat('yy-MM-dd').format(parsed);
                                } else {
                                  // 혹시 "2025-10-22 15:19" 같이 공백 구분이라면 수동 파싱
                                  try {
                                    formattedDate = DateFormat('yy-MM-dd')
                                        .format(DateFormat('yyyy-MM-dd HH:mm')
                                            .parse(rawDate));
                                  } catch (_) {
                                    formattedDate = rawDate; // 그래도 안되면 원본 유지
                                  }
                                }
                              } else {
                                formattedDate = ''; // 혹시 모를 null 대비
                              }

                              print('✅ formattedDate 최종 결과: $formattedDate');

                              // 🔹 데일리 팩트 처리
                              if (category == '데일리 팩트') {
                                if (title.isEmpty ||
                                    title == '[오늘의 교육 뉴스]' ||
                                    title == '[오늘의 교육 뉴스]') {
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
                                  await adminController
                                      .incrementViewCount(postId);
                                  controller.logVisit(userId);
                                  Get.toNamed(DetailPage.route,
                                      arguments: post);
                                } else {
                                  final userId = user.uid;
                                  Get.toNamed(DetailPage.route,
                                      arguments: post);
                                  await adminController
                                      .incrementViewCount(postId);
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
                                                  style: AppTextStyle
                                                      .koRegular18()),
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
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 8.h),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8.w),
                                                      decoration: BoxDecoration(
                                                        color: visibleList[
                                                                        index][
                                                                    'category'] ==
                                                                '데일리 팩트'
                                                            ? AppColor.primary
                                                                .withOpacity(
                                                                    0.1)
                                                            : AppColor.yellow
                                                                .withOpacity(
                                                                    0.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(80.r),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(2.w),
                                                        child: Text(
                                                          '${visibleList[index]['category']}',
                                                          style: AppTextStyle
                                                                  .koSemiBold14()
                                                              .copyWith(
                                                                  color: visibleList[index]
                                                                              [
                                                                              'category'] ==
                                                                          '데일리 팩트'
                                                                      ? AppColor
                                                                          .primary
                                                                      : AppColor
                                                                          .yellow),
                                                          textAlign:
                                                              TextAlign.left,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                _buildFlexibleBox(
                                                  getDisplayTitle(
                                                      visibleList[index]),
                                                  style: AppTextStyle
                                                      .koSemiBold18(),
                                                  maxLines: 2,
                                                  // flex: 2
                                                ),
                                                _buildFlexibleBox(
                                                  '${visibleList[index]['final_article']}',
                                                  style:
                                                      AppTextStyle.koRegular14()
                                                          .copyWith(
                                                    color: AppColor.grey,
                                                  ),
                                                  maxLines:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width <
                                                              1000
                                                          ? 2
                                                          : 3,
                                                  // flex: 3
                                                ),
                                                const Spacer(),
                                                _buildFlexibleBox(
                                                    '$formattedDate',
                                                    style: AppTextStyle
                                                            .koRegular12()
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
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }
}

Widget _buildFooter(BuildContext context) {
  return Container(
    width: double.infinity,
    color: Colors.grey[100],
    padding: EdgeInsets.symmetric(
      vertical: 40.h,
      horizontal: MediaQuery.of(context).size.width < 600 ? 24.w : 72.w,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TNM FACT', style: AppTextStyle.koBold18()),
        SizedBox(height: 8.h),
        Text('진실을 전달하는 미디어, 티엔엠팩트',
            style: AppTextStyle.koRegular14().copyWith(color: AppColor.grey)),
        SizedBox(height: 8.h),
        Text('문의: contact@tnmfact.com',
            style: AppTextStyle.koRegular14().copyWith(color: AppColor.grey)),
        Divider(height: 32.h, color: AppColor.lightGrey),
        Text('© 2025 TNM FACT. All rights reserved.',
            style: AppTextStyle.koRegular12().copyWith(color: AppColor.grey)),
      ],
    ),
  );
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
