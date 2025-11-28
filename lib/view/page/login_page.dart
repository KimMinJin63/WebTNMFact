import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/controller/login_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});
  static const route = '/admin';

  @override
  Widget build(BuildContext context) {
     AdminController adminController = Get.find<AdminController>();
    return Scaffold(
      backgroundColor: AppColor.shadowGrey,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24.w),
          width: 360.w,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('사용자명', style: TextStyle(fontSize: 14.sp)),
              SizedBox(height: 8.h),
              TextField(
                controller: controller.usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                ),
              ),
              SizedBox(height: 16.h),
              Text('비밀번호', style: TextStyle(fontSize: 14.sp)),
              SizedBox(height: 8.h),
              Obx(() => TextField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 12.h),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 20.sp,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  )),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Obx(() => Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: (val) =>
                            controller.rememberMe.value = val ?? false,
                      )),
                  Text('기억하기', style: TextStyle(fontSize: 13.sp)),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      String email = controller.usernameController.text.trim();
                      String password =
                          controller.passwordController.text.trim();
                      print('로그인 성공: $email');
                      print('로그인 성공: $password');
                      adminController.menuSelectedIndex.value =0;
                      adminController.isCreate.value = false;
                      adminController.isEditing.value = false;

                      if (email.isNotEmpty && password.isNotEmpty) {
                        await controller.login(email, password);
                      } else {
                        Get.snackbar('오류', '이메일과 비밀번호를 입력하세요');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 24.w,
                      ),
                      backgroundColor: Colors.blue,
                      textStyle: TextStyle(fontSize: 14.sp),
                    ),
                    child: const Text('로그인'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
