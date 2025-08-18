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
      Get.snackbar('Success', 'Post created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create post: $e');
    }
  }
}
