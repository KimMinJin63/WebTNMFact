# 프로젝트 규칙 (TNM팩트)

## 커밋 · 배포

### 커밋 메시지
- 커밋 메시지는 한글로 작성합니다.
- AI 공동 작성자 표시(`Co-Authored-By` 등 AI 도구 attribution)는 커밋이나 PR에 넣지 않습니다.

### "끝" 명령
사용자가 "끝"이라고 보내면 다시 묻지 않고 아래 순서로 진행합니다.

1. **커밋**: 현재 작업 브랜치(보통 `office`)에 변경사항을 커밋하고 push합니다.
2. **main 병합**: `git fetch` 후 `main`으로 이동해 `git merge --ff-only <작업 브랜치>`로 병합하고 push한 뒤, 작업 브랜치로 돌아옵니다.
3. **웹 배포**: `flutter build web --release` 후 `firebase deploy --only hosting:production --non-interactive`로 운영 사이트에 배포합니다.
4. **Functions 배포** (`functions/`가 바뀐 경우만):
   - functions는 Node 22를 쓰므로 Firebase CLI 14 이상이 필요합니다. 전역 CLI가 오래됐다면 `npx -y firebase-tools@15.35.0 deploy --only functions --non-interactive`를 사용합니다.
   - `functions/node_modules`가 없으면 먼저 `functions/`에서 `npm ci`를 실행합니다.
5. **확인**: 실제 사이트(https://tnmfact.com)에 반영됐는지 확인하고 결과를 보고합니다.

다음 경우에는 억지로 진행하지 않고 멈춘 뒤 사용자에게 알립니다.
- `main`이 작업 브랜치와 갈라져 있어 fast-forward 병합이 안 될 때
- `flutter analyze`(error)나 빌드가 실패할 때
