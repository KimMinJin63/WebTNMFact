import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/utils/app_title.dart';

class EditController extends GetxController {
  final AdminController adminController = Get.find<AdminController>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  RxString selectedCategory = ''.obs;
  RxString selectedPublish = ''.obs;
  // RxString selectedFocus = ''.obs;
  // RxString selectedPeople = ''.obs;
  final box = GetStorage();
  final kDailyPrefix = '[오늘의 주요 이슈 TOP 3] ';

  @override
  void onInit() {
    super.onInit();
    // final post = box.read('post');
    // final post = Get.arguments;
    final post = adminController.currentPost.value;
    print('컨트롤러에서는 잘 받아오나?? : ${post?['title']}');
    print('컨트롤러에서는 잘 받아오나?? : ${post?['final_article']}');
    print('컨트롤러에서는 잘 받아오나?? : ${post?['category']}');
    print('컨트롤러에서는 잘 받아오나?? : ${post?['status']}');

    if (post != null) {
      titleController.text = post['title'] ?? '';
      contentController.text = post['content'] ?? '';
      selectedCategory.value = post['category'] ?? '';
      selectedPublish.value = post['status'] ?? '';
      // selectedFocus.value = post['focus'] ?? '';
      // selectedPeople.value = post['people'] ?? '';
    }
  }

  Future<void> editPost({
    required String? title,
    required String final_article,
    required String category,
    required String editor,
    required String status,
    // required String focus,
    // required String people,
    required String docId,
  }) async {
    try {
      final normalizedTitle = normalizeTitleForCategory(title, category);
      print('🔥 수정할 문서 ID: $normalizedTitle');

     final Map<String, dynamic> updateData = {

        'title': normalizedTitle,
        'final_article': final_article,
        'category': category,
        'editor': editor,
        'status': status,
        // 'focus': focus,
        // 'people': people,
        // 'date': status == '발행' ? FieldValue.serverTimestamp() : '작성 중',
        // 'date': FieldValue.serverTimestamp(),
      };

      final currentPost = adminController.currentPost.value;

      // ✅ 미발행 → 발행 으로 바뀔 때만 날짜 갱신
      if (status == '발행' && (currentPost?['status'] != '발행')) {
        updateData['date'] = FieldValue.serverTimestamp();
      }

      await FirebaseFirestore.instance
          .collection('post') // ✅ 통일
          .doc(docId)
          .update(updateData);

      await adminController.fetchAllPosts();
      update();
    } catch (e) {
      print('🔥 게시글 수정 실패: $e');
    }
  }
}
