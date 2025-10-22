import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';
import 'package:tnm_fact/view/widget/app_container.dart';
import 'package:tnm_fact/view/widget/app_visit_table.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});
  static const route = '/dash';

  @override
  Widget build(BuildContext context) {
    final AdminController controller = Get.find<AdminController>();
    print('대시보드 총 게시물 수는 : ${controller.postList.length}');

    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            child: SizedBox(
              width: double.infinity,
              height: 70.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('대시보드',
                      style: AppTextStyle.koBold28()
                          .copyWith(color: AppColor.black)),
                  Text('TNM Fact의 주요 현황을 확인하세요.',
                      style: AppTextStyle.koSemiBold12()
                          .copyWith(color: AppColor.grey)),
                ],
              ),
            ),
          ),
          Expanded(
              child: Container(
            color: AppColor.lightGrey,
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Row(
                  children: [
                    // 첫 번째 카드
                    Expanded(
                        child: AppContainer(
                      height: 150.h,
                      content: Row(
                        children: [
                          Container(
                            width: 48.w,
                            height: 48.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  AppColor.primary.withOpacity(0.2), // 옅은 보라 배경
                            ),
                            child: Icon(
                              Icons.newspaper,
                              color: AppColor.primary, // 메인 컬러 아이콘
                              size: 28.w,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '총 게시물',
                                style: AppTextStyle.koSemiBold16(),
                              ),
                              // SizedBox(height: 4.h),
                              Obx(() => Text(
                                    '${controller.donePostList.length}',
                                    style: AppTextStyle.koBold28()
                                        .copyWith(color: AppColor.navy),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    )),
                    Expanded(
                      child: AppContainer(
                        height: 150.h,
                        content: Row(
                          children: [
                            Container(
                              width: 48.w,
                              height: 48.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    AppColor.green.withOpacity(0.2), // 옅은 보라 배경
                              ),
                              child: Icon(
                                Icons.remove_red_eye,
                                color: AppColor.green, // 메인 컬러 아이콘
                                size: 28.w,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '총 방문자 수',
                                  style: AppTextStyle.koSemiBold16(),
                                ),
                                // SizedBox(height: 4.h),
                                FutureBuilder<int>(
                                  future: controller
                                      .fetchTotalVisits(), // ✅ Firestore에서 불러오기
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Text(
                                        '-',
                                        style: TextStyle(color: Colors.grey),
                                      );
                                    }
                                    return Text(
                                      '${snapshot.data}',
                                      style: AppTextStyle.koBold28()
                                          .copyWith(color: AppColor.green),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 28.h,
                ),
                Expanded(
                  child: Row(
                    children: [
                      // 첫 번째 카드
                      Expanded(
                        flex: 2,
                        child: AppContainer(
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '일일 방문자 수',
                                style: AppTextStyle.koBold20()
                                    .copyWith(color: AppColor.black),
                              ),
                              SizedBox(height: 48.h),
                              AppVisitChart(),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        // flex: 3,
                        child: AppContainer(
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '인기 게시물 (이번 달)',
                                style: AppTextStyle.koBold20()
                                    .copyWith(color: AppColor.black),
                              ),
                              SizedBox(height: 16.h),
                              Expanded(
                                child: Obx(() {
                                  final posts = controller.postList;
                                  final top5 =
                                      controller.topPostsLast7DaysByView(5);

                                  print(
                                      '📊 postList 길이: ${posts.length}, top5 길이: ${top5.length}');

                                  if (!controller.isLoaded.value) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  if (top5.isEmpty) {
                                    return const Center(
                                        child: Text('이번 달 인기 게시물이 없습니다.'));
                                  }

                                  return ListView.separated(
                                    itemCount: top5.length,
                                    separatorBuilder: (_, __) => Divider(
                                      height: 16.h,
                                      color: AppColor.lightGrey,
                                    ),
                                    itemBuilder: (context, index) {
                                      final p = top5[index];
                                      final title =
                                          (p['title'] ?? '') as String;
                                      final vp = (p['viewpoint'] ?? 0) as int;
                                      print('🔥 빌드됨: $title / 조회수 $vp');

                                      String getDisplayTitle(
                                          Map<String, dynamic> post) {
                                        final title = (post['title'] ?? '')
                                            .toString()
                                            .trim();
                                        final rawDate = (post['date'] ?? '')
                                            .toString()
                                            .trim();
                                        final category =
                                            (post['category'] ?? '').toString();

                                        String formattedDate = rawDate;
                                        try {
                                          final parsed =
                                              DateTime.tryParse(rawDate);
                                          if (parsed != null) {
                                            formattedDate =
                                                DateFormat('yy-MM-dd')
                                                    .format(parsed);
                                          }
                                        } catch (_) {}

                                        if (category == '데일리 팩트') {
                                          if (title.isEmpty ||
                                              title == '[오늘의 교육 뉴스]') {
                                            return '[오늘의 교육 뉴스] $formattedDate';
                                          }
                                          if (title.startsWith('[오늘의 교육 뉴스]')) {
                                            return title;
                                          }
                                          return '[오늘의 교육 뉴스] $title';
                                        }
                                        return title.isEmpty
                                            ? formattedDate
                                            : title;
                                      }

                                      return Row(
                                        children: [
                                          // 순위 뱃지
                                          Container(
                                            width: 28.w,
                                            height: 28.w,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: AppColor.primary
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                            child: Text('${index + 1}',
                                                style:
                                                    AppTextStyle.koSemiBold14()
                                                        .copyWith(
                                                            color: AppColor
                                                                .primary)),
                                          ),
                                          SizedBox(width: 20.w),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  getDisplayTitle(p),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppTextStyle
                                                      .koSemiBold16(),
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.remove_red_eye,
                                                      size: 16,
                                                      color: AppColor.grey,
                                                    ),
                                                    SizedBox(width: 4.w),
                                                    Text('$vp views',
                                                        style: AppTextStyle
                                                                .koRegular12()
                                                            .copyWith(
                                                                color: AppColor
                                                                    .grey)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(width: 12.w),
                                        ],
                                      );
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 두 번째 카드
                    ],
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
