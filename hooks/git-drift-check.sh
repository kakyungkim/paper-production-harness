#!/usr/bin/env bash
# SessionStart 드리프트 조기경보 — 현재 브랜치가 base 대비 얼마나 앞/뒤인지 알린다.
# 절대 세션을 막지 않는다(항상 exit 0). 팀 레포의 `.claude/hooks/`로 두고
# settings.json 의 SessionStart 훅에 등록한다. base는 DRIFT_BASE 로 바꿀 수 있다.
#
# 왜: 다른 창·다른 사람이 브랜치를 진행해 로컬이 뒤처졌는지를 세션 시작에 한 번 알려,
# 낡은 상태 위에서 작업하다 충돌·중복을 만드는 일을 줄인다. 경고만 하고 판단은 사람.
set -u
BASE="${DRIFT_BASE:-origin/main}"
ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || exit 0
cd "$ROOT" 2>/dev/null || exit 0
git rev-parse --verify "$BASE" >/dev/null 2>&1 || exit 0
BR="$(git branch --show-current 2>/dev/null)"
AHEAD="$(git rev-list --count "$BASE"..HEAD 2>/dev/null || echo 0)"
BEHIND="$(git rev-list --count HEAD.."$BASE" 2>/dev/null || echo 0)"
if [ "${AHEAD:-0}" != "0" ] || [ "${BEHIND:-0}" != "0" ]; then
  echo "⚠️ git drift: '${BR:-?}' 가 ${BASE} 대비 앞 ${AHEAD:-0} / 뒤 ${BEHIND:-0} — 필요하면 pull/rebase 먼저."
fi
exit 0
