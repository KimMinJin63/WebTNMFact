import 'package:flutter/material.dart';
import 'package:tnm_fact/utils/app_color.dart';

class CategoryHelper {
  /// 카테고리 텍스트 색상
  static Color getCategoryColor(String category) {
    switch (category) {
      case '데일리 팩트':
        return AppColor.primary;
      case '인사이트 팩트':
        return AppColor.yellow;
      case '포커스 팩트':
        return AppColor.focusFact;
      case '피플&뷰':
        return AppColor.peopleView;
      default:
        return AppColor.grey;
    }
  }

  /// 카테고리 배경색
  static Color getCategoryBackgroundColor(String category) {
    switch (category) {
      case '데일리 팩트':
        return AppColor.primary.withOpacity(0.1);
      case '인사이트 팩트':
        return AppColor.yellow.withOpacity(0.2);
      case '포커스 팩트':
        return AppColor.focusFact.withOpacity(0.1);
      case '피플&뷰':
        return AppColor.peopleView.withOpacity(0.2);
      default:
        return AppColor.grey.withOpacity(0.1);
    }
  }

  /// 카테고리별 작성자명(기자명)
  static String getCategoryName(String category) {
    switch (category) {
      case '데일리 팩트':
        return 'tnm팩트 편집부';
      case '인사이트 팩트':
        return '편집위원 김병국';
      case '포커스 팩트':
        return '에디터 힙더바리';
      case '피플&뷰':
        return '편집위원 김병국';
      default:
        return '김병국';
    }
  }
}
