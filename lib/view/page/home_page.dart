import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tnm_fact/controller/home_page_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';
import 'package:tnm_fact/view/widget/app_title_button.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});
  static const route = '/homepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: ScreenUtil().screenWidth / 5,
          backgroundColor: AppColor.white,
          titleSpacing: 0,
          leading: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child:
                Center(child: Text('TNM FACT', style: AppTextStyle.koBold28())),
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
              padding: EdgeInsets.only(right: 16.w, top: 8.h, bottom: 8.h),
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
                  style: AppTextStyle.koRegular18().copyWith(
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
                          Icon(Icons.search, size: 22.sp, color: AppColor.grey),
                      splashRadius: 20, // 클릭 영역 조정
                    ),
                    hintText: "관심있는 교육 키워드를 검색하세요",
                    hintStyle: AppTextStyle.koRegular15().copyWith(
                      color: AppColor.grey,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ]),
      body: Column(
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
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 40.w, // 가로 간격
                    mainAxisSpacing: 32.h,
                    childAspectRatio: 0.7,
                  ), // 세로 간격),

                  itemBuilder: (context, index) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final double whiteHeight = constraints.maxHeight;
                        final double greyHeight = whiteHeight / 9 * 4.h;

                        return Container(
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
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: greyHeight,
                                  decoration: BoxDecoration(
                                    color: AppColor.grey,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '이미지 $index',
                                      style: AppTextStyle.koRegular18(),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: whiteHeight / 12.h,
                                  alignment: Alignment.center,
                                  color: AppColor.shadowGrey,
                                  margin: EdgeInsets.only(top: 8.h),
                                  child: Center(
                                    child: Text(
                                      '해시태그 $index',
                                      style: AppTextStyle.koRegular18(),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: whiteHeight / 7.h,
                                  alignment: Alignment.center,
                                                                    color: AppColor.shadowGrey,
                                  margin: EdgeInsets.only(top: 8.h),
                                  child: Center(
                                    child: Text(
                                      '제목 $index',
                                      style: AppTextStyle.koRegular18(),
                                    ),
                                  ),

                                ),
                                Container(
                                  height: whiteHeight / 7.h,
                                  alignment: Alignment.center,
                                                                    color: AppColor.shadowGrey,
                                  margin: EdgeInsets.only(top: 8.h),
                                  child: Center(
                                    child: Text(
                                      '본문 $index',
                                      style: AppTextStyle.koRegular18(),
                                    ),
                                  ),

                                ),
                                Container(
                                  height: whiteHeight / 15.h,
                                  alignment: Alignment.center,
                                                                    color: AppColor.shadowGrey,
                                  margin: EdgeInsets.only(top: 8.h),
                                  child: Center(
                                    child: Text(
                                      '날짜 $index',
                                      style: AppTextStyle.koRegular18(),
                                    ),
                                  ),

                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
