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
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // final post = box.read('post');
    // final post = Get.arguments;
    final post = adminController.currentPost.value;
    print('컨트롤러에서는 잘 받아오나?? : ${post?['title']}');
    print('컨트롤러에서는 잘 받아오나?? : ${post?['content']}');
    print('컨트롤러에서는 잘 받아오나?? : ${post?['category']}');
    print('컨트롤러에서는 잘 받아오나?? : ${post?['status']}');

    if (post != null) {
      titleController.text = '[오늘의 교육 뉴스] ${post['title']}' ?? '';
      contentController.text = post['content'] ?? '';
      selectedCategory.value = post['category'] ?? '';
      selectedPublish.value = post['status'] ?? '';
    }
  }

  Future<void> editPost({
    required String title,
    required String content,
    required String category,
    required String author,
    required String status,
    required String docId,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'title': '[오늘의 교육 뉴스] $title',
        'content': content,
        'category': category,
        'author': author,
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(docId)
          .update(updateData);

      await adminController.fetchAllPosts(); // 또는 현재 탭에 맞는 함수

      update(); // GetX 상태 갱신
    } catch (e) {
      print('🔥 게시글 수정 실패: $e');
    }
  }
}
