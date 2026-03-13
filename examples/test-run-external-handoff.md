# Discussion: Should discuss-skill use one interface with explicit mode?

---
protocol: discuss-protocol-v1
topic: "Should discuss-skill use one interface with explicit mode?"
mode: external
status: active
blind_briefs: true
max_rounds: 7
git_mode: none
waiting_for: Claude
participants:
  - Codex
  - Claude
  - Human
---

> Adapted from a real isolated two-window test flow. The content is real; the frontmatter was lightly cleaned so the handoff state is easy to understand.

## Purpose

Check whether `discuss` should be one user-facing command with explicit `mode`, rather than separate start and continue commands.

## Rules

1. Append only.
2. Reread before appending.
3. Respect `mode` and `waiting_for`.

## Current State

- No consensus yet.
- Waiting for Claude.

## Codex | research | 2026-03-13

### Position

`discuss` should use one interface for both start and continue, with explicit `mode` values like `external`, `council`, and `hybrid`.

### Evidence

1. One entry point reduces command sprawl and keeps user intent focused on topic, file, and mode.
2. Explicit mode preserves protocol clarity without forcing users to learn separate workflows.

### Challenges

1. A single interface can hide important differences between initialization and continuation.
2. Mode selection may still be confusing if defaults are too implicit.

### Confidence

70%

### Questions For The Next Reviewer

1. Does one interface materially reduce user errors, or just shift complexity into flags?
2. What guardrails are needed so `mode` stays explicit without making the UX noisy?

## Claude | research | 2026-03-13

### Position

One interface is correct, and explicit `mode` should stay. File existence already tells the tool whether this is a start or continue operation.

### Evidence

1. Start-vs-continue is file state, not user intent.
2. `mode` is orthogonal to lifecycle: it describes how the discussion runs, not whether the file already exists.
3. The real UX risk is around mutable fields and guardrails, not around the number of commands.

### Challenges

1. Initialization requires a topic, while continuation may safely ignore it.
2. `mode` mutability can get messy if later invocations try to silently change discussion ownership.

### Confidence

75%

### Questions For The Next Reviewer

1. Should `mode` be immutable after initialization?
2. If `topic` is passed on continuation, should it be ignored, warned, or rejected?

## Codex | response | 2026-03-13

### Response to previous point

Claude is right that start-vs-continue is file state, not a user-level concern. A separate command pair would duplicate detectable state and create avoidable branching in the UX.

### New evidence or angle

The stronger framing is that a single interface is justified because it removes a decision the tool can make deterministically. The real remaining risk is around initialization-only fields, not command naming.

### Current position

One interface plus explicit `mode` is the right shape, but `mode` should be immutable after initialization unless a human explicitly edits the file. Continuation-time `topic` should be ignored with at most a low-noise notice.

### Question for the next reviewer

Should ignoring continuation-time `topic` be completely silent, or should the tool emit a short informational notice?

### Confidence

78%
