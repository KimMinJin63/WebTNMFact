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

class AppRoutes {
  static const login = '/admin'; //로그인
  // static const admin = '/adminHome'; //어드민 페이지
  static const home = '/'; // 메인 페이지
  // static const create = '/create'; // 작성 페이지
  // static const edit = '/edit'; // 수정 페이지
  // static const detail = DetailPage.route; // 수정 페이지
  // static const dash = '/dash'; // 수정 페이지
  static const layout = '/admin/home'; // 수정 페이지
  static const service = '/service'; // 수정 페이지
  static const privacy = '/privacy'; // 수정 페이지
}
