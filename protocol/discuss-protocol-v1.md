# discuss-protocol-v1

## 1. Goal

Use one append-only markdown file for a structured discussion between multiple AIs and optional human participants.

The goal is not to force agreement.
The goal is to produce:

1. better challenge and refinement than a single pass
2. a durable human-readable audit trail
3. a concise final summary with contention and conflict resolution

## 2. Source Of Truth

The discussion markdown file is the source of truth.

v1 intentionally does not use:

1. a shared CLI runtime
2. a database
3. a sidecar state file
4. a lock file

## 3. Safety Model

v1 uses `reread-before-append`.

Before adding a new turn, the participant must:

1. reread the latest file content
2. confirm the latest substantive turn still matches what it thinks it is replying to
3. append only if the file state still supports that turn

If the file changed unexpectedly, the participant must stop, reread, and reconsider.

Fail closed.
Do not guess.

## 4. Discussion File Requirements

### 4.1 Append-only

Never:

1. rewrite earlier turns
2. delete earlier turns
3. reorder earlier turns

Every change must be a new appended section.

### 4.2 Minimal frontmatter

Use a small frontmatter block at the top of the file:

```yaml
---
protocol: discuss-protocol-v1
topic: "<topic>"
mode: external
status: active
blind_briefs: true
max_rounds: 7
git_mode: none
waiting_for: next-participant
participants:
  - Codex
  - Claude
  - Human
---
```

Keep this minimal.
Do not turn the markdown file into a database.

### 4.3 Required top sections

The file should start with:

1. title
2. frontmatter
3. purpose
4. rules
5. topics to resolve
6. current state

## 5. Modes

Use one of these modes:

1. `external`
2. `council`
3. `hybrid`

### 5.1 `external`

Use this when the next substantive turn should come from another external AI or a human.

Behavior:

1. append one substantive turn
2. update `waiting_for`
3. yield

### 5.2 `council`

Use this when the current host is expected to run its own internal subagents or internal lenses.

Behavior:

1. the current host owns the next moves until synthesis or consensus
2. the shared file remains append-only
3. internal roles should be named clearly if they appear in the shared log

Recommended role naming:

1. `Codex-risk`
2. `Codex-value`
3. `Claude-risk`
4. `Claude-value`

### 5.3 `hybrid`

Use this when the current host should deliberate internally first, then hand one consolidated turn to another external participant.

Behavior:

1. internal council first
2. append one host-level turn to the shared file
3. update `waiting_for`
4. yield

## 6. Turn Types

Use only these turn types in v1:

1. `research`
2. `response`
3. `consensus`
4. `human-note`

Keep the heading simple:

```md
## Codex | research | 2026-03-13
## Claude | response | 2026-03-13
## Human | human-note | 2026-03-13
## Codex | consensus | 2026-03-13
```

## 7. Turn Body Shape

### 7.1 Research

Each `research` turn should usually contain:

1. `Position`
2. `Evidence`
3. `Challenges`
4. `Confidence`
5. `Questions for the next reviewer`

Prefer a calibrated percentage when practical, for example `70%`.

### 7.2 Response

Each `response` turn should usually contain:

1. `Response to previous point`
2. `New evidence or angle`
3. `Current position`
4. `Question for the next reviewer`
5. `Confidence`

Guidance:

1. `Response to previous point` should steel-man the strongest prior point before disagreeing or synthesizing.
2. `New evidence or angle` should add something meaningfully new when possible. If nothing new exists, say so explicitly.
3. `Current position` should show what changed, if anything.
4. `Question for the next reviewer` should drive the discussion toward resolution instead of producing generic commentary.
5. `Confidence` should preferably use a calibrated percentage, for example `70%`.

From the third `response` turn onward, a `response` turn may also include:

6. `Convergence assessment`

Allowed values:

1. `CONVERGING`
2. `PARALLEL`
3. `DIVERGING`
4. `DEADLOCKED`

For this rule, count only `response` turns in the file body. Do not count `research`, `consensus`, or `human-note` entries.

### 7.3 Consensus

Each `consensus` turn must be concise and optimized for human review.

It must include:

1. `Decision`
2. `Why this won`
3. `Core contention points`
4. `Resolved conflicts`
5. `Unresolved conflicts`
6. `Confidence`

### 7.4 Human-note

Human notes may add:

1. missing context
2. constraints
3. tie-break decisions
4. questions

## 8. `waiting_for`

`waiting_for` is a simple coordination hint, not a strict scheduler.

Examples:

1. `Codex`
2. `Claude`
3. `Human`
4. `next-participant`
5. `self`

Use it to make ownership obvious to a human reviewer and to help host adapters decide whether to speak.

## 9. Field Mutability

Treat these fields as initialization-time fields:

1. `topic`
2. `mode`
3. `participants`
4. `blind_briefs`
5. `max_rounds`
6. `git_mode`

Guidance:

1. `mode` should be treated as immutable after initialization unless a human explicitly edits the file
2. a continuation-time `topic` argument should be ignored rather than treated as an error
3. if a host ignores a continuation-time `topic`, it may emit a short low-noise notice

`waiting_for` and `status` may evolve during the discussion.

## 10. Blind Briefs

`blind_briefs` is optional and defaults to `true`.

When enabled:

1. each AI should produce its own first-pass analysis before relying on another participant's conclusions
2. after that, normal response turns may refer to prior turns

When disabled:

1. participants may directly enter response mode

Use `blind_briefs: false` for lighter, lower-stakes discussions.

## 11. Round Limits

Default `max_rounds` is `7`.

When the round cap is reached:

1. participants stop expanding the debate
2. the next substantive turn must be a synthesis or consensus attempt

This is simpler and more predictable than compression-heavy continuation logic.

## 12. Same-Model Lazy Consensus

If two participants are likely to share the same model biases, assign different lenses.

Suggested lenses:

1. `risk / cost / failure mode`
2. `value / upside / opportunity`
3. `simplicity / install friction`
4. `correctness / rigor / edge cases`

Do not use different lenses as theater.
Use them to force meaningful angle separation.

## 13. Git Modes

Supported git modes:

1. `none`
2. `final_only`
3. `every_turn`

Rules:

1. if the discussion is inside a git repo and the user has not specified a mode, ask once
2. if you must infer, default to `final_only`
3. never stage unrelated files
4. never rewrite git history automatically
5. do not push automatically in v1

## 14. Good Consensus Output

A good final result is snappy and easy for a human to scan.

It should make clear:

1. what decision was made
2. why it won
3. what the important disagreements were
4. how those disagreements were resolved
5. what remains unresolved

Keep it concise.
Do not turn the final summary into another full essay.

## 15. Unified Host Interface

Hosts should expose one user-facing entry point: `discuss`.

Start vs continue should be determined like this:

1. if the target file does not exist, initialize it
2. if the target file exists, continue it
3. if the target file is missing and no topic was given, ask or stop
4. never overwrite an existing discussion file

Recommended shapes:

1. `discuss --mode external "topic" file.md`
2. `discuss --mode council "topic" file.md`
3. `discuss --mode hybrid "topic" file.md`
4. `discuss file.md`

## 16. Adapter Responsibilities

Host adapters should only do host-specific things:

1. expose the skill name
2. gather the topic, file path, and mode
3. point the AI at this protocol
4. create or continue the discussion file
5. use host-native subagents only when the selected mode calls for it

Adapters should not invent their own competing protocol rules.

## 17. Non-Goals For v1

1. lock files
2. sidecar state
3. shared CLI runtime
4. network service
5. real-time sync
6. derived summary files

If these become necessary later, add them based on real failures, not speculative design.
