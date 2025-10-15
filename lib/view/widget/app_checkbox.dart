import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class AppCheckboxTile extends StatelessWidget {
  const AppCheckboxTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged, this.shape,
  });

  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final OutlinedBorder? shape;

  @override
  Widget build(BuildContext context) {
    final double box = (ScreenUtil().screenWidth * 0.025).clamp(20.0, 36.0);

    // final double box = 20.w; // 체크박스 목표 크기

    return ListTileTheme(
      minLeadingWidth: box + 8.w, // 모든 타일에서 동일한 leading 폭
      horizontalTitleGap: 8.w, // 체크박스-텍스트 간격
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(horizontal: -1, vertical: -2),
        contentPadding: EdgeInsets.zero,
        leading: SizedBox(
          width: box,
          height: box,
          child: FittedBox(
            // 박스를 정확히 box x box에 맞춤
            fit: BoxFit.contain,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: shape,  // 원형 사용 시
            ),
          ),
        ),
        title: Text(
          label,
          style: AppTextStyle.koRegular18().copyWith(color: AppColor.black),
        ),
        onTap: () => onChanged(!value), // 텍스트 눌러도 토글
      ),
    );
  }
}
