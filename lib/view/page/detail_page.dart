// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:tnm_fact/controller/home_controller.dart';
// import 'package:tnm_fact/utils/app_color.dart';
// import 'package:tnm_fact/utils/app_text_style.dart';

// class DetailView extends StatelessWidget {
//   final Map<String, dynamic> post;
//   const DetailView({super.key, required this.post});

//   @override
//   Widget build(BuildContext context) {
//     final rawDate = post['date'];
//     String titleDate = '';
//     if (rawDate is Timestamp) {
//       titleDate = DateFormat('yy.MM.dd').format(rawDate.toDate());
//     }
//     print('post date: ${post['date']}');
//     print('titleDate: $titleDate');

//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 final homeController = Get.find<HomeController>();
//                 homeController.currentPage.value = 'home'; // ✅ 목록으로 복귀
//               },
//               child: Row(
//                 children: [
//                   Icon(Icons.arrow_back, color: AppColor.primary),
//                   SizedBox(width: 4.w),
//                   Text('목록으로 돌아가기',
//                       style: AppTextStyle.koSemiBold14()
//                           .copyWith(color: AppColor.primary)),
//                 ],
//               ),
//             ),
//             SizedBox(height: 24.h),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
//               decoration: BoxDecoration(
//                 color: post['category'] == '데일리 팩트'
//                     ? AppColor.primary.withOpacity(0.1)
//                     : AppColor.yellow.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(80.r),
//               ),
//               child: Text(
//                 post['category'],
//                 style: AppTextStyle.koSemiBold14().copyWith(
//                   color: post['category'] == '데일리 팩트'
//                       ? AppColor.primary
//                       : AppColor.yellow,
//                 ),
//               ),
//             ),
//             SizedBox(height: 12.h),
//             Text('[오늘의 교육 뉴스] $titleDate',
//                 style: AppTextStyle.koBold35()),
//             SizedBox(height: 8.h),
//             Text('작성자: ${post['editor']} | $titleDate',
//                 style: AppTextStyle.koRegular14()),
//             SizedBox(height: 24.h),
//             Text(post['final_article'],
//                 style: AppTextStyle.koRegular18()
//                     .copyWith(color: AppColor.black)),
//           ],
//         ),
//       ),
//     );
//   }
// }
