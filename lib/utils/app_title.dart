const kDailyPrefix = '[오늘의 교육 뉴스] ';

/// 카테고리에 따라 제목 접두사 보장/제거 (표시/저장 공용)
String normalizeTitleForCategory(String? rawTitle, String? category) {
  final t = (rawTitle ?? '').trim();
  final isDaily = category == '데일리 팩트';

  if (isDaily) {
    return t.startsWith(kDailyPrefix) ? t : '$kDailyPrefix$t';
  } else {
    return t.startsWith(kDailyPrefix) ? t.substring(kDailyPrefix.length).trim() : t;
  }
}
