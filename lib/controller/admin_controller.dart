import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
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
  // RxInt menuSelectedIndex = 0.obs;
  Rx<Map<String, dynamic>?> currentPost = Rx<Map<String, dynamic>?>(null);
  final box = GetStorage();
  var isEditing = false.obs; // 🔹 편집 모드 여부
  var isCreate = false.obs;

  void openEditPage(Map<String, dynamic> post) {
    // final post = Get.arguments;

    // final post = box.read('post');
    currentPost.value = post;
    print('admin 컨트롤러에서는 잘 받아오나?? : ${post['title']}');
    print('admin 컨트롤러에서는 잘 받아오나?? : ${post['content']}');
    print('admin 컨트롤러에서는 잘 받아오나?? : ${post['category']}');
    print('admin 컨트롤러에서는 잘 받아오나?? : ${post['status']}');
  }

//   @override
// void onInit() {
//   super.onInit();
//   initAuth().then((_) {
//     fetchAllPostCounts();
//     fetchAllPosts();
//     fetchNotPosts();
//     fetchDonePosts();
//   });
// }

  @override
  void onInit() {
    super.onInit();
    fetchAllPostCounts();
    fetchAllPosts();
    fetchNotPosts();
    fetchDonePosts();
    _bindPosts();
    print('컨트롤러 총 게시물 수는 : ${postList.length}');
    // print('')
  }

  fetchDailyVisits() async {
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
          'createdAt': formattedCreated, // 표시용 문자열
          'updatedAt': formattedUpdated, // 표시용 문자열
          'createdAtTs': createdTimestamp, // ✅ 계산/필터용 Timestamp
          'updatedAtTs': updatedTimestamp, // ✅ 계산/필터용 Timestamp
          'status': doc['status'],
          'viewPoint': doc['viewPoint'] ?? 0,
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
          'createdAt': formattedCreated, // 표시용 문자열
          'updatedAt': formattedUpdated, // 표시용 문자열
          'createdAtTs': createdTimestamp, // ✅ 계산/필터용 Timestamp
          'updatedAtTs': updatedTimestamp, // ✅ 계산/필터용 Timestamp
          'status': doc['status'],
          'viewPoint': doc['viewPoint'] ?? 0,
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
          'createdAt': formattedCreated, // 표시용 문자열
          'updatedAt': formattedUpdated, // 표시용 문자열
          'createdAtTs': createdTimestamp, // ✅ 계산/필터용 Timestamp
          'updatedAtTs': updatedTimestamp, // ✅ 계산/필터용 Timestamp
          'status': doc['status'],
          'viewPoint': doc['viewPoint'] ?? 0,
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

  Future<int> fetchTotalVisits() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('visits').get();
    return snapshot.docs.length; // ✅ 문서 개수 = 총 방문자 수
  }

  Future<void> incrementViewCount(String postId) async {
    try {
      final postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);
      await postRef.update({'viewPoint': FieldValue.increment(1)});
      final snap = await postRef.get();
      final now = (snap.data()?['viewPoint'] ?? 0);
      print('viewPoint now for $postId: $now');
    } catch (e) {
      debugPrint('increment 실패: $e');
    }
  }

  List<Map<String, dynamic>> topPostsLast7Days(int n) {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

    DateTime? toDate(dynamic v) {
      if (v == null) return null;
      if (v is Timestamp) return v.toDate();
      if (v is DateTime) return v;
      if (v is String && v.isNotEmpty) {
        try {
          return DateTime.parse(v.replaceFirst(' ', 'T'));
        } catch (_) {}
      }
      return null;
    }

    // 스냅샷 고정 후 필터 + 정렬
    final items = postList.toList().where((p) {
      final u = toDate(p['updatedAtTs']);
      final c = toDate(p['createdAtTs']);
      final d = u ?? c;
      return d != null && d.isAfter(sevenDaysAgo);
    }).toList()
      ..sort((a, b) => ((b['viewPoint'] ?? 0) as int)
          .compareTo((a['viewPoint'] ?? 0) as int));

    return items.take(n).toList();
  }


  void _bindPosts() {
  firestore
      .collection('posts')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .listen((qs) {
    final mapped = qs.docs.map((doc) {
      final createdTs = doc['createdAt'] as Timestamp?;
      final updatedTs = doc.data().containsKey('updatedAt')
          ? doc['updatedAt'] as Timestamp?
          : null;
      return {
        'id': doc.id,
        'title': doc['title'],
        'content': doc['content'],
        'category': doc['category'],
        'author': doc['author'],
        'createdAt': DateFormat('yyyy-MM-dd HH:mm:ss','ko_KR')
            .format((createdTs?.toDate() ?? DateTime.now())),
        'updatedAt': updatedTs != null
            ? DateFormat('yyyy-MM-dd HH:mm:ss','ko_KR').format(updatedTs.toDate())
            : null,
        'createdAtTs': createdTs,
        'updatedAtTs': updatedTs,
        'status': doc['status'],
        'viewPoint': doc['viewPoint'] ?? 0,
      };
    }).toList();

    postList.value = mapped;                // ✅ RxList 갱신 → Obx 리빌드
    originalPostList.value = mapped.toList();
  });
}

  // Future fetchViewPoint(String postId) async {
  //   final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
  //   final snap = await postRef.get();
  //   final viewPoint = snap.data()?['viewPoint'] ?? 0;
  //   return viewPoint;
  // }
}
