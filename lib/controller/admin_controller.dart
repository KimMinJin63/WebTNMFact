import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tnm_fact/utils/app_title.dart';

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
  RxBool isLoaded = false.obs;
  RxInt menuSelectedIndex = 0.obs;
  // RxInt menuSelectedIndex = 0.obs;
  Rx<Map<String, dynamic>?> currentPost = Rx<Map<String, dynamic>?>(null);
  final box = GetStorage();
  var isEditing = false.obs; // 🔹 편집 모드 여부
  var isCreate = false.obs;
  final FocusNode searchFocusNode = FocusNode();
  RxInt? originTabIndex = RxInt(0);
  var totalVisits = 0.obs;

  void openEditPage(Map<String, dynamic> post) {
    currentPost.value = post;
    print('admin 컨트롤러에서는 잘 받아오나?? : ${post['title']}');
    print('admin 컨트롤러에서는 잘 받아오나?? : ${post['content']}');
    print('admin 컨트롤러에서는 잘 받아오나?? : ${post['category']}');
    print('admin 컨트롤러에서는 잘 받아오나?? : ${post['status']}');
  }

  void clearFocus() {
    if (searchFocusNode.hasFocus) {
      searchFocusNode.unfocus();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllPostCounts();
    fetchAllPosts();
    fetchNotPosts();
    loadTotalVisits();
    fetchDonePosts();
    bindPosts();
    topPostsLast7DaysByView(5);
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
    // searchController.clear();
    // postList.assignAll(originalPostList);
    // donePostList.assignAll(originalDonePostList);
    // notPostList.assignAll(originalNotPostList);

    final hasKeyword = searchController.text.trim().isNotEmpty;

    if (hasKeyword) {
      findPost();
    } else {
      if (index == 0) {
        fetchAllPosts();
      } else if (index == 1) {
        fetchDonePosts();
      } else {
        fetchNotPosts();
      }
    }
  }

  // DateTime? _parseAnyDate(dynamic v) {
  //   if (v == null) return null;
  //   if (v is Timestamp) return v.toDate();
  //   if (v is DateTime) return v;
  //   if (v is String && v.isNotEmpty) {
  //     try {
  //       return DateFormat('yyyy-MM-dd HH:mm:ss', 'ko_KR').parse(v);
  //     } catch (_) {}
  //     try {
  //       return DateFormat('yyyy-MM-dd HH:mm', 'ko_KR').parse(v);
  //     } catch (_) {}
  //     try {
  //       return DateTime.parse(v.replaceFirst(' ', 'T'));
  //     } catch (_) {}
  //   }
  //   return null;
  // }

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
      await firestore.collection('post').doc(docId).delete();

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
          .collection('post')
          .orderBy('date', descending: true)
          .get();

      postList.value = snapshot.docs.map((doc) {
        final data = doc.data();
        final ts = data['date'] as Timestamp;
        final created = ts.toDate();
        final display = DateFormat('yyyy-MM-dd HH:mm', 'ko_KR').format(created);
        final baseTitle = (data['title'] as String?) ??
            DateFormat('yy.MM.dd', 'ko_KR').format(created);
        // print('🔥🔥🔥🔥🔥🔥🔥🔥🔥기본 제목은 : $baseTitle');
        // final normalizedTitle =
        //     normalizeTitleForCategory(baseTitle, data['category']);

        return {
          'id': doc.id,
          'title': baseTitle,
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
      print('!!!!!!!!!!!1총 게시글 수는 : ${postList.length}');
    } catch (e) {
      print('🔥 fetchAllPosts 게시글 불러오기 실패: $e');
    }
  }

  Future<void> fetchDonePosts() async {
    try {
      final snapshot = await firestore
          .collection('post')
          .where('status', isEqualTo: '발행')
          .orderBy('date', descending: true) // ✅ 변경
          .get();

      donePostList.value = snapshot.docs.map((doc) {
        final data = doc.data();
        final ts = data['date'] as Timestamp; // ✅ Timestamp 가정
        final created = ts.toDate();
        final display = DateFormat('yyyy-MM-dd HH:mm', 'ko_KR').format(created);
        final baseTitle = (data['title'] as String?) ??
            DateFormat('yy.MM.dd', 'ko_KR').format(created);
        // final normalizedTitle =
        //     normalizeTitleForCategory(baseTitle, data['category']);
        return {
          'id': doc.id,
          'title': baseTitle,
          'final_article': data['final_article'] ?? data['content'] ?? '',
          'editor': data['editor'] ?? data['author'],
          'date': display,
          'viewpoint': data['viewpoint'] ?? data['viewPoint'] ?? 0,
          'status': data['status'],
          'category': data['category'],
        };
      }).toList();

      originalDonePostList.value = donePostList.toList();
      print('!!!!!!!!!!!1발행된 총 게시글 수는 : ${originalDonePostList.length}');
    } catch (e) {
      print('🔥 fetchDonePosts 게시글 불러오기 실패: $e');
    }
  }

  Future<void> fetchNotPosts() async {
    try {
      final snapshot = await firestore
          .collection('post') // ✅ posts → post
          .where('status', isEqualTo: '미발행')
          .orderBy('date', descending: true) // ✅ 변경
          .get();

      notPostList.value = snapshot.docs.map((doc) {
        final data = doc.data();
        final ts = data['date'] as Timestamp; // ✅ Timestamp 가정
        final created = ts.toDate();
        // String display =
        //     '';
        final display = DateFormat('yyyy-MM-dd HH:mm', 'ko_KR').format(created);
        final baseTitle = (data['title'] as String?) ??
            DateFormat('yy.MM.dd', 'ko_KR').format(created);
        // final normalizedTitle =
        //     normalizeTitleForCategory(baseTitle, data['category']);
        return {
          'id': doc.id,
          'title': baseTitle,
          'final_article': data['final_article'] ?? data['content'] ?? '',
          'editor': data['editor'] ?? data['author'],
          'date': display,
          'viewpoint': data['viewpoint'] ?? data['viewPoint'] ?? 0,
          'status': data['status'],
          'category': data['category'],
        };
      }).toList();

      originalNotPostList.value = notPostList.toList();
    } catch (e) {
      print('🔥 미발행 게시글 불러오기 실패: $e');
    }
  }

//   Future<void> fetchNotPosts() async {
//   try {
//     final snapshot = await firestore
//         .collection('post')
//         .where('status', isEqualTo: '미발행')
//         // ⚠️ 주의: Firestore에서 null/문자열 포함된 필드는 orderBy로 정렬이 안 될 수 있음
//         .get();

//     notPostList.value = snapshot.docs.map((doc) {
//       final data = doc.data();
//       final dynamic ts = data['date']; // ✅ 타입을 dynamic으로 둡니다

//       String display = ''; // 화면에 보여줄 날짜 문자열

//       if (ts is Timestamp) {
//         // ✅ Timestamp인 경우
//         display = DateFormat('yyyy-MM-dd HH:mm', 'ko_KR').format(ts.toDate());
//       } else if (ts is String) {
//         // ✅ "작성 중" 같은 문자열인 경우
//         display = ts;
//       } else {
//         display = '';
//       }

//       final baseTitle = (data['title'] as String?) ?? '';
//       final normalizedTitle =
//           normalizeTitleForCategory(baseTitle, data['category']);

//       return {
//         'id': doc.id,
//         'title': normalizedTitle,
//         'final_article': data['final_article'] ?? data['content'] ?? '',
//         'editor': data['editor'] ?? data['author'],
//         'date': display,
//         'viewpoint': data['viewpoint'] ?? data['viewPoint'] ?? 0,
//         'status': data['status'],
//         'category': data['category'],
//       };
//     }).toList();

//     originalNotPostList.value = notPostList.toList();
//   } catch (e) {
//     print('🔥 미발행 게시글 불러오기 실패: $e');
//   }
// }

  Future<void> fetchAllPostCounts() async {
    try {
      final totalSnapshot = await firestore.collection('post').get();
      print('fetchAllPostCounts 총 게시글 수: ${totalSnapshot.size}');
      totalCount.value = totalSnapshot.size;

      final publishedSnapshot = await firestore
          .collection('post')
          .where('status', isEqualTo: '발행')
          .get();
      publishedCount.value = publishedSnapshot.size;
      print('발행된 게시글 수: ${publishedCount.value}');

      final pendingSnapshot = await firestore
          .collection('post')
          .where('status', isEqualTo: '미발행')
          .get();
      pendingCount.value = pendingSnapshot.size;
      print('미발행된 게시글 수: ${pendingCount.value}');
    } catch (e) {
      print('🔥 게시글 카운트 불러오기 실패: $e');
    }
  }

  loadTotalVisits() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('visits').get();
    totalVisits.value = snapshot.docs.length;
    print('$totalVisits 수 입니다.!!!!');
  }

  Future<void> incrementViewCount(String postId) async {
    try {
      final postRef = FirebaseFirestore.instance.collection('post').doc(postId);
      await postRef.update({'viewpoint': FieldValue.increment(1)});
      final snap = await postRef.get();
      final now = (snap.data()?['viewpoint'] ?? 0);
      print('viewpoint now for $postId: $now');
    } catch (e) {
      debugPrint('increment 실패: $e');
    }
  }

  List<Map<String, dynamic>> topPostsLast7DaysByView(int n) {
    final now = DateTime.now();
    final startOfMonth =
        DateTime(now.year, now.month, 1).millisecondsSinceEpoch;

    int toInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    final items = postList
        .where((p) => p['status'] == '발행')
        .where((p) => (p['sortAt'] ?? 0) >= startOfMonth) // ✅ 7일 필터는 sortAt 기준
        .toList()
      ..sort((a, b) {
        final av = toInt(a['viewpoint']);
        final bv = toInt(b['viewpoint']);
        return bv.compareTo(av); // ✅ 조회수 내림차순
      });

    return items.take(n).toList();
  }

  void bindPosts() {
    firestore
        .collection('post')
        .where('status', isEqualTo: '발행')
        .orderBy('date', descending: true) // ✅ date → date(Timestamp)
        .snapshots()
        .listen((qs) {
      final mapped = qs.docs.map((doc) {
        final data = doc.data();

        // ✅ date는 Timestamp로 가정(레거시 대비 안전가드 포함)
        final Timestamp? ts =
            data['date'] is Timestamp ? data['date'] as Timestamp : null;
        final created = ts?.toDate() ??
            DateTime.fromMillisecondsSinceEpoch(0); // (레거시 fallback)

        final baseTitle = (data['title'] as String?) ??
            DateFormat('yy.MM.dd', 'ko_KR').format(created);
        // final normalizedTitle =
        //     normalizeTitleForCategory(baseTitle, data['category']);
        final display = DateFormat('yyyy-MM-dd HH:mm', 'ko_KR').format(created);

        return {
          'id': doc.id,
          'title': baseTitle,
          'final_article': data['final_article'],
          'category': data['category'],
          'author': data['editor'] ?? data['author'],
          'status': data['status'],
          'viewpoint': data['viewpoint'] ?? 0,
          'date': display, // UI용 문자열
          'sortAt': created.millisecondsSinceEpoch, // ✅ 정렬/필터용
        };
      }).toList();

      // 이미 서버에서 date desc로 받지만, 혹시 몰라 로컬도 보정 가능
      mapped.sort((a, b) => (b['sortAt'] as int).compareTo(a['sortAt'] as int));

      postList.value = mapped;
      isLoaded.value = true;
      originalPostList.value = mapped.toList();
      print('실시간 바인딩된 게시물 수: ${postList.length}');
    });
  }
}
