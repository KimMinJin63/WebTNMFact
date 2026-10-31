import 'package:flutter/material.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

/// 푸터 하단 링크 (이용약관, 개인정보 처리방침 등)
class FooterLink {
  const FooterLink({required this.label, this.onTap});
  final String label;
  final VoidCallback? onTap;
}

class AppFooter extends StatelessWidget {
  const AppFooter({
    super.key,
    required this.logo,
    required this.infoLines,
    required this.links,
    required this.copyright,
  });

  final String logo;

  /// 발행 정보 줄 목록 (한 줄씩 표시)
  final List<String> infoLines;

  /// `[이용약관] | [개인정보 처리방침] | ...` 형태로 표시될 링크 목록
  final List<FooterLink> links;
  final String copyright;

  @override
  Widget build(BuildContext context) {
    final infoStyle = AppTextStyle.koRegular14().copyWith(color: AppColor.grey);

    return Container(
      width: double.infinity,
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1260),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 로고 ---
                Text(logo, style: AppTextStyle.koBold18()),
                const SizedBox(height: 8),

                // --- 발행 정보 ---
                for (int i = 0; i < infoLines.length; i++) ...[
                  if (i > 0) const SizedBox(height: 4),
                  Text(infoLines[i], style: infoStyle),
                ],
                const SizedBox(height: 12),

                // --- 약관/정책 링크 ---
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 4,
                  children: [
                    for (int i = 0; i < links.length; i++) ...[
                      if (i > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text('|', style: infoStyle),
                        ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: links[i].onTap,
                        child: Text(
                          links[i].label,
                          style: AppTextStyle.koRegular14()
                              .copyWith(color: AppColor.black),
                        ),
                      ),
                    ],
                  ],
                ),

                // --- 구분선 ---
                const SizedBox(height: 12),
                Divider(height: 32, color: AppColor.lightGrey),

                // --- 저작권 문구 ---
                Text(
                  copyright,
                  style:
                      AppTextStyle.koRegular12().copyWith(color: AppColor.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
