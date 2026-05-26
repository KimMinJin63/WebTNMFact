import 'package:flutter/material.dart';

/// 메인 콘텐츠([contentMaxWidth]) 양옆 여백에 배너가 들어갈 만큼 넓을 때만 좌·우 배너 표시.
class AppSideBannerLayout extends StatelessWidget {
  const AppSideBannerLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  static const String bannerAsset = 'assets/images/banner.png';

  /// assets/images/banner.png 실제 픽셀 (세로형 스카이스크래퍼)
  static const double bannerImageWidth = 688;
  static const double bannerImageHeight = 1184;

  static const double bannerAspectRatio =
      bannerImageWidth / bannerImageHeight;

  /// 홈·상세 본문과 동일한 최대 너비
  static const double contentMaxWidth = 1260;

  /// 배너를 표시하기 위한 최소 폭
  static const double minBannerWidth = 120;

  /// 본문과 배너 사이 최소 여백
  static const double minSideGap = 12;

  /// 화면에 그릴 때 원본 대비 축소 비율
  static const double displayScale = 0.5;

  static double _sideSpace(double viewportWidth) =>
      (viewportWidth - contentMaxWidth) / 2;

  /// 화면 여백을 활용한 배너 폭 (원본보다 크게 늘리지 않음, [displayScale] 적용)
  static double bannerWidthForViewport(double viewportWidth) {
    final available = _sideSpace(viewportWidth) - minSideGap;
    if (available < minBannerWidth) return 0;
    final fitted = available.clamp(minBannerWidth, bannerImageWidth);
    return fitted * displayScale;
  }

  static double bannerHeightForWidth(double bannerWidth) =>
      bannerWidth / bannerAspectRatio;

  static bool shouldShowSideBanners(double viewportWidth) =>
      bannerWidthForViewport(viewportWidth) > 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final bannerWidth = bannerWidthForViewport(width);

        if (!shouldShowSideBanners(width)) {
          return child;
        }

        final banner = _SideBanner(width: bannerWidth);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            banner,
            Expanded(child: child),
            banner,
          ],
        );
      },
    );
  }
}

class _SideBanner extends StatelessWidget {
  const _SideBanner({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final height = AppSideBannerLayout.bannerHeightForWidth(width);

    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(top: 48, left: 4, right: 4),
        child: SizedBox(
          width: width,
          height: height,
          child: Image.asset(
            AppSideBannerLayout.bannerAsset,
            width: width,
            height: height,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
          ),
        ),
      ),
    );
  }
}
