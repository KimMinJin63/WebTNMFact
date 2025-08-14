import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';

class AdminController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxInt selectedIndex = 0.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<Map<String, dynamic>> postList = <Map<String, dynamic>>[].obs;
  RxString postTitle = ''.obs;
  RxString postContent = ''.obs;
  RxString postCategory = ''.obs;
  RxInt totalCount = 0.obs;
  RxInt publishedCount = 0.obs;
  RxInt pendingCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPostCounts(); // 앱 실행 시 카운트 불러오기
    fetchPosts(); // 앱 실행 시 카운트 불러오기
  }

  void selectTab(int index) {
    selectedIndex.value = index;
  }

Future<void> fetchPosts({String? searchQuery}) async {
  try {
    final snapshot = await firestore
        .collection('posts')
        .get();

    postList.value = snapshot.docs.map((doc) {
      final timestamp = doc['createdAt'] as Timestamp?;
      final dateTime = timestamp?.toDate() ?? DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss a', 'ko_KR').format(dateTime); // 원하는 형식 지정
      return {
        'id': doc.id,
        'title': doc['title'],
        'content': doc['content'],
        'category': doc['category'],
        'author': doc['author'],
        'createdAt': formattedDate, // String으로 저장
        // 'status': doc['status'] ?? 'pending', // 기본값 설정
        // 'imageUrl': doc['imageUrl'] ?? '', // 이미지 URL이 없을 경우
      };
    }).toList();

    print('게시글 불러오기 성공');
    print('총 게시글 수: ${snapshot.docs.length}');
  } catch (e) {
    print('🔥 게시글 불러오기 실패: $e');
  }
}

  Future<void> fetchPostCounts() async {
    try {
      final totalSnapshot = await firestore.collection('posts').get();
      print('총 게시글 수: ${totalSnapshot.size}');
      totalCount.value = totalSnapshot.size;
      print('발행된 게시글 수: ${totalCount.value}');

      final publishedSnapshot = await firestore
          .collection('posts')
          .where('status', isEqualTo: 'published')
          .get();
      publishedCount.value = publishedSnapshot.size;

      final pendingSnapshot = await firestore
          .collection('posts')
          .where('status', isEqualTo: 'pending')
          .get();
      pendingCount.value = pendingSnapshot.size;
    } catch (e) {
      print('🔥 게시글 카운트 불러오기 실패: $e');
    }
  }
}
