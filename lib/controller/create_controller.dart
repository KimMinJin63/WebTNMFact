import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/utils/app_title.dart';
import 'package:tnm_fact/view/page/admin_page.dart';

class CreateController extends GetxController {
  RxString selectedCategory = ''.obs;
  RxString selectedPublish = ''.obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final AdminController adminController = Get.find<AdminController>();
  RxBool isButtonActivate = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    // 🔹 입력값 변화 감지
    titleController.addListener(activateButton);
    contentController.addListener(activateButton);
    ever(selectedCategory, (_) => activateButton());
    ever(selectedPublish, (_) => activateButton());
  }

  Future createPost({
    required String title,
    required String final_article,
    required String category,
    required String editor,
    required String status,
    required int viewpoint,
  }) async {
    try {
      // final now = DateTime.now();
      final normalizedTitle = normalizeTitleForCategory(title, category);

      final docRef = await firestore.collection('post').add({
        // ✅ post로 통일
        'title': normalizedTitle,
        'final_article': final_article,
        'category': category,
        'editor': editor,
        'date': FieldValue.serverTimestamp(),
        // 'createdAtTs': FieldValue.serverTimestamp(),
        'status': status,
        'viewpoint': 0,
      });

      final docId = docRef.id;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create post: $e');
    }
  }

  activateButton() {
    if (titleController.text.isNotEmpty &&
        contentController.text.isNotEmpty &&
        selectedCategory.value.isNotEmpty &&
        selectedPublish.value.isNotEmpty) {
      print('입력이 완료됨');

      isButtonActivate.value = true;
    } else {
      isButtonActivate.value = false;
    }
  }
}
