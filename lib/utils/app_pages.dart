import 'package:get/get.dart';
import 'package:tnm_fact/utils/app_routes.dart';
import 'package:tnm_fact/view/page/admin_layout_page.dart';
import 'package:tnm_fact/view/page/admin_page.dart';
import 'package:tnm_fact/view/page/create_page.dart';
import 'package:tnm_fact/view/page/dash_board_page.dart';
import 'package:tnm_fact/view/page/detail_page.dart';
import 'package:tnm_fact/view/page/edit_page.dart';
import 'package:tnm_fact/view/page/home_page.dart';
import 'package:tnm_fact/view/page/login_page.dart';

class AppPages{
  static final pages = [
 GetPage(
        name: AppRoutes.login,
        page: () => const LoginPage(),
        transition: Transition.fadeIn),
 GetPage(
        name: AppRoutes.admin,
        page: () => const AdminPage(),
        transition: Transition.fadeIn),
 GetPage(
        name: AppRoutes.home,
        page: () => const HomePage(),
        transition: Transition.fadeIn),
 GetPage(
        name: AppRoutes.create,
        page: () => const CreatePage(),
        transition: Transition.fadeIn),
 GetPage(
        name: AppRoutes.edit,
        page: () => EditPage(),
        transition: Transition.fadeIn),
 GetPage(
        name: AppRoutes.detail,
        page: () => const DetailPage(),
        transition: Transition.fadeIn),
 GetPage(
        name: AppRoutes.dash,
        page: () => const DashBoardPage(),
        transition: Transition.fadeIn),
 GetPage(
        name: AppRoutes.layout,
        page: () => const AdminLayoutPage(),
        transition: Transition.fadeIn),
//  GetPage(
//         name: AppRoutes.erase,
//         page: () => const ErasePage(),
//         transition: Transition.fadeIn),
//  GetPage(
//         name: AppRoutes.category,
//         page: () => const CategoryList(),
//         transition: Transition.fadeIn),
  ];
}