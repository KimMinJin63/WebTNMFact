import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tnm_fact/helpers/app_category_helper.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';
import 'package:tnm_fact/view/widget/%08app_checkbox.dart';

/// 이슈 팩트 세부 분류(정치·국제·경제·사회·스포츠) 선택. 하나만 고를 수 있다.
/// 부모 Obx는 자식 위젯의 build에서 읽은 값을 추적하지 못하므로
/// 선택값 변화는 이 위젯 안의 Obx가 직접 감지한다.
class AppIssueSubCategorySelector extends StatelessWidget {
  const AppIssueSubCategorySelector({super.key, required this.selected});

  final RxString selected;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Text('이슈 팩트 세부 분류',
                style: AppTextStyle.koSemiBold16()
                    .copyWith(color: AppColor.black)),
            SizedBox(height: 8.h),
            for (final sub in CategoryHelper.issueSubCategories)
              AppCheckboxTile(
                label: sub,
                shape: const CircleBorder(),
                value: selected.value == sub,
                onChanged: (v) => selected.value = v! ? sub : '',
              ),
          ],
        ));
  }
}
