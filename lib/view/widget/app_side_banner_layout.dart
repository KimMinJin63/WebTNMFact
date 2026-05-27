import 'package:flutter/material.dart';
import 'package:tnm_fact/view/widget/side_banner_ad.dart';

/// 메인 콘텐츠([contentMaxWidth]) 양옆 여백에 배너가 들어갈 만큼 넓을 때만 좌·우 배너 표시.
class AppSideBannerLayout extends StatelessWidget {
  const AppSideBannerLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  static const double bannerImageWidth = SideBannerAd.designWidth;
  static const double bannerImageHeight = SideBannerAd.designHeight;

  static const double bannerAspectRatio =
      bannerImageWidth / bannerImageHeight;

  /// 홈·상세 본문과 동일한 최대 너비
  static const double contentMaxWidth = 1260;

  /// 배너를 표시하기 위한 최소 폭
  static const double minBannerWidth = 200;

  static const double targetBannerWidth = SideBannerAd.designWidth;

  /// 본문과 배너 사이 최소 여백
  static const double minSideGap = 12;

  static const double bannerOuterPadding = 12;

  static double _sideSpace(double viewportWidth) =>
      (viewportWidth - contentMaxWidth) / 2;

  static double sideContainerWidthForViewport(double viewportWidth) {
    final available = _sideSpace(viewportWidth) - minSideGap;
    if (available < minBannerWidth) return 0;
    return available;
  }

  static bool shouldShowSideBanners(double viewportWidth) =>
      sideContainerWidthForViewport(viewportWidth) > 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.maxWidth;
        final sideWidth = sideContainerWidthForViewport(viewportWidth);

        if (!shouldShowSideBanners(viewportWidth)) {
          return child;
        }

        final banner = _SideBanner(sideWidth: sideWidth);
        final rowHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height;

        return SizedBox(
          height: rowHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              banner,
              Expanded(child: child),
              banner,
            ],
          ),
        );
      },
    );
  }
}

class _SideBanner extends StatelessWidget {
  const _SideBanner({required this.sideWidth});

  final double sideWidth;

  @override
  Widget build(BuildContext context) {
    final innerMaxWidth =
        (sideWidth - AppSideBannerLayout.bannerOuterPadding * 2).clamp(0.0, sideWidth);
    final bannerWidth = AppSideBannerLayout.targetBannerWidth
        .clamp(AppSideBannerLayout.minBannerWidth, innerMaxWidth);

    return SizedBox(
      width: sideWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSideBannerLayout.bannerOuterPadding,
        ),
        child: Center(
          child: SizedBox(
            width: bannerWidth,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
              child: const SideBannerAd(),
            ),
          ),
        ),
      ),
    );
  }
}
