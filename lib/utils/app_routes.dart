import 'package:tnm_fact/view/page/admin_layout_page.dart';
import 'package:tnm_fact/view/page/admin_page.dart';
import 'package:tnm_fact/view/page/create_page.dart';
import 'package:tnm_fact/view/page/dash_board_page.dart';
import 'package:tnm_fact/view/page/detail_page.dart';
import 'package:tnm_fact/view/page/edit_page.dart';
import 'package:tnm_fact/view/page/home_page.dart';
import 'package:tnm_fact/view/page/login_page.dart';

class AppRoutes {
  static const login = LoginPage.route; //로그인
  static const admin = AdminPage.route; //어드민 페이지
  static const home = HomePage.route; // 메인 페이지
  static const create = CreatePage.route; // 작성 페이지
  static const edit = EditPage.route; // 수정 페이지
  static const detail = DetailPage.route; // 수정 페이지
  static const dash = DashBoardPage.route; // 수정 페이지
  static const layout = AdminLayoutPage.route; // 수정 페이지
}
