# Flutter UI Rules

## Colors
- 모든 색상은 `AppColor` 사용.
- 금지: `Color(0xFF...)`, `Colors.*` 직접 사용.
- 매핑 예:
  - Primary 버튼/강조: `AppColor.primary`
  - 배경/텍스트: `AppColor.white`, `AppColor.black`
  - 보더/섀도: `AppColor.shadowGrey`
  - 상태: success=`AppColor.green`, error=`AppColor.red`

## Layout & Spacing
- 여백은 4의 배수(4,8,12,16,20…).
- 공통 radius: `BorderRadius.circular(12)`.
- 반응형 단위는 `ScreenUtil` 사용: `.w`, `.h`, `.sp`.

## Widgets
- 200줄↑ 또는 역할 분리 필요 시 위젯 쪼개기.
- 빌더·콜백은 `typedef` 또는 명명된 함수 사용.

## Examples
**✅ OK**
```dart
Container(
  padding: EdgeInsets.all(16.w),
  decoration: BoxDecoration(
    color: AppColor.white,
    borderRadius: BorderRadius.circular(12),
  ),
)
