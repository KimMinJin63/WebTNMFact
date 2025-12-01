import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/controller/create_controller.dart';
import 'package:tnm_fact/controller/edit_controller.dart';
import 'package:tnm_fact/controller/home_controller.dart';
import 'package:tnm_fact/controller/login_controller.dart';
import 'package:tnm_fact/firebase_options.dart';
import 'package:tnm_fact/utils/app_pages.dart';
import 'package:tnm_fact/view/page/admin_layout_page.dart';
import 'package:tnm_fact/view/page/admin_page.dart';
import 'package:tnm_fact/view/page/home_page.dart';
import 'package:tnm_fact/view/page/login_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    await Future.wait([
    rootBundle.load('assets/fonts/Pretendard-Regular.otf'),
    rootBundle.load('assets/fonts/Pretendard-Medium.otf'),
    rootBundle.load('assets/fonts/Pretendard-SemiBold.otf'),
    rootBundle.load('assets/fonts/Pretendard-Bold.otf'),
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('ko_KR', null); // ✅ 로케일 설정 추가
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 900),
      minTextAdapt: false,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'TNM FACT',
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          initialBinding: BindingsBuilder(() {
            Get.lazyPut(() => HomeController(), fenix: true);
            Get.lazyPut(() => LoginController(), fenix: true);
            Get.put(AdminController(), permanent: true);
            Get.lazyPut(() => CreateController(), fenix: true);
            Get.lazyPut(() => EditController(), fenix: true);
          }),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: '/',
          // getPages: [
          //   GetPage(name: '/', page: () => const HomePage()),
          //   GetPage(name: '/admin', page: () => const LoginPage()),
          //   GetPage(name: '/admin/home', page: () => const AdminLayoutPage()),
          // ],
           // home: const AdminLayoutPage(),
          // home: const LoginPage(),
          getPages: AppPages.pages,
          // home: const HomePage(),
          // initialRoute / getPages 조합을 쓰려면 아래처럼:
          // initialRoute: HomePage.route,
          // getPages: [
          //   GetPage(name: HomePage.route, page: () => const HomePage()),
          // ],
        );
      },
    );
  }
}
