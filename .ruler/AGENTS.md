# AI Agents Configuration for TNM FACT

이 문서는 Ruler 규칙이 적용되는 AI 도구(에이전트)의 목록과 사용 목적을 정리합니다.  
개발 환경 및 자동화 도구들이 동일한 코딩 스타일과 가이드라인을 따르도록 관리합니다.

---

## 🎯 사용 중인 주요 에이전트

### 1. GitHub Copilot
- **설명:** 코드 자동완성 및 제안 기능 제공
- **규칙 적용:**  
  - `AppColor`, `AppTextStyle` 외부 하드코딩 금지  
  - `TextStyle()` 직접 생성 대신 `AppTextStyle` 프리셋 사용  
  - 네비게이션은 반드시 `AppRoutes`를 통해 처리

---

### 2. Cursor AI
- **설명:** AI 기반 코드 리팩터링 및 설명 기능 제공 (VS Code 기반 IDE)
- **규칙 적용:**  
  - `Color(0x...)` 사용 시 `AppColor` 추천  
  - `TextStyle` 생성 시 Ruler 가이드 자동 참조  
  - Flutter UI 작성 시 spacing은 4의 배수 유지

---

### 3. Claude 3.5 Sonnet (Cursor 내 Agent)
- **설명:** 복잡한 플랜 모드 및 문서화 담당
- **규칙 적용:**  
  - 코드 설명 시 `AppColor` 등 내부 명칭 그대로 유지

---

### 4. Ruler CLI
- **설명:** 규칙 주입 및 AI 간 동기화 관리
- **명령어:**  
  - `ruler apply` — 규칙 반영  
  - `ruler list` — 적용된 번들 목록 확인  
  - `ruler doctor` — 설정 검증

---

## ⚙️ 추후 추가 예정
- Firebase Studio (자동 배포용)
- Aider (커밋 단위 리팩터링 보조)
