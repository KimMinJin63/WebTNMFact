import 'package:get_storage/get_storage.dart';

enum PostFeedbackType {
  helpful('helpful'),
  notHelpful('not_helpful');

  const PostFeedbackType(this.storageValue);
  final String storageValue;

  static PostFeedbackType? fromStorage(String? value) {
    if (value == null) return null;
    for (final type in PostFeedbackType.values) {
      if (type.storageValue == value) return type;
    }
    return null;
  }
}

/// 게시글 도움됨/별로 평가 — 기기 로컬(GetStorage)에만 저장.
class PostFeedbackStorage {
  PostFeedbackStorage._();

  static const String _storageKey = 'post_article_feedback';
  static final GetStorage _box = GetStorage();

  static PostFeedbackType? read(String postId) {
    if (postId.isEmpty) return null;
    final raw = _box.read(_storageKey);
    if (raw is! Map) return null;
    return PostFeedbackType.fromStorage(raw[postId]?.toString());
  }

  static Future<void> write(String postId, PostFeedbackType type) async {
    if (postId.isEmpty) return;
    final map = Map<String, dynamic>.from(
      (_box.read(_storageKey) as Map?) ?? {},
    );
    map[postId] = type.storageValue;
    await _box.write(_storageKey, map);
  }

  static Future<void> clear(String postId) async {
    if (postId.isEmpty) return;
    final map = Map<String, dynamic>.from(
      (_box.read(_storageKey) as Map?) ?? {},
    );
    map.remove(postId);
    await _box.write(_storageKey, map);
  }
}
