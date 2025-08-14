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
                itemCount: 12, // 원하시는 개수로 변경하세요
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 40.w,
                  mainAxisSpacing: 32.h,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
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
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          children: [
                            // 상단 이미지 영역
                            AspectRatio(
                              aspectRatio: 3 / 2,
                              child: Container(
                                width: double.infinity,
                                color: AppColor.grey,
                                child: Center(
                                  child: Text('이미지 $index',
                                      style: AppTextStyle.koRegular18()),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  _buildFlexibleBox('해시태그 $index', flex: 2),
                                  _buildFlexibleBox('제목 제목 제목 제목 제목 $index',
                                      flex: 2),
                                  _buildFlexibleBox(
                                      '본문이 아주 길 수도 있고\n2줄도 될 수 있음 $index',
                                      flex: 5),
                                  _buildFlexibleBox('2025.08.14', flex: 1),
                                ],
                              ),
                            ),
                          ],
                        )),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget _buildFlexibleBox(String text, {required int flex}) {
  return Expanded(
    flex: flex,
    child: Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      alignment: Alignment.center,
      color: AppColor.shadowGrey,
      child: Text(
        text,
        style: AppTextStyle.koRegular18(),
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}
