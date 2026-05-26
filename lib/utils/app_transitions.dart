import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// 웹: 브라우저 뒤로가기와 GetX 슬라이드가 겹치지 않도록 전환 없음
/// 앱: iOS 스타일 슬라이드
Transition get postForwardTransition =>
    kIsWeb ? Transition.noTransition : Transition.rightToLeft;

Transition get postBackTransition =>
    kIsWeb ? Transition.noTransition : Transition.leftToRight;

Duration get postTransitionDuration =>
    kIsWeb ? Duration.zero : const Duration(milliseconds: 280);
