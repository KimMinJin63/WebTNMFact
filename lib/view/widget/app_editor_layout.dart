import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tnm_fact/utils/admin_breakpoint.dart';
import 'package:tnm_fact/utils/app_color.dart';

/// 기사 작성·수정 화면 공통 레이아웃.
/// - 넓은 화면: 왼쪽 본문 편집 + 오른쪽 설정 사이드바
/// - 좁은 화면: 본문 편집 아래에 설정을 세로로 배치하고 전체 스크롤
class AppEditorLayout extends StatelessWidget {
  const AppEditorLayout({
    super.key,
    required this.title,
    required this.body,
    required this.settings,
  });

  /// 제목 입력 필드
  final Widget title;

  /// 본문 입력 필드 (expands: true 인 TextField)
  final Widget body;

  /// 카테고리·발행여부 설정
  final Widget settings;

  Widget _card({required Widget child, required EdgeInsets padding}) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColor.white,
      ),
      padding: padding,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.lightGrey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < AdminBreakpoint.mobile) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _card(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title,
                        const SizedBox(height: 12),
                        SizedBox(
                          height: max(360, constraints.maxHeight * 0.6),
                          child: body,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _card(padding: const EdgeInsets.all(16), child: settings),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _card(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title,
                        const SizedBox(height: 16),
                        Expanded(child: body),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 240,
                  child: _card(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: SingleChildScrollView(child: settings),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
