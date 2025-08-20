import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  RxList<Map<String, dynamic>> postList = <Map<String, dynamic>>[].obs;
    final isLoading = false.obs;

  void selectTab(int index) {
    selectedIndex.value = index;
  }

  void clearFocus() {
    if (searchFocusNode.hasFocus) {
      searchFocusNode.unfocus();
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose(); // ✅ FocusNode 정리
    super.onClose();
  }

  Future loadPosts() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();

      postList.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
      print('게시글 불러오기 성공');
      print('총 게시글 수: ${snapshot.docs.length}');
      print('게시글 목록: ${postList[0]}');
    } catch (e) {
      print('🔥 게시글 로딩 중 오류 발생: $e');
    }
  }
}
