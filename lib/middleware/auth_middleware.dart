import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnm_fact/controller/login_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
     print("🔥 AuthMiddleware 실행됨. route = $route");
    final loginController = Get.find<LoginController>();

    // 🔥 로그인 여부 확인
    if (FirebaseAuth.instance.currentUser == null) {
      return const RouteSettings(name: '/admin');
    }

    return null;
  }
}
