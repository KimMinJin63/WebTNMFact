import 'package:flutter/material.dart';
import 'package:tnm_fact/utils/app_color.dart';
import 'package:tnm_fact/utils/app_text_style.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key, required this.logo, required this.companyInfo, required this.name, required this.publeInfo, required this.address, required this.contact, required this.service, required this.privacy, required this.copyright, this.serviceTap, this.privacyTap});
  final String logo;
  final String companyInfo;
  final String name;
  final String publeInfo;
  final String address;
  final String contact;
  final String service;
  final String privacy;
  final String copyright;
  final VoidCallback? serviceTap;
  final VoidCallback? privacyTap;

  @override
  Widget build(BuildContext context) {
  return Container(
    width: double.infinity,
    color: Colors.grey[100],
    padding: const EdgeInsets.symmetric(vertical: 40),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1260),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 로고 & 제호 ---
              Text(
                logo,
                style: AppTextStyle.koBold18(),
              ),
              const SizedBox(height: 8),

              // --- 발행 정보 ---
              Text(
                companyInfo,
                style:
                    AppTextStyle.koRegular14().copyWith(color: AppColor.grey),
              ),
              Text(
                name,
                style:
                    AppTextStyle.koRegular14().copyWith(color: AppColor.grey),
              ),
              const SizedBox(height: 4),
              Text(
                publeInfo,
                style:
                    AppTextStyle.koRegular14().copyWith(color: AppColor.grey),
              ),
              const SizedBox(height: 4),
              Text(
                address,
                style:
                    AppTextStyle.koRegular14().copyWith(color: AppColor.grey),
              ),
              const SizedBox(height: 4),
              Text(
                contact,
                style:
                    AppTextStyle.koRegular14().copyWith(color: AppColor.grey),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // 내부 패딩 제거
                      minimumSize: Size.zero, // 최소 터치 영역 제거
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 높이 축소
                    ),
                    onPressed: serviceTap,
                    child: Text(
                      service,
                      style: AppTextStyle.koRegular14()
                          .copyWith(color: AppColor.black),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // 내부 패딩 제거
                      minimumSize: Size.zero, // 최소 터치 영역 제거
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 높이 축소
                    ),
                    onPressed: privacyTap,
                    child: Text(
                      privacy,
                      style: AppTextStyle.koRegular14()
                          .copyWith(color: AppColor.black),
                    ),
                  ),
                ],
              ),

              // --- 구분선 ---
              const SizedBox(height: 12),
              Divider(height: 32, color: AppColor.lightGrey),

              // --- 저작권 문구 ---
              Text(
                copyright,
                style:
                    AppTextStyle.koRegular12().copyWith(color: AppColor.grey),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }
}