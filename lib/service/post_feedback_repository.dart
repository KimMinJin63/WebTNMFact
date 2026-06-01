import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tnm_fact/service/post_feedback_storage.dart';

/// Firestore에 저장되는 게시글 평가(도움/별로) + 게시글 문서 카운트 집계.
///
/// 저장 구조:
/// - `post/{postId}`: `helpfulCount`, `notHelpfulCount` (집계)
/// - `post/{postId}/feedback/{uid}`: { type, updatedAt } (개별 사용자 1표)
class PostFeedbackRepository {
  PostFeedbackRepository._();

  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  static DocumentReference<Map<String, dynamic>> _postRef(String postId) =>
      _db.collection('post').doc(postId);

  static DocumentReference<Map<String, dynamic>> _voteRef(
    String postId,
    String uid,
  ) =>
      _postRef(postId).collection('feedback').doc(uid);

  static Future<User> ensureUser() async {
    final current = _auth.currentUser;
    if (current != null) return current;
    final cred = await _auth.signInAnonymously();
    return cred.user!;
  }

  static Future<PostFeedbackType?> getMyVote(String postId) async {
    if (postId.isEmpty) return null;
    final user = await ensureUser();
    final snap = await _voteRef(postId, user.uid).get();
    if (!snap.exists) return null;
    final data = snap.data();
    return PostFeedbackType.fromStorage(data?['type']?.toString());
  }

  /// type이 null이면 투표 취소(삭제) 처리.
  static Future<void> setMyVote(String postId, PostFeedbackType? type) async {
    if (postId.isEmpty) return;
    final user = await ensureUser();

    await _db.runTransaction((tx) async {
      final postRef = _postRef(postId);
      final voteRef = _voteRef(postId, user.uid);

      final voteSnap = await tx.get(voteRef);
      final prev = voteSnap.exists
          ? PostFeedbackType.fromStorage(voteSnap.data()?['type']?.toString())
          : null;

      // 변화가 없으면 그대로 종료
      if (prev == type) return;

      final postSnap = await tx.get(postRef);
      final postData = postSnap.data() ?? {};
      int helpful = (postData['helpfulCount'] as num?)?.toInt() ?? 0;
      int notHelpful = (postData['notHelpfulCount'] as num?)?.toInt() ?? 0;

      void dec(PostFeedbackType t) {
        if (t == PostFeedbackType.helpful) {
          helpful = (helpful - 1).clamp(0, 1 << 30);
        } else {
          notHelpful = (notHelpful - 1).clamp(0, 1 << 30);
        }
      }

      void inc(PostFeedbackType t) {
        if (t == PostFeedbackType.helpful) {
          helpful += 1;
        } else {
          notHelpful += 1;
        }
      }

      if (prev != null) dec(prev);
      if (type != null) inc(type);

      tx.set(postRef, {
        'helpfulCount': helpful,
        'notHelpfulCount': notHelpful,
      }, SetOptions(merge: true));

      if (type == null) {
        tx.delete(voteRef);
      } else {
        tx.set(voteRef, {
          'type': type.storageValue,
          'uid': user.uid,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    });
  }
}

