import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CreateController extends GetxController {
  RxString selectedCategory = ''.obs;
  RxString selectedPublish = ''.obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future createPost({
    required String title,
    required String content,
    required String category,
    required String author,
    required String status,
  }) async {
    try {
      final docRef = await firestore.collection('posts').add({
        'title': title,
        'content': content,
        'category': category,
        'author': author,
        'createdAt': FieldValue.serverTimestamp(),
        'status': status,
      });

      final docId = docRef.id;
      Get.dialog(
        AlertDialog(
          title: const Text('게시글 작성 완료'),
          content: const Text('게시글이 성공적으로 작성되었습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // 다이얼로그 닫기
                Get.offAllNamed('/admin'); // 관리자 페이지로 이동
              },
              child: const Text('확인'),
            ),
          ],
        ),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to create post: $e');
    }
  }
}
