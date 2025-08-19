import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:tnm_fact/view/page/admin_page.dart';

class CreateController extends GetxController {
  RxString selectedCategory = ''.obs;
  RxString selectedPublish = ''.obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final AdminController adminController = Get.find<AdminController>();

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
    } catch (e) {
      Get.snackbar('Error', 'Failed to create post: $e');
    }
  }
}
