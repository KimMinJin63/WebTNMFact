import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});
  static const route = '/service';

  @override
  Widget build(BuildContext context) {
    // 0.1초 딜레이로 폰트 캐시 안정화 후 렌더링
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
                _serviceText,
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

/// 🧾 서비스 이용약관 본문
const String _serviceText = '''
TNM팩트 서비스 이용약관

제1조 (목적)
본 약관은 TNM팩트 발행인 김민진(이하 "운영자"라 합니다)이 제공하는 웹사이트 및 관련 온라인 서비스(이하 "서비스"라 합니다)의 이용과 관련하여 운영자와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

제2조 (정의)
- "서비스"란 운영자가 TNM팩트의 제호로 제공하는 인터넷신문 및 온라인 콘텐츠 서비스로서 이슈팩트, 포커스팩트, 인사이트팩트 등 기사와 뉴스·정보·분석 콘텐츠 및 이에 부수하는 서비스를 의미합니다.
- "이용자"란 TNM팩트 웹사이트에 접속하여 서비스를 이용하는 사람을 의미합니다.

제3조 (약관의 게시 및 변경)
- 운영자는 이용자가 본 약관을 확인할 수 있도록 웹사이트에 게시합니다.
- 운영자는 관련 법령을 위반하지 않는 범위에서 약관을 변경할 수 있습니다.
- 약관을 변경하는 경우 변경 내용과 시행일을 시행 7일 전부터 웹사이트에 공지합니다. 다만 이용자에게 불리한 변경은 시행 30일 전부터 공지합니다.
- 변경된 약관은 관련 법령에서 달리 정하지 않는 한 명시된 시행일부터 적용됩니다.

제4조 (서비스의 제공 및 변경)
- 운영자는 사회, 경제, 국제, 과학, 기술, 문화 등 다양한 분야의 뉴스와 정보·분석 콘텐츠를 제공합니다.
- 서비스는 별도의 회원가입이나 로그인 없이 누구나 기사와 공개 콘텐츠를 열람할 수 있도록 제공됩니다.
- 운영자는 운영상 또는 기술상의 필요에 따라 서비스의 내용이나 제공 방식을 변경할 수 있습니다.
- 서비스의 전부 또는 일부를 중단하는 경우 가능한 범위에서 사전에 안내합니다. 다만 긴급한 장애나 불가피한 사유가 있는 경우 사후에 안내할 수 있습니다.
- 서비스는 원칙적으로 무료로 제공됩니다. 별도의 유료 서비스를 도입하는 경우에는 이용 조건을 사전에 안내합니다.

제5조 (저작권 및 콘텐츠 이용)
- 운영자가 직접 제작한 기사, 텍스트, 이미지, 그래픽, 데이터 분석 자료 등 콘텐츠의 저작권은 운영자 또는 정당한 권리자에게 귀속됩니다.
- 이용자는 관련 법령에서 허용하는 범위를 벗어나 콘텐츠를 권리자의 허락 없이 복제, 배포, 전송, 출판하거나 영리 목적으로 이용할 수 없습니다.
- 기사 원문으로 연결되는 링크의 공유는 원칙적으로 허용됩니다.
- 콘텐츠를 인용하는 경우 「저작권법」 등 관련 법령을 준수하고 출처를 명확하게 표시해야 합니다.
- 출처 표시만으로 콘텐츠의 무단 복제나 재배포가 허용되는 것은 아닙니다.

제6조 (기사 정정 요청 및 권리 보호)
- 이용자는 기사나 콘텐츠에 사실관계의 오류가 있다고 판단하는 경우 운영자에게 정정을 요청할 수 있습니다.
- 정정 요청은 이메일(tnmfact@gmail.com)로 접수합니다.
- 운영자는 접수된 내용을 확인하고 필요한 경우 기사 수정, 정정 또는 그 밖의 적절한 조치를 시행합니다.
- 정정보도, 반론보도 및 추후보도 청구 등 법률에 따른 권리 행사와 처리 절차는 「언론중재 및 피해구제 등에 관한 법률」 등 관련 법령을 따릅니다.
- 일반적인 기사 수정 요청 절차는 법률에 따른 정정보도 등의 청구권을 제한하지 않습니다.

제7조 (광고의 게재)
- 운영자는 서비스 운영을 위해 Google AdSense 등 광고를 게재할 수 있습니다.
- 광고를 통해 외부 웹사이트로 이동하는 경우 해당 웹사이트의 이용약관 및 개인정보 처리방침이 적용될 수 있습니다.
- 운영자가 외부 광고 상품이나 서비스의 거래 당사자가 아닌 경우 해당 거래에 직접적인 책임을 부담하지 않습니다. 다만 관련 법령에 따른 책임은 제외되지 않습니다.
- 광고성 콘텐츠를 기사 형식으로 제공하는 경우 관련 법령에 따라 광고임을 명확하게 표시합니다.

제8조 (이용자의 준수사항)
이용자는 다음 행위를 해서는 안 됩니다.

- 서비스의 정상적인 운영을 방해하는 행위
- 운영자 또는 제3자의 저작권 등 권리를 침해하는 행위
- 웹사이트에 무단으로 접근하거나 보안상 취약점을 악용하는 행위
- 관련 법령을 위반하는 행위

제9조 (책임의 한계)
- 운영자는 콘텐츠의 정확성, 신뢰성 및 공정성을 확보하기 위해 노력합니다.
- 뉴스와 분석 콘텐츠는 정보 제공을 목적으로 하며, 이용자 개인의 투자, 법률, 의료 등 전문적인 판단을 대신하지 않습니다.
- 천재지변, 통신 장애 등 불가항력적인 사유로 서비스 제공이 어려운 경우 관련 법령에서 허용하는 범위에서 책임이 제한될 수 있습니다.
- 본 약관은 운영자의 고의 또는 과실에 따른 법적 책임을 일률적으로 면제하는 것으로 해석되지 않습니다.

제10조 (준거법 및 분쟁 해결)
- 본 약관의 해석 및 적용에는 대한민국 법률을 따릅니다.
- 서비스 이용과 관련한 분쟁은 당사자 간 협의를 통해 해결하도록 노력합니다.
- 협의로 해결되지 않는 분쟁은 관련 법령에서 정한 관할 법원에서 해결합니다.

부칙
공고일자: 2026년 11월 6일
시행일자: 2026년 11월 6일
본 약관은 2026년 11월 6일부터 시행합니다.
''';
