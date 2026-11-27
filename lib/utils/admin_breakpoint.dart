/// 관리자 페이지 반응형 기준 너비 (콘텐츠 영역 기준, 논리 픽셀)
class AdminBreakpoint {
  /// 이보다 좁으면 모바일 레이아웃 (세로 배치, 카드형 목록)
  static const double mobile = 800;

  /// 이보다 좁으면 사이드바 대신 상단바 + 메뉴(Drawer) 사용
  static const double sidebar = 700;

  /// 이보다 넓으면 사이드바에 메뉴 이름까지 표시
  static const double sidebarExtended = 1000;
}
