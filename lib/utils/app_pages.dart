import 'package:get/get.dart';
import 'package:tnm_fact/middleware/auth_middleware.dart';
import 'package:tnm_fact/utils/app_routes.dart';
import 'package:tnm_fact/view/page/admin_layout_page.dart';
import 'package:tnm_fact/view/page/admin_page.dart';
import 'package:tnm_fact/view/page/create_page.dart';
import 'package:tnm_fact/view/page/dash_board_page.dart';
import 'package:tnm_fact/view/page/detail_page.dart';
import 'package:tnm_fact/view/page/edit_page.dart';
import 'package:tnm_fact/view/page/home_page.dart';
import 'package:tnm_fact/view/page/login_page.dart';
import 'package:tnm_fact/view/page/privacy_policy_page.dart';
import 'package:tnm_fact/view/page/terms_of_service_page.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
    // GetPage(name: AppRoutes.layout, page: () => const AdminLayoutPage()),
    GetPage(
      name: AppRoutes.layout,
      page: () => const AdminLayoutPage(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),

    // 독립 라우트만 추가
    GetPage(name: AppRoutes.service, page: () => TermsOfServicePage()),
    GetPage(name: AppRoutes.privacy, page: () => PrivacyPolicyPage()),
  ];
}
