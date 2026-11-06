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
TNM팩트 청소년보호정책

TNM팩트는 청소년이 유해정보로부터 보호받고 안전한 환경에서 뉴스와 정보 콘텐츠를 이용할 수 있도록 「청소년 보호법」 및 「신문 등의 진흥에 관한 법률」 등 관련 법령에 따라 다음과 같이 청소년보호정책을 수립·시행합니다.

제1조 (청소년 보호를 위한 기본 원칙)
TNM팩트는 기사 및 콘텐츠의 제작, 편집, 게시 과정에서 청소년 보호 기준을 준수합니다. 청소년에게 유해할 수 있는 폭력적·선정적 표현과 이미지 등이 불필요하게 노출되지 않도록 관리하며, 관련 법령에 따른 보호조치를 시행합니다.

제2조 (청소년유해정보의 관리 및 접근 제한)
- TNM팩트는 청소년유해정보가 무분별하게 게시되거나 노출되지 않도록 기사 및 콘텐츠를 검토합니다.
- 범죄, 폭력, 성범죄 등 민감한 사안을 보도하는 경우 보도의 공익성과 필요성을 고려하여 표현과 노출 수준을 조정합니다.
- 청소년유해매체물에 해당하는 콘텐츠를 제공하는 경우 관련 법령에 따른 표시, 접근 제한 등 필요한 조치를 시행합니다.
- 청소년유해정보가 확인되면 해당 콘텐츠를 검토하고 수정, 삭제, 접근 제한 등 적절한 조치를 취합니다.

제3조 (청소년 보호를 위한 담당자 관리)
- TNM팩트는 기사 작성자 및 편집 담당자가 청소년 보호 관련 법령과 내부 운영 기준을 준수하도록 관리합니다.
- 청소년 보호와 관련된 법령 및 주요 준수사항을 연 1회 이상 담당자에게 안내합니다.
- 청소년유해정보에 대한 신고가 접수되면 관련 내용을 확인하고 필요한 조치를 시행합니다.

제4조 (피해 상담 및 고충 처리)
TNM팩트는 청소년유해정보로 인한 피해 상담, 신고 및 고충 처리를 위해 청소년보호책임자를 지정합니다. 이용자는 청소년 보호와 관련된 문의나 신고를 아래 연락처로 접수할 수 있습니다.

- 성명: 김민진
- 직위: 대표
- 전화번호: 010-8676-1864
- 이메일: tnmfact@gmail.com

TNM팩트는 접수된 사항을 검토하고 관련 법령 및 운영 기준에 따라 필요한 조치를 시행합니다.

제5조 (청소년보호정책의 변경)
본 정책은 관련 법령 또는 서비스 운영 환경의 변경에 따라 개정될 수 있습니다. 변경 사항은 TNM팩트 웹사이트를 통해 공지합니다.

부칙
공고일자: 2026년 11월 6일
시행일자: 2026년 11월 6일
본 청소년보호정책은 2026년 11월 6일부터 시행합니다.
''';
