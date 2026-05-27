import 'package:flutter/material.dart';

/// 220×825 전용 사이드 배너 — 이 규격에 맞춘 독립 디자인.
class SideBannerAd extends StatelessWidget {
  const SideBannerAd({super.key});

  static const double designWidth = 220;
  static const double designHeight = 825;

  static const Color _bgTop = Color(0xFF0F1B4C);
  static const Color _bgBottom = Color(0xFF4A2D8C);
  static const Color _gold = Color(0xFFF5C842);
  static const Color _mint = Color(0xFF5DDFA3);
  static const Color _coral = Color(0xFFFF8A65);
  static const Color _cardBg = Color(0x1FFFFFFF);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: designWidth,
      height: designHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_bgTop, Color(0xFF2A1F6E), _bgBottom],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: 120,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                bottom: 180,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _gold.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 26, 12, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: _OfficialBusinessEmblem()),
                    const SizedBox(height: 16),
                    const _HeroTitle(),
                    const SizedBox(height: 16),
                    const _SectionLabel(text: '이런 분께'),
                    const SizedBox(height: 10),
                    const _CheckLine(text: '기획서 없이 캡처만 주세요'),
                    const SizedBox(height: 7),
                    const _CheckLine(text: 'PM과 개발이 한 팀입니다'),
                    const SizedBox(height: 7),
                    const _CheckLine(text: 'Flutter로 iOS·Android 동시'),
                    const SizedBox(height: 18),
                    const _SectionLabel(text: '패키지'),
                    const SizedBox(height: 12),
                    const _PackageTile(
                      accent: _mint,
                      label: 'STANDARD',
                      price: '3만',
                      desc: '7일 · 맛보기 MVP · APK',
                      icon: Icons.rocket_launch_rounded,
                    ),
                    const SizedBox(height: 9),
                    const _PackageTile(
                      accent: _gold,
                      label: 'DELUXE',
                      price: '30만',
                      desc: '14일 · 스토어 출시 대행',
                      icon: Icons.diamond_rounded,
                      highlight: true,
                    ),
                    const SizedBox(height: 9),
                    const _PackageTile(
                      accent: _coral,
                      label: 'PREMIUM',
                      price: '100만~',
                      desc: '회원·결제·예약 등 실전 MVP',
                      icon: Icons.auto_awesome_rounded,
                    ),
                    const SizedBox(height: 14),
                    const _PackageFootnotes(),
                    const SizedBox(height: 14),
                    _CtaButton(
                      label: '외주 신청하러 가기',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('준비중입니다.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    const _BottomBar(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 첫 배너 이미지처럼 상단 중앙 금색 엠블럼.
class _OfficialBusinessEmblem extends StatelessWidget {
  const _OfficialBusinessEmblem();

  static const Color _goldDark = Color(0xFFB8860B);
  static const Color _badgeText = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.workspace_premium_rounded,
          size: 30,
          color: SideBannerAd._gold,
          shadows: [
            Shadow(
              color: SideBannerAd._gold.withValues(alpha: 0.5),
              blurRadius: 8,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _LaurelLeaf(flip: true),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF8D86E), SideBannerAd._gold],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _goldDark, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: SideBannerAd._gold.withValues(alpha: 0.45),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                '정식 사업자',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: _badgeText,
                  height: 1,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const _LaurelLeaf(flip: false),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '세금계산서 발행 가능',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.7),
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _LaurelLeaf extends StatelessWidget {
  const _LaurelLeaf({required this.flip});

  final bool flip;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: flip ? -1 : 1,
      child: Icon(
        Icons.eco_rounded,
        size: 24,
        color: SideBannerAd._gold.withValues(alpha: 0.85),
      ),
    );
  }
}

class _HeroTitle extends StatelessWidget {
  const _HeroTitle();

  @override
  Widget build(BuildContext context) {
    const subStyle = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      height: 1.28,
    );
    return Column(
      children: [
        const Text(
          'Flutter 전문',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.25,
          ),
          textAlign: TextAlign.center,
        ),
        const Text('PM x 개발자 부부', style: subStyle, textAlign: TextAlign.center),
        const Text('초고속 가성비 MVP', style: subStyle, textAlign: TextAlign.center),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Colors.white.withValues(alpha: 0.5),
        letterSpacing: 1.2,
        height: 1,
      ),
    );
  }
}

class _CheckLine extends StatelessWidget {
  const _CheckLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_rounded, size: 15, color: SideBannerAd._mint),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _PackageTile extends StatelessWidget {
  const _PackageTile({
    required this.accent,
    required this.label,
    required this.price,
    required this.desc,
    required this.icon,
    this.highlight = false,
  });

  final Color accent;
  final String label;
  final String price;
  final String desc;
  final IconData icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
      decoration: BoxDecoration(
        color: SideBannerAd._cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlight ? accent.withValues(alpha: 0.7) : Colors.white.withValues(alpha: 0.12),
          width: highlight ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: accent),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: accent,
                        height: 1,
                      ),
                    ),
                    if (highlight) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.star_rounded, size: 12, color: accent),
                    ],
                    const Spacer(),
                    Text(
                      price,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 패키지 하단 — 서비스 설명에서 뽑은 짧은 멘트.
class _PackageFootnotes extends StatelessWidget {
  const _PackageFootnotes();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Text(
            '참고 캡처만 주시면\n알아서 MVP까지 만들어 드립니다',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: SideBannerAd._gold.withValues(alpha: 0.95),
              height: 1.35,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const _FootnoteLine(text: '출시 후 14일 무상 버그 수정'),
          const SizedBox(height: 4),
          const _FootnoteLine(text: '구매 확정 시 소스코드 전달'),
          const SizedBox(height: 4),
          const _FootnoteLine(text: '스토어 심사 기간은 작업일에서 제외'),
        ],
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              SideBannerAd._gold.withValues(alpha: 0.95),
              SideBannerAd._gold.withValues(alpha: 0.75),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: SideBannerAd._gold.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                  height: 1,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FootnoteLine extends StatelessWidget {
  const _FootnoteLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '·',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.5),
            height: 1.3,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.72),
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            '5년차 PM · 3년차 Flutter',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            'Android & iOS 동시 개발',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.55),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
