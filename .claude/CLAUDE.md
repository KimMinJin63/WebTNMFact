# 프로젝트 규칙 (TNM팩트)

## 커밋 · 배포

### 커밋 메시지
- 커밋 메시지는 한글로 작성합니다.
- AI 공동 작성자 표시(`Co-Authored-By` 등 AI 도구 attribution)는 커밋이나 PR에 넣지 않습니다.

### "끝" 명령
사용자가 "끝"이라고 보내면 다시 묻지 않고 아래 순서로 진행합니다.

1. **커밋**: 현재 작업 브랜치(보통 `office`)에 변경사항을 커밋하고 push합니다.
2. **main 병합**: `git fetch` 후 `main`으로 이동해 `git merge --ff-only <작업 브랜치>`로 병합하고 push한 뒤, 작업 브랜치로 돌아옵니다.
3. **배포는 GitHub Actions가 합니다**: `main`에 push되면 `.github/workflows/deploy.yml`이 웹 빌드 후 production hosting과 functions를 배포합니다. 로컬에서 직접 `firebase deploy`를 하지 않습니다.
4. **확인**: Actions 실행이 끝날 때까지 기다린 뒤(보통 5~10분) 실제 사이트(https://tnmfact.com)에 반영됐는지 확인하고 결과를 보고합니다. 실행 상태는 https://github.com/KimMinJin63/WebTNMFact/actions 에서 볼 수 있습니다.

커밋 전에 `flutter analyze`로 에러가 없는지 확인합니다. 다음 경우에는 억지로 진행하지 않고 멈춘 뒤 사용자에게 알립니다.
- `main`이 작업 브랜치와 갈라져 있어 fast-forward 병합이 안 될 때
- `flutter analyze`(error)가 있을 때
- Actions 배포가 실패했을 때 (실패한 단계와 로그 요약을 보고)

GitHub Actions가 동작하지 않는 등 긴급하게 로컬에서 배포해야 할 때만:
- `flutter build web --release` 후 `firebase deploy --only hosting:production --non-interactive`
- functions는 Node 22라 Firebase CLI 14 이상이 필요합니다: `functions/`에서 `npm ci` 후 `npx -y firebase-tools@15.35.0 deploy --only functions --non-interactive`
