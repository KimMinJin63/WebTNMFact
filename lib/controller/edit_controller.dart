import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tnm_fact/controller/admin_controller.dart';

class EditController extends GetxController {
  final AdminController adminController = Get.find<AdminController>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  RxString selectedCategory = ''.obs;
  RxString selectedPublish = ''.obs;
  RxString selectedSubCategory = ''.obs; // 이슈 팩트 세부 분류
  // RxString selectedFocus = ''.obs;
  // RxString selectedPeople = ''.obs;
  final box = GetStorage();
  // final kDailyPrefix = '[오늘의 주요 이슈 TOP 3] ';

  @override
  void onInit() {
    super.onInit();
    // EditController는 한 번 만들어지면 계속 재사용되므로(onInit은 최초 1회),
    // 수정할 글이 바뀔 때마다 입력칸을 다시 채운다.
    loadPost(adminController.currentPost.value);
    ever<Map<String, dynamic>?>(adminController.currentPost, loadPost);
  }

  /// 수정할 글의 내용으로 입력칸을 채운다.
  void loadPost(Map<String, dynamic>? post) {
    if (post == null) return;
    titleController.text = (post['title'] ?? '').toString();
    contentController.text = (post['final_article'] ?? '').toString();
    selectedCategory.value = (post['category'] ?? '').toString();
    selectedPublish.value = (post['status'] ?? '').toString();
    selectedSubCategory.value = (post['subCategory'] ?? '').toString();
  }

  Future<void> editPost({
    required String? title,
    required String final_article,
    required String category,
    String subCategory = '',
    required String editor,
    required String status,
    // required String focus,
    // required String people,
    required String docId,
  }) async {
    try {
      // final normalizedTitle = normalizeTitleForCategory(title, category);
      // print('🔥 수정할 문서 ID: $normalizedTitle');

     final Map<String, dynamic> updateData = {

        'title': title,
        'final_article': final_article,
        'category': category,
        // 이슈 팩트가 아니거나 미선택이면 필드 삭제
        'subCategory': (category == '이슈 팩트' && subCategory.isNotEmpty)
            ? subCategory
            : FieldValue.delete(),
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
