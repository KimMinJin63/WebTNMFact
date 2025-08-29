import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  RxList<Map<String, dynamic>> originalPostList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> originalDonePostList =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> originalNotPostList =
      <Map<String, dynamic>>[].obs;
  RxBool isSearching = false.obs;
  RxInt menuSelectedIndex = 0.obs;
  var currentPage =
      0.obs; // 0: Dashboard, 1: AdminList, 2: Settings, 3: EditPage
  var currentPost = Rxn<Map<String, dynamic>>();

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

    final hasKeyword = searchController.text.trim().isNotEmpty;

    if (hasKeyword) {
      findPost();
    } else {
      if (index == 0)
        fetchAllPosts();
      else if (index == 1)
        fetchDonePosts();
      else
        fetchNotPosts();
    }
  }

  Future findPost() async {
    final searchQuery = searchController.text.trim().toLowerCase();
    final tabIndex = selectedIndex.value;

    isSearching.value = searchQuery.isNotEmpty; // ✅ 검색 상태 반영

    if (tabIndex == 0) {
      postList.value = originalPostList
          .where((p) =>
              p['title']?.toString().toLowerCase().contains(searchQuery) ??
              false)
          .toList();
    } else if (tabIndex == 1) {
      donePostList.value = originalDonePostList
          .where((p) =>
              p['title']?.toString().toLowerCase().contains(searchQuery) ??
              false)
          .toList();
    } else {
      notPostList.value = originalNotPostList
          .where((p) =>
              p['title']?.toString().toLowerCase().contains(searchQuery) ??
              false)
          .toList();
    }
  }

  Future deletePost(String docId) async {
    try {
      print('게시글 삭제 중... ID: $docId');
      await firestore.collection('posts').doc(docId).delete();

      Get.dialog(
        AlertDialog(
          title: const Text('삭제 완료'),
          content: const Text('게시글이 성공적으로 삭제되었습니다.'),
          actions: [
            TextButton(
              onPressed: () async {
                Get.back(); // 다이얼로그 닫기
              },
              child: const Text('확인'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete post: $e');
    }
  }

  Future<void> fetchAllPosts({String? searchQuery}) async {
    try {
      final snapshot = await firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();

      postList.value = snapshot.docs.map((doc) {
        final createdTimestamp = doc['createdAt'] as Timestamp?;
        final createdDate = createdTimestamp?.toDate() ?? DateTime.now();
        final formattedCreated =
            DateFormat('yyyy-MM-dd HH:mm:ss', 'ko_KR').format(createdDate);

        final updatedTimestamp = doc.data().containsKey('updatedAt')
            ? doc['updatedAt'] as Timestamp?
            : null;
        final formattedUpdated = updatedTimestamp != null
            ? DateFormat('yyyy-MM-dd HH:mm:ss', 'ko_KR')
                .format(updatedTimestamp.toDate())
            : null;

        return {
          'id': doc.id,
          'title': doc['title'],
          'content': doc['content'],
          'category': doc['category'],
          'author': doc['author'],
          'createdAt': formattedCreated,
          'updatedAt': formattedUpdated,
          'status': doc['status'], // 기본값 설정
          // 'imageUrl': doc['imageUrl'] ?? '', // 이미지 URL이 없을 경우
        };
      }).toList();

      originalPostList.value = postList.toList();

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
        final createdTimestamp = doc['createdAt'] as Timestamp?;
        final createdDate = createdTimestamp?.toDate() ?? DateTime.now();
        final formattedCreated =
            DateFormat('yyyy-MM-dd HH:mm:ss', 'ko_KR').format(createdDate);

        final updatedTimestamp = doc.data().containsKey('updatedAt')
            ? doc['updatedAt'] as Timestamp?
            : null;
        final formattedUpdated = updatedTimestamp != null
            ? DateFormat('yyyy-MM-dd HH:mm:ss', 'ko_KR')
                .format(updatedTimestamp.toDate())
            : null;

        return {
          'id': doc.id,
          'title': doc['title'],
          'content': doc['content'],
          'category': doc['category'],
          'author': doc['author'],
          'createdAt': formattedCreated,
          'updatedAt': formattedUpdated,
          'status': doc['status'], // 기본값 설정
          // 'imageUrl': doc['imageUrl'] ?? '', // 이미지 URL이 없을 경우
        };
      }).toList();

      originalNotPostList.value = notPostList.toList();

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
        final createdTimestamp = doc['createdAt'] as Timestamp?;
        final createdDate = createdTimestamp?.toDate() ?? DateTime.now();
        final formattedCreated =
            DateFormat('yyyy-MM-dd HH:mm:ss', 'ko_KR').format(createdDate);

        final updatedTimestamp = doc.data().containsKey('updatedAt')
            ? doc['updatedAt'] as Timestamp?
            : null;
        final formattedUpdated = updatedTimestamp != null
            ? DateFormat('yyyy-MM-dd HH:mm:ss', 'ko_KR')
                .format(updatedTimestamp.toDate())
            : null;

        return {
          'id': doc.id,
          'title': doc['title'],
          'content': doc['content'],
          'category': doc['category'],
          'author': doc['author'],
          'createdAt': formattedCreated,
          'updatedAt': formattedUpdated,
          'status': doc['status'], // 기본값 설정
          // 'imageUrl': doc['imageUrl'] ?? '', // 이미지 URL이 없을 경우
        };
      }).toList();

      originalDonePostList.value = donePostList.toList();

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
}
