---
name: verify-harness
description: 두 층의 검증을 아무 프로젝트에나 적용한다. Layer 1(AKM WEEK 03) = 주장이 근거에 맞나(사실 검증 ≠ 표현 개선)를 검증 루프로. Layer 2(결과물 검수, mutation) = 그 검사·게이트가 진짜 결함을 잡나를 mutation으로 검증(watchmen 감시). 원고·결과·주장을 provenance(SHA)·독립성·diff-0·mutation으로 검증하되 자동수정하지 않는다. 트리거 — "AKM 적용", "검증 하네스 만들어", "결과물 검수", "게이트가 결함 잡나 검증", "이 원고/결과 검증해", "verify-harness", "검증 하네스", "mutation 검사".
---

> 이 파일은 재사용 템플릿이다. 자기완결형이라 `<FILL>`은 없다 — 팀 레포의 `.claude/skills/verify-harness/SKILL.md`로 두고,
> 이 프로젝트에 이미 있는 검사·게이트·테스트를 아래 3층 역할(baseline 동결·결정적 검사·mutation·독립성 사다리)에 매핑해 쓴다.
> `paper-production-orchestrator`의 검증 게이트(step 7)가 이 스킬의 Layer 3 결정적 검사를 실행하고, Layer 2가 그 검사가 공허하지 않음을 보증한다.

# verify-harness — 검증 하네스 (3층, 프로젝트 무관, 자기완결형)

**Layer 1 = AKM WEEK 03**: 주장이 근거에 맞나(사실 검증). **Layer 2 = 결과물 검수(mutation)**: 그 검사가 진짜 결함을 잡나. 둘은 상보적 — Layer 1의 'deterministic check' 증거를 신뢰하려면 Layer 2로 그 검사가 공허하지 않음을 먼저 보여야 한다.

## Layer 1 — AKM WEEK 03 (사실 검증)

너는 초안을 무조건 다시 쓰는 편집자가 아니라, **증거가 있을 때만 대상 변경을 허용하는 보수적 verifier**다. 같은 모델의 자기비평은 사실 증명이 아니라 질문 후보라는 한계를 명시한다. **검증하고 보고할 뿐, 대상을 자동으로 고치지 않는다**(수정은 사람이 correction gate 아래).

## 0. 시작 전 3가지를 사용자에게 확인(또는 스스로 탐색해 제시 후 확인)
1. **검증 대상(canonical target)** — 무슨 파일/산출물을 검증하나 (원고·리포트·분석결과 등).
2. **근거·결과 파일 위치** — 대상의 주장을 대조할 source(results·데이터·측정값·원문).
3. **위험 Tier** — 0(저장 안 함·루프 0회) / 1(재사용 노트·correction 1회) / 2(공개 글·강의·correction 1회) / 3(투고·의료·계약·claim ledger·correction 2회). 개인 노트면 보통 1~2, 투고물이면 3.

**핵심 원칙: 새 검증 도구를 만들기 전에 이 프로젝트에 이미 있는 검사·게이트·테스트를 먼저 찾아 AKM 역할에 매핑한다.** 다른 프로젝트 스크립트를 복사하지 말고 이 프로젝트 도메인에 맞춰 재해석한다.

## 산출 3개
1. **`VERIFICATION_PROTOCOL.md`** — 위험 Tier 판정, 아래 8단계 루프, correction cap, 6 stop rules, HOLD 4필드, verdict 정의, 그리고 **'이 프로젝트 기존 자산 ↔ AKM 요소' 매핑표**(무엇이 baseline 동결·deterministic check·claim ledger·readback·verdict 역할을 이미 하는지).
2. **러너 스크립트**(예 `verify_<target>.py`) — baseline **SHA-256 실제 동결**(도구로 계산, 채팅으로 계산했다고 주장 금지) + 기존 결정적 검사 체인 + per-check verdict(exit 0=PASS, 1/2=HOLD, 크래시=FAIL, 입력부재=SKIP). **report-only(대상 무수정)**. 리포트는 **검사 대상의 source 코퍼스와 다른 디렉토리**에 쓴다.
3. 고영향 claim 1개에 **과제1 + 과제2 1회 실행 기록**.

## 8단계 검증 루프
1. **Baseline 동결** — 대상의 SHA-256 + (git이면) HEAD 기록. 변경 없이 보존.
2. **고영향 범위 선택** — verdict를 바꿀 claim 3~5개만(전체 문장 아님).
3. **독립 질문 설계** — 대상 문구를 복제하지 않는 원자적 질문(날짜·수치·주체·조건·성과·안전경계).
4. **초안과 분리해 답** — 대상이 아니라 source·도구만으로 답한다.
5. **증거 우선순위 사다리** — 직접 원문+locator > 도구/환경 출력 > 결정적 검사 > 책임 있는 사람 > cross-model 불일치 신호 > sampled 동의 > 같은 모델 자기비평. **낮은 단계만으로 높은 영향 수정 승인 금지.**
6. **Correction gate** — source가 대상과 **구체적으로 충돌**하거나 필수기준 실패를 직접 입증할 때만 최소 수정. 더 자연스러운 표현·취향·근거 없는 비평만으로는 안 고침(그건 Refinement, 별개).
7. **No-degradation readback** — 수정 후 맞던 정보·필수 항목·형식·안전경계가 사라지거나 새 unsupported claim이 생기지 않았는지 확인. baseline PASS였던 게 final FAIL이면 baseline 복원 + HOLD.
8. **Verdict** — PASS / PASS_WITH_NOTE / HOLD / FAIL 하나. Learn-Back은 조건(appliesWhen·doesNotApplyWhen·evidence·falsifier) 다 채울 때만 CONDITIONAL_CANDIDATE, 아니면 NONE.

## 두 실행 모드
- **과제1(prompt-only loop)**: baseline 동결(사본) → 3~5 독립질문 → source-only 답(evidence ledger) → correction gate(최대 1회) → readback → verdict. 같은 대화 same-model이라 완전 독립 아님(INDEPENDENCE_NOTE 명시). 채팅만으로 hash 계산 주장 금지.
- **과제2(file-based, tool evidence)**: canonical writer 1명 → source 직접 read → **실제 SHA-256** → deterministic checks 실행 → final readback + 실제 도구 결과. 완료 보고에 canonical writer·baseline/final SHA·독립질문·증거·correction 횟수·no-degradation·verdict·HOLD필드·Learn-Back·한계를 적는다. **실제 파일 readback과 실제 도구 결과 없이 완료라고 보고하지 마라.**

## 반드시 지킬 함정 5가지 (실사건에서 나옴)
1. **검증 리포트를 검사 대상의 source 코퍼스에 넣지 마** — 자기 리포트를 근거로 삼는 circular evidence(weak-judge propagation)가 난다. 별 디렉토리로 격리.
2. **재계산/재현 게이트는 '실행됨'이 아니라 '커밋값·기대값과 diff 0'을 실제 대조** — rc=0만으론 '일치'가 아니다.
3. **same-model 자기검증만 믿지 마** — cross-model(다른 모델) 또는 human 독립 단계를 하나 넣어라. 사다리를 올릴수록 다른 오류를 줄인다.
4. **note ≠ contradiction** — 약한 근거로 대상을 자동수정하지 말고 사람에게 이관(HOLD 4필드: 부족증거·다음확인 1개·책임경계·재개조건).
5. **verdict가 재실행에서 이유 없이 좋아지면 오염을 의심** — 정상이면 결정적 검사는 재현적이어야 한다.

## 과잉 검증 방지
Correction cap(Tier별) 초과·필요 근거 부재·no-degradation 실패·judge 불일치 미해소·readback 후 새 중대 모순·검증비용>작업위험 중 하나면 즉시 stop. False correction(약한 반대로 맞는 걸 틀리게)·over-editing·critique noise를 경계한다. 저위험(Tier 0~1)은 루프를 최소화한다 — 프레임워크를 모든 것에 과적용하지 않는다.

## 최종 문장 템플릿
> 이 검증은 **[위험 Tier]**이고, **[가장 독립적인 증거]**가 없으면 **[고치지 않기 / HOLD / 사람에게 이관]**하겠다.

---

# Layer 2 — 결과물 검수 (mutation testing: 게이트가 진짜 결함을 잡나)

Layer 1의 증거 사다리는 "deterministic check(Lv3)"를 믿는다. **그 검사가 공허하지 않음(진짜 결함을 잡음)을 mutation으로 먼저 증명**한다. 검사를 신뢰하기 전에 알려진 결함을 주입해 검사가 CONTRADICTED로 잡는지 본다 — 못 잡으면 그 검사는 그 결함 부류에 **NOT_TESTED(공허)**다.

## 8단계 (실사건 방법, 복사 아닌 도메인 재해석)
1. **기존 검사기부터 검색** — 중복 만들지 말고 이 프로젝트 게이트·eval·테스트 전수 파악.
2. **게이트 출력 계약을 케이스 전에 실측** — ★가장 중요. exit 코드는 거짓말한다(정상 입력에도 exit=1인 게이트 있음). 실패신호를 실물로 확정(JSON 필드·miss 델타 등). 모르면 러너가 공허해진다.
3. **케이스 판정을 코드보다 먼저 선언** — 코드가 케이스를 사후 정당화 못 하게.
4. **mutation = 실무자가 저지를 실수로** — 근거 없는 수치 삽입, evidence 갱신 후 원고 stale 방치, claim 등급 무심코 격상, 한계 문단 삭제 등.
5. **control(정본) vs mutated(사본) 델타로 판정** — 정상도 miss를 내는 게이트에서 baseline을 자동 상쇄. 새로 생긴 miss/CONTRADICTED만 결함 신호.
6. **특정 finding 표적 대조** — mutation이 만든 *특정 check+대상*이 새로 뜨는지로 판정(baseline 발견과 무관하게).
7. **못 잡으면(NOT_TESTED) detector 신설로 gap을 닫고 재검증** — 탐지에서 끝내지 않는다. detector는 결정론(LLM 판단 없음, 등록값·substring 대조), 등급은 assist(자동 환원 금지).
8. **음성 대조로 러너 자체 검사** — 기대를 일부러 틀리게 선언한 케이스에서 러너가 불일치를 잡아야 한다(관측 ≠ 기대). 러너가 그걸 통과시키면 러너가 고장.

## fail-closed — '검사 못 한 것'은 '통과'가 아니다
게이트가 mutation을 잡아도(CAUGHT), 실데이터에선 필수 컬럼 부재·검사 대상 0건이라 **아무것도 안 보고 통과**할 수 있다(VACUOUS). 판정을 세 갈래로 벌려 '통과'와 '검사 안 함'을 절대 섞지 않는다 — **CAUGHT**(결함 잡음)·**SURVIVED**(못 잡음)·**VACUOUS/NOT_TESTED**(검사 자체가 공허). 규칙: 빈 `evidence[]`는 pass 불가, 조회·lookup 실패는 pass 불가(NEEDS_HUMAN), 필수 입력 부재는 pass가 아니라 명명된 거부(`missing_required_columns`·`no_rows_checked` 등). 의심스러우면 **fail-closed**(막고 사람에게). mutation을 통과(CAUGHT)한 게이트도 실데이터에서 VACUOUS일 수 있으니, mutation 검증과 fail-closed는 **둘 다** 필요하다.

## 안전
- mutation은 **sandbox 사본(`.sandbox/`, gitignore)**에서만. 정본은 실행 전후 **SHA-256 동일**을 assert(검수가 정본을 안 건드림).
- 단일소스 전제: "evidence 바꾸고 원고 stale" 류 mutation은 바꾼 값이 **근거 파일 하나에만** 있어야 stale이 드러난다. 다중소스 값은 피하고 단일소스 값을 골라 전제로 기록.

## 산출
- `cases.yaml`(케이스·사전선언 판정 계약) · 러너(`run_validation.py` 류) · `report.json`(기계 판정) · 실행기록(무엇을 돌렸고 gap 3종을 어떻게 닫았는지 + 정본 SHA 불변).

## 두 층의 연결
Layer 2가 "이 검사는 결함을 잡는다"를 보이면, Layer 1이 그 검사를 Lv3 증거로 **정당하게** 쓸 수 있다. Layer 1의 함정 (5)("verdict가 이유 없이 좋아지면 오염 의심")도 Layer 2의 음성 대조와 같은 정신이다 — 검증이 자기 자신도 검증한다.

---

# Layer 3 — 검사 카탈로그 + 증거 독립성 사다리 (실사용 방법 모음)

Layer 1의 "증거 우선순위 사다리"를 실제 방법으로 채운 것. **도구는 프로젝트마다 다르니 이 프로젝트에 있는 걸 먼저 찾고, 없으면 아래 패턴으로 재해석해 만든다.** 각 검사는 결정론(LLM 판단 없음)이라 Lv3 증거다.

## Lv3 결정적 검사 카탈로그 (원고·결과·주장에 두루)
| 검사 유형 | 무엇을 잡나 | 전이 패턴(핵심) |
|---|---|---|
| **숫자 드리프트** | 원고에만 있고 근거 문서엔 없는 수치(오타·구버전·지어냄) | 원고 소수치 정규식 추출 → 근거 코퍼스에 실재하나. **반올림 tolerance**(근거값의 half-unit 이내면 통과), DOI·연도·버전 배제, References 이후 제외 |
| **수정 보존(regression)** | 수정 중 헤드라인 숫자·인용이 조용히 바뀜/삭제 | 수정 전(git HEAD) baseline 대비 헤드라인 토큰(부호소수·과학표기·n=·[n]) 델타. exit 1이면 사람 |
| **본문→목록 인용결함** | 본문이 인용하는데 목록에 없거나 반대 | 양방향 대조(기존 인용검사와 방향 반대인 걸 별도로) |
| **서지 정합** | 인용 서지가 실제와 다름 | 외부 권위(CrossRef 등) 조회 대조. 네트워크 필요 → 실패 시 SKIP 표기 |
| **claim ledger 무결성** | claim 등급 무단 격상·한계 삭제·근거 밖 수치 | claim_level↔status(primary는 supported 요구)·limitations 수치가 원고 실재·key_number가 evidence 파일 실재. 등록값 substring 대조(Layer 2 mutation으로 이 검사가 진짜 잡는지 먼저 증명) |
| **재계산 diff-0** | 재계산이 커밋값과 다름(드리프트·비결정성) | 게이트 실행 후 산출물 git diff가 비어야 PASS('실행됨'≠'일치'). 게이트가 새로 더럽힌 파일만 복원(남의 미커밋 보호) |
| **인용문 훼손** | 인용 원문이 바뀜 | 원문 코퍼스와 substring 대조 |
| **다중 렌더 parity** | 정본에서 손으로 옮겨적은 표·산문·번역판 수치가 정본과 어긋남 | 정본(JSON/결과)↔markdown 표·산문·다른 언어판의 같은 수치 대조. 재계산과 **다른 실패모드**(옮겨적기·번역이 낡음). 탐지기는 불일치만 나열, 판정은 사람 |
| **비결정성 바닥 실측** | 확률적 요소(LLM 등)의 정상 변동을 회귀·드리프트로 오판 | 입력(프롬프트)을 고정한 반복 실행의 쌍별 비교로 필드별 불일치율을 **실측**하고, 그 바닥 위에서만 드리프트를 판정. 바닥을 재지 않고 확률적 출력에 exact match를 적용하면 무관한 실패가 회귀로 둔갑한다 |
| **replicate-tolerant golden set** | 확률적 출력의 실제 회귀(정상 변동과 구분해서) | 결정적 요소는 exact match 유지. 확률적 요소는 빌드 N회 다수결로 라벨을 고정하고 인용·식별자는 빌드 교집합으로 고정 → 체크 M회 중 한 번이라도 재현되면 통과, 고정 식별자가 어떤 체크 실행에도 안 나올 때만 실패 |
| **모델 입력 기록(감사 가능 grounding)** | "인용이 제공된 근거 안"처럼 참이어도 사후 검증이 불가한 프로세스 주장 | 모델에 보여준 식별자 목록을 로그로 남겨 인용을 사후 대조 가능하게. 기록이 없으면 결정적 하위 단계(예: 검색)만 재실행해 그 목록을 재구성하되, 재구성이 0 드리프트임을 먼저 확인하고 대조 |

## 미추적 수치의 삼분류 — 검사기 판정의 의미는 만든 사람이 정의한다

숫자 드리프트 검사가 내는 "미추적(orphan)"은 오류 판정이 아니라 **확인 경로 없음**이다. 이 구분을 흐리면 "원고에 오류가 N%"라는 잘못된 문장이 나온다. 미추적 수치는 성격이 다른 세 부류로 갈리므로 같은 잣대로 재지 않는다.

| 부류 | 성격 | 처리 방향 |
|---|---|---|
| **derived(파생값)** | 원자료를 가공한 값이라 원자료에 그 형태로 없음 | 외부 의존 없는 재계산 스크립트와 출력을 커밋해 추적 경로를 만든다 |
| **underspecified(분모 미병기)** | 본문 퍼센트에 분모가 없어 대조 불가 | "12.5% (4/32)"처럼 분모를 병기해 문장 자체를 검증 가능하게 쓴다 |
| **cited(인용값)** | 타 문헌에서 인용한 값이라 이 프로젝트 결과에 없는 것이 정상 | 인용 표기로 충분. 별도 목록으로 분리해 다른 잣대로 본다 |

운영 팁 둘. (1) 실행마다 수치 총수·추적률을 이력 표로 남긴다. 추적률이 이유 없이 100%로 뛰면 자기 출력이 근거 풀에 들어간 circular evidence부터 의심한다(Layer 1 함정 1·5와 같은 정신). (2) 관례값(유의수준 0.05 등)은 근거 파일에 없는 것이 정상이므로 대조에서 미리 빼 미추적 부풀림을 막는다.

## 증거 독립성 사다리 — 실사용 계단
- **Lv1 same-model 자기비평** (과제1 prompt loop): 질문 후보만, 사실 증명 아님.
- **Lv2 도구/환경 출력**: 스크립트 실측(exit·JSON·산출물).
- **Lv3 결정적 검사**(위 카탈로그): 재현적. Layer 2 mutation으로 공허하지 않음을 먼저 증명한 것만 신뢰.
- **Lv5 cross-model**: 다른 모델이 source만 읽고 적대 검증. same-model이 놓친 뉘앙스를 잡는다(실증됨). SUPPORT/CONTRADICT/UNSUPPORTED + locator.
- **Lv8 사람/advisor**: 더 강한 리뷰어 또는 책임 있는 사람의 승인. HOLD·note의 최종 판정자. 높은 영향 수정은 여기 없이는 승인 안 함.

## 한 번의 검증에서 층을 어떻게 조합하나
1. 대상·Tier 정하고 baseline SHA 동결(Layer 1 PHASE 0·1).
2. Lv3 검사 체인을 **러너로** 실행(원고 무수정, 리포트는 코퍼스 밖에). 각 검사는 Layer 2 mutation으로 사전에 '결함을 잡음' 증명.
3. 재계산 게이트는 diff-0로 대조.
4. 고영향 claim 1~3개는 Lv5 cross-model로 적대 검증.
5. HOLD·note는 자동수정 말고 Lv8(사람/advisor)로 이관. verdict가 재실행에서 이유없이 좋아지면 오염 의심.
6. 완료 보고에 baseline/final SHA·per-check verdict·cross-model 결과·correction 횟수·한계를 적는다.
