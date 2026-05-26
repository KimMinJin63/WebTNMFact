import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnm_fact/utils/app_routes.dart';
import 'package:tnm_fact/utils/app_transitions.dart';
import 'package:tnm_fact/view/page/admin_gate_page.dart';
import 'package:tnm_fact/view/page/admin_layout_page.dart';
import 'package:tnm_fact/view/page/home_page.dart';
import 'package:tnm_fact/view/page/post_detail_page.dart';
import 'package:tnm_fact/view/page/login_page.dart';
import 'package:tnm_fact/view/page/privacy_policy_page.dart';
import 'package:tnm_fact/view/page/terms_of_service_page.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
    GetPage(
      name: AppRoutes.post,
      page: () => const PostDetailPage(),
      transition: postForwardTransition,
      popGesture: !kIsWeb,
      curve: Curves.easeOutCubic,
      transitionDuration: postTransitionDuration,
    ),
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
    // GetPage(name: AppRoutes.layout, page: () => const AdminLayoutPage()),
    GetPage(
      name: AppRoutes.layout,
      page: () => AdminAuthGate(child: const AdminLayoutPage()),
    ),

    // 독립 라우트만 추가
    GetPage(name: AppRoutes.service, page: () => TermsOfServicePage()),
    GetPage(name: AppRoutes.privacy, page: () => PrivacyPolicyPage()),
  ];
}
