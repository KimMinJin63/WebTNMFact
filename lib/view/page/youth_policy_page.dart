import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class YouthPolicyPage extends StatelessWidget {
  const YouthPolicyPage({super.key});
  static const route = '/youth';

  @override
  Widget build(BuildContext context) {
    // 0.1초 딜레이 후 로딩 완료 → 폰트 로드 안정화 후 본문 표시
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 100)),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return _buildMainContent();
      },
    );
  }

  /// 본문 렌더링 함수
  Widget _buildMainContent() {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: Get.back,
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: AppColor.primary),
                    const SizedBox(width: 4),
                    Text(
                      '돌아가기',
                      style: AppTextStyle.koSemiBold14()
                          .copyWith(color: AppColor.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _youthPolicyText,
                style: AppTextStyle.koRegular14()
                    .copyWith(height: 1.6, color: AppColor.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 청소년보호정책 본문
const String _youthPolicyText = '''
TNM FACT 청소년보호정책

TNM FACT는 각종 청소년유해정보로부터 청소년을 보호하고, 청소년이 건전한 인격체로 성장할 수 있도록 돕기 위하여 청소년보호법 및 신문 등의 진흥에 관한 법률에 근거하여 다음과 같이 청소년보호정책을 수립·시행하고 있습니다.

1. 청소년 유해정보로부터의 청소년 보호계획 수립 및 활동
TNM FACT는 청소년이 아무런 제한 없이 청소년유해정보에 노출되지 않도록 가독성 높은 유해정보 차단 및 예방 조치를 취하고 있습니다.

2. 청소년유해정보에 대한 청소년접근제한 및 관리조치
TNM FACT는 청소년유해정보가 노출되지 않도록 취재 및 기사 작성 시 청소년보호 기준을 준수하며, 청소년유해정보가 빈번하게 유출되는 매체에 대해서는 지속적인 모니터링을 실시합니다.

3. 유해정보로부터의 청소년보호를 위한 업무 담당자 교육
TNM FACT는 청소년보호 관련 법령 및 제반 준수사항, 유해정보 발견 시 대처 양식 등에 대해 기사 작성자 및 편집자를 대상으로 교육을 실시합니다.

4. 청소년유해정보로 인한 피해상담 및 고충처리
TNM FACT는 청소년유해정보로 인한 피해상담 및 고충처리를 위하여 아래와 같이 청소년보호책임자 및 담당자를 지정하고 있습니다.

■ 청소년보호책임자 및 담당자
- 성명: 김민진
- 직위: 대표
- 전화번호: 010-8676-1864
- 이메일: tnmfact@gmail.com

공고일자: 2026년 11월 01일
시행일자: 2026년 11월 01일
''';
