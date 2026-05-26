import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnm_fact/controller/home_controller.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_navigation.dart';
import 'package:tnm_fact/utils/app_text_style.dart';
import 'package:tnm_fact/view/page/detail_page.dart';
import 'package:tnm_fact/view/widget/app_side_banner_layout.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Map<String, dynamic>? _post;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  Future<void> _loadPost() async {
    final id = Get.parameters['id'];
    if (id == null || id.isEmpty) {
      setState(() => _loading = false);
      return;
    }

    final controller = Get.find<HomeController>();
    final cached = controller.findPostInCache(id);
    final post = cached ?? await controller.fetchPostById(id);

    if (!mounted) return;
    setState(() {
      _post = post;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // 웹: Safari 스와이프·브라우저 뒤로가기가 Navigator.pop을 막지 않도록 허용
      canPop: kIsWeb,
      onPopInvokedWithResult: kIsWeb
          ? null
          : (didPop, result) {
              if (!didPop) {
                navigateBackToHome(context: context);
              }
            },
      child: Scaffold(
      backgroundColor: AppColor.background,
      body: AppSideBannerLayout(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _post == null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '게시글을 찾을 수 없습니다.',
                          style: AppTextStyle.koRegular18(),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () =>
                              navigateBackToHome(context: context),
                          child: Text(
                            '목록으로 돌아가기',
                            style: AppTextStyle.koSemiBold14()
                                .copyWith(color: AppColor.primary),
                          ),
                        ),
                      ],
                    ),
                  )
                : DetailView(post: _post!),
      ),
    ),
    );
  }
}
