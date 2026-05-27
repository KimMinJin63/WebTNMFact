import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  void initState() {
    super.initState();
    _selected = PostFeedbackStorage.read(widget.postId);
  }

  Future<void> _onSelect(PostFeedbackType type) async {
    if (widget.postId.isEmpty) return;

    final next = _selected == type ? null : type;
    setState(() => _selected = next);

    if (next == null) {
      await PostFeedbackStorage.clear(widget.postId);
    } else {
      await PostFeedbackStorage.write(widget.postId, next);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.postId.isEmpty) return const SizedBox.shrink();

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
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            _FeedbackChip(
              label: '도움이 되었어요',
              icon: Icons.thumb_up_outlined,
              selected: _selected == PostFeedbackType.helpful,
              selectedColor: AppColor.primary,
              onTap: () => _onSelect(PostFeedbackType.helpful),
            ),
            _FeedbackChip(
              label: '별로였어요',
              icon: Icons.thumb_down_outlined,
              selected: _selected == PostFeedbackType.notHelpful,
              selectedColor: AppColor.grey,
              onTap: () => _onSelect(PostFeedbackType.notHelpful),
            ),
          ],
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
    required this.icon,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final Color selectedColor;
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
        onTap: onTap,
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
                  label,
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
