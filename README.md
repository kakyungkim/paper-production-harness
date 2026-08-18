# Paper-production harness — starter kit

*Designed by Ka-Kyung Kim, 2026 — a reusable paper-production harness, contributed as a scaffold.*
Licensed **CC BY 4.0** (see [LICENSE](LICENSE)).

A **topic-agnostic scaffold** for running a research paper from analysis to talk as a repeatable
multi-agent harness: a roster of reusable agents (methodology, literature, writing, critic, venue-reviewer,
presenter, design), an orchestrator that drives them in order with partial re-runs, an artifact
contract so stages hand off through files (not chat), and a two-stage review + deterministic verify
discipline before anything ships — with a mutation layer that checks the gates themselves catch defects.
The only topic-coupled piece is a single pluggable analysis slot.

## Layout
The repo mirrors where things land in your team repo, so it is obvious at a glance what is an agent
and what is a Skill. Files ending in `.template.md` still need `<FILL: …>` completion; everything
else is reused as-is.

```
agents/                                -> <repo>/.claude/agents/
skills/paper-production-orchestrator/  -> <repo>/.claude/skills/paper-production-orchestrator/
skills/verify-harness/                 -> <repo>/.claude/skills/verify-harness/
hooks/git-drift-check.sh               -> <repo>/.claude/hooks/  (register in settings.json SessionStart)
schemas/critic_report.schema.template.json -> <repo>/schemas/
templates/HARNESS.template.md          -> <repo>/docs/HARNESS.md
templates/CLAUDE-routing.template.md   -> paste into <repo>/CLAUDE.md
```

## How to use (keep it clean)

```bash
./install.sh /path/to/your/team-repo
```

That copies the agents and the orchestrator Skill into the repo's `.claude/`, drops the lab map at
`docs/HARNESS.md`, stages the routing block, and then **prints every `<FILL: …>` placeholder you
still have to complete**. Copying by hand works too — the arrows above are the whole mapping.

Then:

1. **Fill every `<FILL: …>` placeholder IN THE TEAM ENVIRONMENT** (paths, result files, your
   headline/framing stance, verify-gate command, affiliation). Do this in the team repo, not here.
2. **Name your `<DOMAIN_ANALYSIS_AGENT>`** — the one topic-specific slot (see below).
3. **Paste the routing block** from `.claude/CLAUDE-routing.to-paste.md` into your `CLAUDE.md`, then
   delete the staged file.
4. Do **NOT** put any of this in `~/.claude/` — that mixes contexts across projects. Keep it
   project-scoped to the team repo.

## The pluggable slot
Everything except one role is reused as-is. The team supplies **one** topic-specific agent,
`<DOMAIN_ANALYSIS_AGENT>` — the analysis/experiment agent that runs your domain's pipeline, eval,
and statistics and writes the result files. (Optionally a `<DOMAIN_VERIFIER_AGENT>` for provisional
adjudication of borderline cases.) The rest — methodology, literature-scout, novelty-strategist,
manuscript-writer, paper-critic, venue-reviewer, presenter, design, and the orchestrator — is the reusable
connective tissue and does not change with the topic.

## File manifest
| File | Purpose | Reuse |
| --- | --- | --- |
| `agents/research-methodologist.md` | hypothesis/contribution + rigor & leakage audit | reuse as-is |
| `agents/literature-scout.md` | prior-art discovery + honest positioning + related work | reuse as-is |
| `agents/novelty-strategist.md` | scoop check + differentiated angles | reuse as-is |
| `agents/paper-critic.md` | internal adversarial review + figure visual QA | reuse as-is |
| `agents/paper-orchestrator.md` | plans (does not execute) a multi-agent workflow | reuse as-is |
| `agents/presenter.md` | manuscript → slide deck / talk | fill paths |
| `agents/design.md` | logos/icons/brand & figure aesthetics (SVG+PNG) | reuse as-is |
| `agents/manuscript-writer.template.md` | preprint/journal/blog prose + figures | **fill required** |
| `skills/paper-production-orchestrator/SKILL.template.md` | entry-point Skill: drives the loop, partial re-runs | **fill required** |
| `skills/verify-harness/SKILL.template.md` | verification Skill: AKM fact-check + mutation (verify the gates) + fail-closed + check catalog / independence ladder | reuse as-is (self-contained) |
| `hooks/git-drift-check.sh` | SessionStart branch ahead/behind early warning (never blocks) | reuse as-is (set `DRIFT_BASE`) |
| `schemas/critic_report.schema.template.json` | critic report as a schema-checked artifact: required fields, status enum, evidence-required, reviewer≠owner | fill check names |
| `templates/HARNESS.template.md` | lab roster / org chart / per-agent JDs | **fill required** |
| `templates/CLAUDE-routing.template.md` | routing table + artifact contract to paste into `CLAUDE.md` | **fill required** |
| `install.sh` | copies everything to the right paths, lists remaining `<FILL: …>` | run once |
| `CLAUDE-routing.template.md` | NL routing + artifact-contract tables for CLAUDE.md | **fill required** |
| `DESIGN_NOTES.md` | rationale: why the harness is built this way | reuse as-is (reference) |
| `README.md` / `LICENSE` | this file + CC BY 4.0 note | reference |

## IP / provenance
This kit carries **only generic methodology and engineering best-practice** — agent roles, an
orchestration pattern, an artifact contract, and review/verify discipline. It contains **no
proprietary data, no domain-specific logic, and no employer content**; all topic-specific material
has been replaced by `<FILL: …>` placeholders and a pluggable analysis slot. Contributed by
Ka-Kyung Kim under **CC BY 4.0** — reuse and adapt freely, keep the attribution.

## Pre-handoff checklist
Before sharing the kit, confirm it is free of any source-project traces:

```bash
# --exclude=README.md skips this file itself (the pattern below necessarily names the
# source-project terms; that QA command is the only place they appear in the kit).
grep -rinE "variant|VeriVar|somatic|Horak|cohort|VICC|oncogenic|cBioPortal|CIViC|Macrogen|Cytogen|kakyung|STUDY_SUMMARY" docs/paper-harness-template/ --exclude=README.md
# must return ZERO hits
```

- [ ] grep above returns zero hits (no topic/company/personal traces).
- [ ] every `<FILL: …>` placeholder is filled in the team environment.
- [ ] `<DOMAIN_ANALYSIS_AGENT>` is named and its agent file exists in the team repo.
- [ ] the verify-gate command actually recomputes the headline numbers.
- [ ] nothing was placed in `~/.claude/` (project-scoped only).
- [ ] the attribution line is present in README, DESIGN_NOTES, and HARNESS.
