import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/view/page/admin_layout_page.dart';
import 'package:tnm_fact/view/page/admin_page.dart';
import 'package:tnm_fact/view/page/home_page.dart';

class LoginController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isPasswordVisible = false.obs;
  RxBool rememberMe = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AdminController adminController = Get.find<AdminController>();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login(String email, String password) async {
    print("로그인 시도 email=$email / password=$password");
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("로그인 성공: ${credential.user}");

      adminController.menuSelectedIndex.value = 0; // 대시보드로 기본 이동
      adminController.isCreate.value = false;
      adminController.isEditing.value = false;
      // Get.offAllNamed(AdminPage.route);
      Get.offAllNamed('/admin/home');
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.code} / ${e.message}");
    } catch (e) {
      print("기타 오류: $e");
    }
  }
}
