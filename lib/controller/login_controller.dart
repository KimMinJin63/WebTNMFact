import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tnm_fact/view/page/admin_page.dart';
import 'package:tnm_fact/view/page/home_page.dart';

class LoginController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isPasswordVisible = false.obs;
  RxBool rememberMe = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed(AdminPage.route); // 로그인 성공 후 홈 페이지로 이동
    } catch (e) {
      Get.snackbar('로그인 실패', '이메일 또는 비밀번호를 확인해주세요');
      print('로그인 오류: $e');
    }
  }
}
