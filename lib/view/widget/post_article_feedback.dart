import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnm_fact/service/post_feedback_repository.dart';
import 'package:tnm_fact/service/post_feedback_storage.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class PostArticleFeedback extends StatefulWidget {
  const PostArticleFeedback({super.key, required this.postId});

  final String postId;

  @override
  State<PostArticleFeedback> createState() => _PostArticleFeedbackState();
}

class _PostArticleFeedbackState extends State<PostArticleFeedback> {
  PostFeedbackType? _selected;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // 로컬 캐시로 즉시 반영 → 이후 Firestore 값으로 동기화
    _selected = PostFeedbackStorage.read(widget.postId);
    _syncFromServer();
  }

  Future<void> _syncFromServer() async {
    if (widget.postId.isEmpty) return;
    try {
      final server = await PostFeedbackRepository.getMyVote(widget.postId);
      if (!mounted) return;
      setState(() => _selected = server);
      if (server == null) {
        await PostFeedbackStorage.clear(widget.postId);
      } else {
        await PostFeedbackStorage.write(widget.postId, server);
      }
    } catch (_) {
      // 네트워크/권한 이슈가 있으면 로컬 상태만 유지
    }
  }

  Future<void> _onSelect(PostFeedbackType type) async {
    if (widget.postId.isEmpty) return;

    final next = _selected == type ? null : type;
    setState(() => _selected = next);

    setState(() => _loading = true);
    try {
      // Firestore(집계 포함) 업데이트
      await PostFeedbackRepository.setMyVote(widget.postId, next);
      // 로컬 캐시 업데이트(초기 렌더링/오프라인 대비)
      if (next == null) {
        await PostFeedbackStorage.clear(widget.postId);
      } else {
        await PostFeedbackStorage.write(widget.postId, next);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.postId.isEmpty) return const SizedBox.shrink();

    final postDocStream = FirebaseFirestore.instance
        .collection('post')
        .doc(widget.postId)
        .snapshots();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: AppColor.border, height: 1, thickness: 1),
        SizedBox(height: 28.h),
        Text(
          '게시글에 도움이 되었나요?',
          style: AppTextStyle.koSemiBold16(),
        ),
        SizedBox(height: 14.h),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: postDocStream,
          builder: (context, snapshot) {
            final data = snapshot.data?.data() ?? {};
            final helpful = (data['helpfulCount'] as num?)?.toInt() ?? 0;
            final notHelpful = (data['notHelpfulCount'] as num?)?.toInt() ?? 0;

            return Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [
                _FeedbackChip(
                  label: '도움이 되었어요',
                  count: helpful,
                  icon: Icons.thumb_up_outlined,
                  selected: _selected == PostFeedbackType.helpful,
                  selectedColor: AppColor.primary,
                  enabled: !_loading,
                  onTap: () => _onSelect(PostFeedbackType.helpful),
                ),
                _FeedbackChip(
                  label: '별로였어요',
                  count: notHelpful,
                  icon: Icons.thumb_down_outlined,
                  selected: _selected == PostFeedbackType.notHelpful,
                  selectedColor: AppColor.grey,
                  enabled: !_loading,
                  onTap: () => _onSelect(PostFeedbackType.notHelpful),
                ),
              ],
            );
          },
        ),
        if (_selected != null) ...[
          SizedBox(height: 12.h),
          Text(
            '의견을 남겨 주셔서 감사합니다.',
            style: AppTextStyle.koRegular14()
                .copyWith(color: AppColor.grey),
          ),
        ],
        SizedBox(height: 32.h),
      ],
    );
  }
}

class _FeedbackChip extends StatelessWidget {
  const _FeedbackChip({
    required this.label,
    required this.count,
    required this.icon,
    required this.selected,
    required this.selectedColor,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final int count;
  final IconData icon;
  final bool selected;
  final Color selectedColor;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        selected ? selectedColor : AppColor.border;
    final background =
        selected ? selectedColor.withValues(alpha: 0.08) : AppColor.white;
    final textColor = selected ? selectedColor : AppColor.black;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: textColor),
                SizedBox(width: 6.w),
                Text(
                  '$label  $count',
                  style: AppTextStyle.koSemiBold14().copyWith(color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
