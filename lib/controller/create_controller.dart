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
  // RxString selectedFocus = ''.obs;
  // RxString selectedPeople = ''.obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final AdminController adminController = Get.find<AdminController>();
  RxBool isButtonActivate = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String _sanitizeDocId(String raw) {
    // Firestore 문서 ID는 '/'를 포함할 수 없음. (콘솔에서 보기 좋게 공백은 유지)
    // 길이도 너무 길어지지 않게 제한.
    final trimmed = raw.trim();
    final noSlash = trimmed.replaceAll('/', '／');
    return noSlash.length <= 180 ? noSlash : noSlash.substring(0, 180).trim();
  }

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
    // required String focus,
    // required String people,
    required int viewpoint,
  }) async {
    try {
      final normalizedTitle = normalizeTitleForCategory(title, category);
      final baseId = _sanitizeDocId(normalizedTitle.isEmpty ? title : normalizedTitle);
      if (baseId.isEmpty) return;

      final postCol = firestore.collection('post');
      var docId = baseId;

      // 동일 제목이 이미 있으면 뒤에 타임스탬프를 붙여 충돌 회피
      final existing = await postCol.doc(docId).get();
      if (existing.exists) {
        final suffix = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        docId = _sanitizeDocId('${baseId}_$suffix');
      }

      await postCol.doc(docId).set({
        'title': normalizedTitle,
        'final_article': final_article,
        'category': category,
        'editor': editor,
        'date': FieldValue.serverTimestamp(),
        'status': status,
        'viewpoint': 0,
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to create post: $e');
    }
  }

  activateButton() {
    if (titleController.text.isNotEmpty &&
        contentController.text.isNotEmpty &&
        selectedCategory.value.isNotEmpty &&
        selectedPublish.value.isNotEmpty
        // selectedFocus.value.isNotEmpty ||
        // selectedPeople.value.isNotEmpty
        ) {
      print('입력이 완료됨');

      isButtonActivate.value = true;
    } else {
      isButtonActivate.value = false;
    }
  }
}
