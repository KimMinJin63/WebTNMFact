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
  RxList<Map<String, dynamic>> donePostList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> notPostList = <Map<String, dynamic>>[].obs;
  RxString postTitle = ''.obs;
  RxString postContent = ''.obs;
  RxString postCategory = ''.obs;
  RxInt totalCount = 0.obs;
  RxInt publishedCount = 0.obs;
  RxInt pendingCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPostCounts();
    fetchAllPosts();
    fetchNotPosts();
    fetchDonePosts();
  }

  void selectTab(int index) {
    selectedIndex.value = index;
  }

  Future<void> fetchAllPosts({String? searchQuery}) async {
    try {
      final snapshot = await firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();

      postList.value = snapshot.docs.map((doc) {
        final timestamp = doc['createdAt'] as Timestamp?;
        final dateTime = timestamp?.toDate() ?? DateTime.now();
        final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss a', 'ko_KR')
            .format(dateTime); // 원하는 형식 지정
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

  Future<void> fetchNotPosts({String? searchQuery}) async {
    try {
      final snapshot = await firestore
          .collection('posts')
          .where('status', isEqualTo: '미발행') // 🔍 미발행 필터
          .orderBy('createdAt', descending: true) // 최신순 정렬
          .get();

      notPostList.value = snapshot.docs.map((doc) {
        final timestamp = doc['createdAt'] as Timestamp?;
        final dateTime = timestamp?.toDate() ?? DateTime.now();
        final formattedDate =
            DateFormat('yyyy-MM-dd HH:mm:ss a', 'ko_KR').format(dateTime);
        return {
          'id': doc.id,
          'title': doc['title'],
          'content': doc['content'],
          'category': doc['category'],
          'author': doc['author'],
          'createdAt': formattedDate,
          'status': doc['status'],
        };
      }).toList();

      print('📄 미발행 게시글 불러오기 성공');
      print('총 미발행 게시글 수: ${snapshot.docs.length}');
    } catch (e) {
      print('🔥 미발행 게시글 불러오기 실패: $e');
    }
  }

  Future<void> fetchDonePosts({String? searchQuery}) async {
    try {
      final snapshot = await firestore
          .collection('posts')
          .where('status', isEqualTo: '발행')
          .orderBy('createdAt', descending: true)
          .get();

      donePostList.value = snapshot.docs.map((doc) {
        final timestamp = doc['createdAt'] as Timestamp?;
        final dateTime = timestamp?.toDate() ?? DateTime.now();
        final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss a', 'ko_KR')
            .format(dateTime); // 원하는 형식 지정
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

  Future<void> fetchAllPostCounts() async {
    try {
      final totalSnapshot = await firestore.collection('posts').get();
      print('총 게시글 수: ${totalSnapshot.size}');
      totalCount.value = totalSnapshot.size;

      final publishedSnapshot = await firestore
          .collection('posts')
          .where('status', isEqualTo: '발행')
          .get();
      publishedCount.value = publishedSnapshot.size;
      print('발행된 게시글 수: ${publishedCount.value}');

      final pendingSnapshot = await firestore
          .collection('posts')
          .where('status', isEqualTo: '미발행')
          .get();
      pendingCount.value = pendingSnapshot.size;
      print('미발행된 게시글 수: ${pendingCount.value}');
    } catch (e) {
      print('🔥 게시글 카운트 불러오기 실패: $e');
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
      'title': title,
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

    await fetchAllPosts(); // 또는 현재 탭에 맞는 함수

    update(); // GetX 상태 갱신
  } catch (e) {
    print('🔥 게시글 수정 실패: $e');
  }
}
}
