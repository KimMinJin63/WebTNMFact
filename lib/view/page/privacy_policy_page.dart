import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});
  static const route = '/privacy';

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
                _privacyText, // 아래 문자열 상수에서 불러오기
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

/// 개인정보처리방침 본문
const String _privacyText = '''
TNM팩트 개인정보 처리방침

TNM팩트는 이용자의 개인정보를 중요하게 생각하며, 「개인정보 보호법」 등 관련 법령을 준수합니다. 본 개인정보 처리방침은 TNM팩트가 이용자의 개인정보를 어떤 목적으로 처리하고, 어떻게 보호하는지 안내합니다.

제1조 (개인정보의 처리 목적 및 항목)
TNM팩트는 회원가입이나 로그인 기능을 제공하지 않으며, 기사 열람을 위해 이용자의 성명이나 연락처를 입력받지 않습니다. 다만 서비스 이용과 문의 과정에서 다음 정보가 처리될 수 있습니다.

■ 웹사이트 이용
  · 항목: IP 주소, 방문 일시, 브라우저 및 기기 정보
  · 처리 목적: 웹사이트 제공, 서비스 안정성 확보
■ 광고 제공
  · 항목: 쿠키, 광고 관련 식별정보, 광고 이용 기록, 방문 기록
  · 처리 목적: Google AdSense 광고 제공, 광고 성과 측정, 부정 광고 활동 방지
■ 기사 정정 요청 및 문의
  · 항목: 이메일 주소, 문의 내용, 이용자가 자발적으로 제공한 정보
  · 처리 목적: 기사 오류 확인, 정정 요청 검토, 문의 처리 및 결과 회신

제2조 (개인정보의 처리 및 보유기간)
- TNM팩트는 개인정보를 처리 목적에 필요한 기간 동안 보유합니다.
- 일반 문의 및 단순 기사 오류 제보와 관련된 개인정보는 처리 완료 후 30일 이내 파기합니다.
- 정정보도·반론보도 청구 등 법적 절차와 관련된 개인정보는 해당 절차 및 권리 보호에 필요한 범위에서 보유하며, 보유 근거가 소멸하면 파기합니다.
- Google 및 관련 광고 기술 제공업체가 처리하는 정보의 보유기간은 해당 업체의 개인정보 처리 정책과 설정에 따릅니다.

제3조 (개인정보의 제3자 제공 및 광고 서비스)
TNM팩트는 이용자의 동의나 법적 근거 없이 개인정보를 제3자에게 제공하지 않습니다. 다만 Google AdSense 광고 제공 과정에서 Google 및 관련 광고 기술 제공업체가 이용자의 정보를 수집하거나 처리할 수 있습니다.

Google 및 제3자 광고업체는 이용자의 TNM팩트 방문 기록이나 다른 웹사이트 방문 기록 등을 바탕으로 광고 쿠키를 사용할 수 있으며, 이에 기반한 광고가 제공될 수 있습니다. 이용자는 다음 페이지에서 관련 설정을 확인하거나 변경할 수 있습니다.

- Google 개인정보처리방침: https://policies.google.com/privacy
- Google 광고 설정: https://myadcenter.google.com/
- Google 광고 기술 안내: https://policies.google.com/technologies/ads
- 제3자 광고업체 맞춤형 광고 선택: https://www.aboutads.info/choices/

제4조 (개인정보 처리의 위탁)
TNM팩트는 서비스 운영을 위해 다음과 같이 개인정보 처리 업무를 위탁합니다.

- Google LLC: 웹사이트 운영 및 데이터 관리(Firebase)
- Google LLC: 기사 정정 요청 및 문의 메일 수신·보관(Gmail)

제5조 (개인정보의 국외 이전)
TNM팩트가 이용하는 Google 서비스의 제공 과정에서 개인정보가 다음과 같이 국외로 이전될 수 있습니다.

- 이전받는 자: Google LLC (연락처: https://policies.google.com/privacy 의 문의 안내)
- 이전 국가: 미국 등 Google이 데이터 처리 시설을 운영하는 국가
- 이전 항목: IP 주소, 쿠키, 광고 관련 식별정보, 방문 일시, 브라우저 및 기기 정보, 광고 이용 기록, 이메일 주소, 문의 내용
- 이전 시기 및 방법: 웹사이트 접속 또는 메일 수신 시 정보통신망을 통해 전송
- 이용 목적: 웹사이트 운영, 광고 제공 및 성과 측정, 부정 광고 활동 방지, 메일 수신·보관
- 보유·이용 기간: 문의 메일은 본 방침 제2조에 따릅니다. 그 밖의 정보는 Google의 개인정보 처리 정책과 설정에 따릅니다.
- 거부 방법 및 효과: 브라우저 설정으로 쿠키를 차단하거나 Google 광고 설정에서 맞춤형 광고를 변경할 수 있으며, 기사 열람은 계속 가능합니다. 웹사이트 운영에 필요한 접속 정보의 이전을 거부하려면 웹사이트 이용을 중단해야 합니다. 메일 이전을 원하지 않으면 푸터의 주소 또는 대표전화로 문의할 수 있습니다.

Google의 국제 데이터 이전 정보는 https://business.safety.google/adsdatatransfers/ 에서 확인할 수 있습니다.

제6조 (쿠키의 설치·운영 및 거부)
TNM팩트는 Google AdSense 광고 제공을 위해 쿠키 및 유사한 기술을 사용합니다. 쿠키는 웹사이트 또는 관련 서비스가 이용자의 브라우저에 저장하는 소량의 정보입니다.

- 사용 목적: 광고 제공 및 성과 측정, 이용자의 관심사에 기반한 맞춤형 광고 제공, 부정 광고 활동 방지
- 설정 및 거부 방법: 웹브라우저의 설정 또는 개인정보 보호 메뉴에서 쿠키를 삭제하거나 저장을 차단할 수 있습니다.
- 거부 시 영향: 쿠키를 차단하더라도 일반적인 기사 열람은 가능합니다. 다만 일부 광고 기능이 달라질 수 있습니다.
- 맞춤형 광고 설정: https://myadcenter.google.com/

제7조 (정보주체와 법정대리인의 권리·의무 및 행사 방법)
- 이용자는 관련 법령에 따라 자신의 개인정보에 대한 열람, 정정·삭제, 처리정지 및 동의 철회 등을 요청할 수 있습니다.
- 만 14세 미만 아동의 법정대리인은 해당 아동의 개인정보에 대하여 같은 권리를 행사할 수 있습니다. 권리 행사는 법정대리인이나 위임을 받은 자를 통해서도 할 수 있습니다.
- 이용자와 법정대리인은 관련 법령을 준수하고, 타인의 개인정보를 침해하지 않아야 합니다.
- 권리 행사 요청은 개인정보 보호책임자의 이메일로 접수할 수 있습니다.
- TNM팩트는 요청 내용을 확인한 뒤 관련 법령에 따라 처리합니다. 법령에 따라 권리 행사가 제한되는 경우에는 그 사유를 안내합니다.

제8조 (개인정보의 파기 절차 및 방법)
- TNM팩트는 개인정보의 보유기간이 경과하거나 처리 목적이 달성되어 개인정보가 불필요하게 된 경우 개인정보 보호책임자가 파기 대상을 확인한 뒤 지체 없이 파기합니다.
- 전자적 파일 형태의 개인정보는 복구 또는 재생되지 않도록 안전한 방법으로 삭제합니다.
- 종이 문서에 기록된 개인정보는 분쇄 또는 소각합니다.
- 관련 법령에 따라 보존해야 하는 정보는 해당 법령에 따라 별도로 관리합니다.

제9조 (개인정보의 안전성 확보 조치)
TNM팩트는 개인정보 보호를 위해 다음 조치를 시행합니다.

- 개인정보 접근 권한 관리
- 비정상적인 접근 및 침해사고 방지
- 개인정보 처리 계정의 보안 관리

제10조 (개인정보 보호책임자)
TNM팩트는 개인정보 처리에 관한 업무를 총괄하고 이용자의 고충 처리 및 피해 구제를 위해 다음과 같이 개인정보 보호책임자를 지정합니다.

- 성명: 김민진
- 직책: 대표 / 개인정보 보호책임자
- 이메일: tnmfact@gmail.com

이용자는 개인정보 보호와 관련된 문의, 불만 처리 및 권리 행사 등을 위 이메일로 요청할 수 있습니다.

제11조 (권익 침해 구제 방법)
이용자는 개인정보 침해에 관한 상담이나 피해 구제를 위해 다음 기관에 문의할 수 있습니다.

- 개인정보침해신고센터: 국번 없이 118 / https://privacy.kisa.or.kr
- 개인정보 분쟁조정위원회: 1833-6972 / https://www.kopico.go.kr

제12조 (개인정보 처리방침의 변경)
본 개인정보 처리방침은 관련 법령 및 서비스 운영 정책의 변경에 따라 개정될 수 있습니다. 변경 사항은 TNM팩트 웹사이트를 통해 공지하며, 관련 법령에서 정한 절차가 있는 경우 이를 따릅니다.

부칙
공고일자: 2026년 11월 6일
시행일자: 2026년 11월 6일
본 개인정보 처리방침은 2026년 11월 6일부터 시행합니다.
''';
