import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tnm_fact/controller/home_page_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});
  static const route = '/homepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: ScreenUtil().screenWidth / 5,
        // centerTitle: false,

        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: AppColor.white,
        titleSpacing: 0,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Text('TNM FACT', style: AppTextStyle.koBold28()),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              return TextButton(
                  onPressed: () {
                    controller.selectTab(0);
                  },
                  child: Text('전체기사',
                      style: AppTextStyle.koBold20().copyWith(
                            color: controller.selectedIndex.value == 0
                            ? AppColor.primary
                            : AppColor.black,
                      )));
            }),
            Obx(() {
              return TextButton(
                  onPressed: () {
                    controller.selectTab(1);
                  },
                  child: Text('데일리팩트',
                      style: AppTextStyle.koBold20().copyWith(
                        color: controller.selectedIndex.value == 1
                            ? AppColor.primary
                            : AppColor.black,
                      )));
            }),
            Obx(() {
              return TextButton(
                  onPressed: () {
                    controller.selectTab(2);
                  },
                  child: Text('인사이트팩트',
                      style: AppTextStyle.koBold20().copyWith(
                        color: controller.selectedIndex.value == 2
                            ? AppColor.primary
                            : AppColor.black,
                      )));
            }),
          ],
        ),
      ),
    );
  }
}
