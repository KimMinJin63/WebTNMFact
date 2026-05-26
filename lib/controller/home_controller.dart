import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:tnm_fact/controller/admin_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:tnm_fact/utils/app_routes.dart';
import 'package:tnm_fact/utils/app_title.dart';
import 'package:tnm_fact/utils/web_history.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  var isLoadingDetail = false.obs;
  final FocusNode searchFocusNode = FocusNode();
  RxList<Map<String, dynamic>> postList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> dailyPostList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> focusPostList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> insightPostList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> peoplePostList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> originalPostList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> originalDailyPostList =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> originalInsightPostList =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> originalFocusPostList =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> originalPeoplePostList =
      <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;
  RxBool isSearching = false.obs;
  RxBool isLoaded = false.obs;

  var currentPage = 'home'.obs; // ✅ 현재 페이지 상태
  Map<String, dynamic>? selectedPost;

  void selectTab(int index) {
    selectedIndex.value = index;
    clearFocus();
    // searchController.clear();
    // postList.assignAll(originalPostList);
    // dailyPostList.assignAll(originalDailyPostList);
    // insightPostList.assignAll(originalInsightPostList);

    final hasKeyword = searchController.text.trim().isNotEmpty;

    if (hasKeyword) {
      findPost();
      return;
    }

    switch (index) {
      case 0:
        loadAllPosts();
        break;
      case 1:
        loadDailyPosts();
        break;
      case 2:
        loadFocusPosts();
        break;
      case 3:
        loadInsightPosts();
        break;
      case 4:
        loadPeoplePosts();
        break;
      default:
        loadAllPosts();
    }
  }

  void clearFocus() {
    if (searchFocusNode.context == null) return;
    if (searchFocusNode.hasFocus) {
      searchFocusNode.unfocus();
    }
  }

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    loadAllPosts();
    loadDailyPosts();
    loadFocusPosts();
    loadInsightPosts();
    loadPeoplePosts();
    print('지금 탭의 갯수는?? : ${postList.length}');
    print('지금 탭의 갯수는?? : ${dailyPostList.length}');
    print('지금 탭의 갯수는?? : ${focusPostList.length}');
    print('지금 탭의 갯수는?? : ${insightPostList.length}');
    print('지금 탭의 갯수는?? : ${peoplePostList.length}');
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    scrollController.dispose();
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

  Map<String, dynamic>? findPostInCache(String id) {
    final allLists = [
      postList,
      dailyPostList,
      focusPostList,
      insightPostList,
      peoplePostList,
      originalPostList,
      originalDailyPostList,
      originalFocusPostList,
      originalInsightPostList,
      originalPeoplePostList,
    ];

    for (final list in allLists) {
      for (final post in list) {
        if (post['id']?.toString() == id) {
          return post;
        }
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchPostById(String id) async {
    final doc =
        await FirebaseFirestore.instance.collection('post').doc(id).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    if (data['status'] != '발행') return null;

    return _mapPostDocument(doc.id, data);
  }

  Map<String, dynamic> _mapPostDocument(
      String docId, Map<String, dynamic> data) {
    final ts = data['date'] as Timestamp;
    final created = ts.toDate();
    final display = DateFormat('yyyy-MM-dd HH:mm', 'ko_KR').format(created);
    final baseTitle = (data['title'] as String?) ??
        DateFormat('yy.MM.dd', 'ko_KR').format(created);
    final normalizedTitle =
        normalizeTitleForCategory(baseTitle, data['category']);

    return {
      'id': docId,
      'title': normalizedTitle,
      'final_article': data['final_article'] ?? data['content'] ?? '',
      'editor': data['editor'] ?? data['author'],
      'date': display,
      'viewpoint': data['viewpoint'] ?? data['viewPoint'] ?? 0,
      'status': data['status'],
      'category': data['category'],
      'sortAt': created.millisecondsSinceEpoch,
    };
  }

  Future<void> handlePostTap(Map<String, dynamic> post) async {
    if (isLoadingDetail.value) return;
    isLoadingDetail.value = true;

    try {
      final admin = Get.find<AdminController>();
      final user = FirebaseAuth.instance.currentUser;
      final postId = post['id']?.toString() ?? '';

      if (postId.isEmpty) return;

      if (postId.isNotEmpty) {
        await admin.incrementViewCount(postId);
      }

      if (user == null) {
        final cred = await FirebaseAuth.instance.signInAnonymously();
        final userId = cred.user!.uid;
        await admin.incrementViewCount(postId);
        logVisit(userId);
      } else {
        logVisit(user.uid);
      }

      final postPath = AppRoutes.postDetail(postId);
      final openedFromHome = kIsWeb && isBrowserOnHomePath();
      await Get.toNamed(postPath);
      if (kIsWeb && openedFromHome) {
        repairBrowserHistoryAfterPostOpen(postPath);
      }
    } finally {
      isLoadingDetail.value = false;
    }
  }

  Future findPost() async {
    final searchQuery = searchController.text.trim().toLowerCase();
    final tabIndex = selectedIndex.value;

    isSearching.value = searchQuery.isNotEmpty; // ✅ 검색 상태 반영

    switch (tabIndex) {
      case 0:
        print('전체기사 탭에서 검색 실행: $searchQuery');
        postList.value = originalPostList
            .where((p) =>
                p['title']?.toString().toLowerCase().contains(searchQuery) ??
                false)
            .toList();
        break;
      case 1:
        print('데일리팩트 탭에서 검색 실행: $searchQuery');
        dailyPostList.value = originalDailyPostList
            .where((p) =>
                p['title']?.toString().toLowerCase().contains(searchQuery) ??
                false)
            .toList();
        break;
      case 2:
        print('포커스팩트 탭에서 검색 실행: $searchQuery');
        focusPostList.value = originalFocusPostList
            .where((p) =>
                p['title']?.toString().toLowerCase().contains(searchQuery) ??
                false)
            .toList();
        break;
      case 3:
        print('인사이트팩트 탭에서 검색 실행: $searchQuery');
        insightPostList.value = originalInsightPostList
            .where((p) =>
                p['title']?.toString().toLowerCase().contains(searchQuery) ??
                false)
            .toList();
        break;
      case 4:
        print('피플&뷰 탭에서 검색 실행: $searchQuery');
        peoplePostList.value = originalPeoplePostList
            .where((p) =>
                p['title']?.toString().toLowerCase().contains(searchQuery) ??
                false)
            .toList();
        break;
    }
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
    isLoading.value = true;
    FirebaseFirestore.instance
        .collection('post')
        .where('status', isEqualTo: '발행')
        .orderBy('date', descending: true)
        .snapshots() // ✅ get() 대신 snapshots()
        .listen((snapshot) {
      postList.value = snapshot.docs.map((doc) {
        final data = doc.data();
        final ts = data['date'] as Timestamp;
        final created = ts.toDate();
        final display = DateFormat('yyyy-MM-dd HH:mm', 'ko_KR').format(created);
        final baseTitle = (data['title'] as String?) ??
            DateFormat('yy.MM.dd', 'ko_KR').format(created);
        // print('🔥🔥🔥🔥🔥🔥🔥🔥🔥기본 제목은 : $baseTitle');
        final normalizedTitle =
            normalizeTitleForCategory(baseTitle, data['category']);

        return {
          'id': doc.id,
          'title': normalizedTitle,
          'final_article': data['final_article'] ?? data['content'] ?? '',
          'editor': data['editor'] ?? data['author'],
          'date': display,
          'viewpoint': data['viewpoint'] ?? data['viewPoint'] ?? 0,
          'status': data['status'],
          'category': data['category'],
          'sortAt': created.millisecondsSinceEpoch, // ✅ 추가!
        };
      }).toList();
      originalPostList.value = postList.toList();
      if (isLoading.value) isLoading.value = false;

      print('🔥 실시간 업데이트됨! 현재 총 게시글 수: ${postList.length}');
      isLoading.value = false;
    });
  }

  loadDailyPosts() {
    FirebaseFirestore.instance
        .collection('post')
        .where('category', isEqualTo: '데일리 팩트')
        .where('status', isEqualTo: '발행')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      dailyPostList.value = snapshot.docs.map((doc) {
        final data = doc.data();
        final ts = data['date'] as Timestamp; // ✅ Timestamp 가정
        final created = ts.toDate();
        final display = DateFormat('yyyy-MM-dd HH:mm', 'ko_KR').format(created);
        final baseTitle = (data['title'] as String?) ??
            DateFormat('yy.MM.dd', 'ko_KR').format(created);
        final normalizedTitle =
            normalizeTitleForCategory(baseTitle, data['category']);
        return {
          'id': doc.id,
          'title': normalizedTitle,
          'final_article': data['final_article'] ?? data['content'] ?? '',
          'editor': data['editor'] ?? data['author'],
          'date': display,
          'viewpoint': data['viewpoint'] ?? data['viewPoint'] ?? 0,
          'status': data['status'],
          'category': data['category'],
        };
      }).toList();

      originalDailyPostList.value = dailyPostList.toList();

      print('🔥 데일리 팩트 실시간 반영: ${dailyPostList.length}');
    });
  }

  loadInsightPosts() {
    FirebaseFirestore.instance
        .collection('post')
        .where('category', isEqualTo: '인사이트 팩트')
        .where('status', isEqualTo: '발행')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      insightPostList.value = snapshot.docs.map((doc) {
        final data = doc.data();
        final ts = data['date'] as Timestamp; // ✅ Timestamp 가정
        final created = ts.toDate();
        final display = DateFormat('yyyy-MM-dd HH:mm', 'ko_KR').format(created);
        final baseTitle = (data['title'] as String?) ??
            DateFormat('yy.MM.dd', 'ko_KR').format(created);
        final normalizedTitle =
            normalizeTitleForCategory(baseTitle, data['category']);
        return {
          'id': doc.id,
          'title': normalizedTitle,
          'final_article': data['final_article'] ?? data['content'] ?? '',
          'editor': data['editor'] ?? data['author'],
          'date': display,
          'viewpoint': data['viewpoint'] ?? data['viewPoint'] ?? 0,
          'status': data['status'],
          'category': data['category'],
        };
      }).toList();
      originalInsightPostList.value = insightPostList.toList();

      print('🔥 인사이트 팩트 실시간 반영: ${insightPostList.length}');
    });
  }

  loadFocusPosts() {
    FirebaseFirestore.instance
        .collection('post')
        .where('category', isEqualTo: '포커스 팩트')
        .where('status', isEqualTo: '발행')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      focusPostList.value = snapshot.docs.map((doc) {
        final data = doc.data();
        final ts = data['date'] as Timestamp;
        final created = ts.toDate();
        final display = DateFormat('yyyy-MM-dd HH:mm', 'ko_KR').format(created);
        final baseTitle = (data['title'] as String?) ??
            DateFormat('yy.MM.dd', 'ko_KR').format(created);
        final normalizedTitle =
            normalizeTitleForCategory(baseTitle, data['category']);
        return {
          'id': doc.id,
          'title': normalizedTitle,
          'final_article': data['final_article'] ?? data['content'] ?? '',
          'editor': data['editor'] ?? data['author'],
          'date': display,
          'viewpoint': data['viewpoint'] ?? data['viewPoint'] ?? 0,
          'status': data['status'],
          'category': data['category'],
        };
      }).toList();

      originalFocusPostList.value = focusPostList.toList();
      print('🔥 포커스 팩트 실시간 반영: ${focusPostList.length}');
    });
  }

  loadPeoplePosts() {
    FirebaseFirestore.instance
        .collection('post')
        .where('category', isEqualTo: '피플&뷰')
        .where('status', isEqualTo: '발행')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      peoplePostList.value = snapshot.docs.map((doc) {
        final data = doc.data();
        final ts = data['date'] as Timestamp;
        final created = ts.toDate();
        final display = DateFormat('yyyy-MM-dd HH:mm', 'ko_KR').format(created);
        final baseTitle = (data['title'] as String?) ??
            DateFormat('yy.MM.dd', 'ko_KR').format(created);
        final normalizedTitle =
            normalizeTitleForCategory(baseTitle, data['category']);
        return {
          'id': doc.id,
          'title': normalizedTitle,
          'final_article': data['final_article'] ?? data['content'] ?? '',
          'editor': data['editor'] ?? data['author'],
          'date': display,
          'viewpoint': data['viewpoint'] ?? data['viewPoint'] ?? 0,
          'status': data['status'],
          'category': data['category'],
        };
      }).toList();

      originalPeoplePostList.value = peoplePostList.toList();
      print('🔥 피플&뷰 실시간 반영: ${peoplePostList.length}');
    });
  }
}
