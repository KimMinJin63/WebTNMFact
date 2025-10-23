import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int minLines; // 최소 노출 줄 수

  const App({
    super.key,
    required this.text,
    required this.style,
    this.minLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 전체 텍스트 높이 계산
        final tp = TextPainter(
          text: TextSpan(text: text, style: style),
          textDirection: TextDirection.ltr,
          maxLines: null,
        )..layout(maxWidth: constraints.maxWidth);

        // 줄 단위 높이 계산
        final lineMetrics = tp.computeLineMetrics();

        // 최소 줄수 보장 (3줄)
        final int totalLines = lineMetrics.length;
        final int visibleLines = totalLines < minLines ? minLines : totalLines;

        // 실제 표시할 줄수
        return Text(
          text,
          style: style,
          maxLines: visibleLines,
          softWrap: true,
          overflow: TextOverflow.visible,
        );
      },
    );
  }
}
