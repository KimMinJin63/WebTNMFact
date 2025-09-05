import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
                                    '${controller.postList.length}',
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
                                Text(
                                  '85',
                                  style: AppTextStyle.koBold28()
                                      .copyWith(color: AppColor.green),
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
                        flex: 3,
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
                              // SizedBox(height: 4.h),
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
                                '인기 게시물 (최근 7일)',
                                style: AppTextStyle.koBold20()
                                    .copyWith(color: AppColor.black),
                              ),
                              // SizedBox(height: 4.h),
                              Text(
                                '85',
                                style: AppTextStyle.koBold28()
                                    .copyWith(color: AppColor.green),
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
