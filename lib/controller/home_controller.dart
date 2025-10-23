import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  RxList<Map<String, dynamic>> postList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> dailyPostList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> insightPostList = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  var currentPage = 'home'.obs; // ✅ 현재 페이지 상태
  Map<String, dynamic>? selectedPost;

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
    loadAllPosts();
    loadDailyPosts();
    loadInsightPosts();
    print('지금 탭의 갯수는?? : ${postList.length}');
    print('지금 탭의 갯수는?? : ${dailyPostList.length}');
    print('지금 탭의 갯수는?? : ${insightPostList.length}');
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose(); // ✅ FocusNode 정리
    super.onClose();
  }

  Future<Map<String, int>> fetchDailyVisits() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('visits').get();
    Map<String, int> dailyCounts = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final date = data['date'] ?? '';
      if (date.isNotEmpty) {
        dailyCounts[date] = (dailyCounts[date] ?? 0) + 1;
      }
    }

    return dailyCounts;
  }

  void logVisit(String userId) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    FirebaseFirestore.instance.collection('visits').doc('$userId-$today').set({
      'userId': userId,
      'date': today,
      'timestamp': FieldValue.serverTimestamp(),
    });
    print('방문자 확인');
  }

  Future<void> initAuth() async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      final cred = await auth.signInAnonymously();
      print("익명 로그인 완료: ${cred.user!.uid}");
    } else {
      print("이미 로그인된 유저: ${auth.currentUser!.uid}");
    }
  }

  Future loadAllPosts() async {
    FirebaseFirestore.instance
        .collection('post')
        .where('status', isEqualTo: '발행')
        .orderBy('date', descending: true)
        .snapshots() // ✅ get() 대신 snapshots()
        .listen((snapshot) {
      postList.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      print('🔥 실시간 업데이트됨! 현재 총 게시글 수: ${postList.length}');
    });
  }

  void loadDailyPosts() {
    FirebaseFirestore.instance
        .collection('post')
        .where('category', isEqualTo: '데일리 팩트')
        .where('status', isEqualTo: '발행')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      dailyPostList.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      print('🔥 데일리 팩트 실시간 반영: ${dailyPostList.length}');
    });
  }

  void loadInsightPosts() {
    FirebaseFirestore.instance
        .collection('post')
        .where('category', isEqualTo: '인사이트 팩트')
        .where('status', isEqualTo: '발행')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      insightPostList.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      print('🔥 인사이트 팩트 실시간 반영: ${insightPostList.length}');
    });
  }
}
