import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnm_fact/controller/home_controller.dart';
import 'package:tnm_fact/utils/app_routes.dart';
import 'package:tnm_fact/utils/web_history.dart';

/// 목록에서 상세로 들어온 경우 [Get.back], URL 직접 진입 등 스택이 없으면 홈으로 이동.
void navigateBackToHome({BuildContext? context}) {
  if (Get.isRegistered<HomeController>()) {
    Get.find<HomeController>().clearFocus();
  }

  final bool canPop = context != null
      ? Navigator.of(context).canPop()
      : (Get.key.currentState?.canPop() ?? false);

  if (canPop) {
    Get.back();
    return;
  }

  if (kIsWeb) {
    final path = Uri.base.path;
    if (path.startsWith('/post/')) {
      // offNamed만 쓰면 브라우저 히스토리에 / 가 안 남아 스와이프 시 사이트 이탈
      replaceBrowserUrlWithHome();
      Get.offNamed(AppRoutes.home);
      return;
    }
  }

  Get.offNamed(AppRoutes.home);
}
