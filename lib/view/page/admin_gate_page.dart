import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tnm_fact/view/page/login_page.dart';

class AdminAuthGate extends StatelessWidget {
  final Widget child;

  const AdminAuthGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("로그인 정보 복원 중...");
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data;

        if (user == null) {
          print("로그인 안 됨 → 로그인 페이지 이동");
          return const LoginPage();
        }

        print("로그인됨 → 이메일: ${user.email}, displayName: ${user.displayName}");
        return child; // AdminLayoutPage
      },
    );
  }
}
