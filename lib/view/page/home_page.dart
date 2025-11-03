import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          child: Center(
            child: GestureDetector(
              onTap: () {
                controller.selectTab(0);
                controller.currentPage.value = 'home';
              },
              child: AutoSizeText(
                'TNM FACT',
                maxFontSize: 25,
                minFontSize: 16,
                style: AppTextStyle.koBold20(),
              ),
            ),
          ),
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
                  title: '인사이트팩트',
                  color: controller.selectedIndex.value == 2
                      ? AppColor.primary
                      : AppColor.black,
                  onPressed: () {
                    controller.selectTab(2);
                    controller.currentPage.value = 'home'; // ✅ 홈으로 전환
                  },
                );
              }),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16, top: 12, bottom: 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                double hintFontSize = width > 1000 ? 14 : 10;

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
                      fontSize: hintFontSize,
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        if (controller.selectedIndex == 0) {
                          controller.postList.value =
                              controller.originalPostList.toList();
                        } else if (controller.selectedIndex == 1) {
                          controller.dailyPostList.value =
                              controller.originalDailyPostList.toList();
                        } else {
                          controller.insightPostList.value =
                              controller.originalInsightPostList.toList();
                        }
                      }
                    },
                    onSubmitted: (_) async {
                      controller.clearFocus(); // ✅ 포커스 해제
                      if (controller.searchController.text.trim().isNotEmpty) {
                        await controller.findPost(); // ✅ 엔터 입력 시 검색 실행
                      } else {
                        // ✅ 검색어가 비어있으면 탭에 맞는 전체 목록 불러오기
                        if (controller.selectedIndex.value == 0) {
                          await controller.loadAllPosts();
                        } else if (controller.selectedIndex.value == 1) {
                          await controller.loadDailyPosts();
                        } else {
                          await controller.loadInsightPosts();
                        }
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
                              if (controller.selectedIndex == 0) {
                                print('전체기사 탭에서 검색 실행');
                                controller.searchController.text.isNotEmpty
                                    ? controller.findPost()
                                    : controller.loadAllPosts();
                              } else if (controller.selectedIndex == 1) {
                                print('데일리팩트 탭에서 검색 실행');
                                controller.searchController.text.isNotEmpty
                                    ? controller.findPost()
                                    : controller.loadDailyPosts();
                              } else if (controller.selectedIndex == 2) {
                                print('인사이트팩트 탭에서 검색 실행');
                                controller.searchController.text.isNotEmpty
                                    ? controller.findPost()
                                    : controller.loadInsightPosts();
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
                      LayoutBuilder(builder: (context, constraints) {
                        final double width = constraints.maxWidth;
                        int crossCount;
                        double aspectRatio;

                        if (width >= 1200) {
                          crossCount = 4;
                          aspectRatio = 0.7;
                        } else if (width >= 800) {
                          crossCount = 3;
                          aspectRatio = 0.75;
                        } else if (width >= 600) {
                          crossCount = 2;
                          aspectRatio = 0.8;
                        } else {
                          crossCount = 1;
                          aspectRatio = 1.1;
                        }

                        return Obx(() {
                          List<Map<String, dynamic>> visibleList;
                          switch (controller.selectedIndex.value) {
                            case 1:
                              visibleList = controller.dailyPostList;
                              break;
                            case 2:
                              visibleList = controller.insightPostList;
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

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: visibleList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossCount,
                              crossAxisSpacing: 32,
                              mainAxisSpacing: 32,
                              childAspectRatio: aspectRatio,
                            ),
                            itemBuilder: (context, index) {
                              final post = visibleList[index];
                              final timestamp = post['date'];
                              String formattedDate = '';

                              if (timestamp != null) {
                                if (timestamp is Timestamp) {
                                  final date = timestamp.toDate();
                                  formattedDate =
                                      DateFormat('yyyy-MM-dd').format(date);
                                } else if (timestamp is String) {
                                  try {
                                    final parsed = DateTime.tryParse(timestamp);
                                    if (parsed != null) {
                                      formattedDate = DateFormat('yyyy.MM.dd')
                                          .format(parsed);
                                    } else {
                                      // 혹시 Firestore에 저장된 문자열이 "2025-10-28 18:04:00" 형식일 수도 있음
                                      final manualParsed =
                                          DateFormat('yyyy-MM-dd HH:mm:ss')
                                              .parse(timestamp);
                                      formattedDate = DateFormat('yyyy.MM.dd')
                                          .format(manualParsed);
                                    }
                                  } catch (e) {
                                    formattedDate = ''; // 파싱 실패 시
                                    print('⚠️ 날짜 파싱 실패: $timestamp');
                                  }
                                } else {
                                  print(
                                      '⚠️ 알 수 없는 날짜 타입: ${timestamp.runtimeType}');
                                }
                              }

                              String getDisplayTitle(
                                  Map<String, dynamic> post) {
                                final title =
                                    (post['title'] ?? '').toString().trim();
                                final category =
                                    (post['category'] ?? '').toString();

                                if (category == '데일리 팩트') {
                                  if (title.isEmpty || title == '[오늘의 교육 뉴스]') {
                                    return '[오늘의 교육 뉴스] $formattedDate';
                                  }
                                  if (title.startsWith('[오늘의 교육 뉴스]')) {
                                    return title;
                                  }
                                  return '[오늘의 교육 뉴스] $title';
                                }

                                return title.isEmpty ? formattedDate : title;
                              }

                              // print('formattedDate in Grid Item: $formattedDate');
                              return GestureDetector(
                                onTap: () async {
                                  print('onTap 눌림');
                                  final user =
                                      FirebaseAuth.instance.currentUser;
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
                                    controller.selectedPost = post;
                                    controller.currentPage.value = 'detail';
                                    // Get.toNamed(DetailPage.route, arguments: post);
                                  } else {
                                    final userId = user.uid;
                                    // Get.toNamed(DetailPage.route, arguments: post);
                                    controller.selectedPost = post;
                                    controller.currentPage.value = 'detail';
                                    await adminController
                                        .incrementViewCount(postId);
                                    controller.logVisit(userId);
                                  }
                                  controller.selectedPost = post;
                                  controller.currentPage.value = 'detail';
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColor
                                        .white, // 카드 배경 (예: const Color(0xFFFFFFFF))
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.shadow, // TNM 보라색을 살짝 섞은 그림자
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: AppColor.border, // 보라톤의 은은한 테두리
                                      width: 1,
                                    ),
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
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color:
                                                  post['category'] == '데일리 팩트'
                                                      ? AppColor.primary
                                                          .withOpacity(0.1)
                                                      : AppColor.yellow
                                                          .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(80),
                                            ),
                                            child: AutoSizeText(
                                              '${post['category']}',
                                              maxFontSize: 14,
                                              style: AppTextStyle.koSemiBold14()
                                                  .copyWith(
                                                color:
                                                    post['category'] == '데일리 팩트'
                                                        ? AppColor.primary
                                                        : AppColor.yellow,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          // height: 40,
                                          // color: Colors.yellow,
                                          child: _buildFlexibleBox(
                                            getDisplayTitle(post),
                                            style: AppTextStyle.koSemiBold18(),
                                            maxLines: 2,
                                          ),
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Align(
                                              alignment: Alignment
                                                  .centerLeft, // ✅ 왼쪽 기준으로 고정
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: constraints
                                                      .maxWidth, // ✅ 화면 폭에 맞게 자동
                                                ),
                                                child: AutoSizeText(
                                                  '${post['final_article']}',
                                                  style:
                                                      AppTextStyle.koRegular15()
                                                          .copyWith(
                                                              color: AppColor
                                                                  .grey),
                                                  textAlign: TextAlign.left,
                                                  maxLines: 4,
                                                  minFontSize:
                                                      14, // ✅ 화면이 좁을 때 최소 폰트
                                                  maxFontSize:
                                                      18, // ✅ 화면이 넓을 때 최대 폰트
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  wrapWords: false,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          // height: 20,
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: AutoSizeText(
                                              formattedDate,
                                              textAlign: TextAlign.left,
                                              style: AppTextStyle.koRegular8()
                                                  .copyWith(
                                                      color: AppColor.black),
                                              maxLines: 1, // ✅ 최대 4줄까지만
                                              minFontSize:
                                                  10, // ✅ 작아져도 이 이하로는 안감
                                              maxFontSize: 16, // ✅ 여유 있으면 커짐
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              stepGranularity: 0.5,
                                            ),
                                          ),
                                          // child: _buildFlexibleBox(
                                          //   formattedDate,
                                          //   style: AppTextStyle.koRegular8()
                                          //       .copyWith(color: AppColor.black),
                                          //   maxLines: 1,
                                          // ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        });
                      }),
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
        if (parsedDate != null) {
          titleDate = DateFormat('yy.MM.dd').format(parsedDate);
        }
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
                      color: post['category'] == '데일리 팩트'
                          ? AppColor.primary.withOpacity(0.1)
                          : AppColor.yellow.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(80.r),
                    ),
                    child: Text(
                      post['category'],
                      style: AppTextStyle.koSemiBold14().copyWith(
                        color: post['category'] == '데일리 팩트'
                            ? AppColor.primary
                            : AppColor.yellow,
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

// ✅ 공통 박스 빌더
Widget _buildFlexibleBox(
  String text, {
  required int maxLines,
  TextStyle? style,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    child: Align(
      alignment: Alignment.centerLeft,
      child: AutoSizeText(
        text,
        style: style,
        textAlign: TextAlign.left,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        maxFontSize: 20,
        minFontSize: 16,
        stepGranularity: 1,
      ),
    ),
  );
}

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
              Text('TNM FACT', style: AppTextStyle.koBold18()),
              const SizedBox(height: 8),
              Text('진실을 전달하는 미디어, 티엔엠팩트',
                  style: AppTextStyle.koRegular14()
                      .copyWith(color: AppColor.grey)),
              const SizedBox(height: 8),
              Text('문의: contact@tnmfact.com',
                  style: AppTextStyle.koRegular14()
                      .copyWith(color: AppColor.grey)),
              Divider(height: 32, color: AppColor.lightGrey),
              Text('© 2025 TNM FACT. All rights reserved.',
                  style: AppTextStyle.koRegular12()
                      .copyWith(color: AppColor.grey)),
            ],
          ),
        ),
      ),
    ),
  );
}
