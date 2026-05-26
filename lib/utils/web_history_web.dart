import 'dart:html' as html;

import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:tnm_fact/utils/app_routes.dart';

bool _handlingBrowserNav = false;

final RegExp _postPathPattern = RegExp(r'^/post/([^/]+)/?$');

void initWebHistoryBridge() {
  html.window.onPopState.listen((_) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _syncGetRouteWithBrowserUrl();
    });
  });
}

bool isBrowserOnHomePath() {
  final path = Uri.base.path;
  return path == '/' || path.isEmpty;
}

/// 직접 /post/… URL로 들어온 뒤 목록으로 갈 때: 현재 히스토리 항목을 / 로 교체
void replaceBrowserUrlWithHome() {
  if (!isBrowserOnHomePath()) {
    html.window.history.replaceState(null, '', AppRoutes.home);
  }
}

/// Get.toNamed 이후 호출 — 브라우저 히스토리를 […, /, /post/id] 형태로 맞춤
void repairBrowserHistoryAfterPostOpen(String postPath) {
  if (!_postPathPattern.hasMatch(Uri.base.path)) return;
  if (Uri.base.path != postPath) return;

  html.window.history.replaceState(null, '', AppRoutes.home);
  html.window.history.pushState(null, '', postPath);
}

bool _routeIsPostDetail() {
  final route = Get.currentRoute;
  return route.startsWith('/post/') || route == AppRoutes.post;
}

void _syncGetRouteWithBrowserUrl() {
  if (_handlingBrowserNav) return;

  final path = Uri.base.path;

  // 브라우저 URL이 / — 스택에 상세가 남아 있으면 무조건 pop (Get.currentRoute는 / 일 수 있음)
  if (path == '/' || path.isEmpty) {
    final navigator = Get.key.currentState;
    if (navigator != null && navigator.canPop()) {
      _handlingBrowserNav = true;
      Get.back();
      _handlingBrowserNav = false;
      return;
    }
    if (_routeIsPostDetail()) {
      _handlingBrowserNav = true;
      Get.offAllNamed(AppRoutes.home);
      _handlingBrowserNav = false;
    }
    return;
  }

  final match = _postPathPattern.firstMatch(path);
  if (match == null) return;

  if (_routeIsPostDetail()) return;

  final target = AppRoutes.postDetail(match.group(1)!);
  if (Get.currentRoute == target) return;

  _handlingBrowserNav = true;
  Get.toNamed(target);
  _handlingBrowserNav = false;
}
