# Discussion: Should discuss-skill use one interface with explicit mode?

---
protocol: discuss-protocol-v1
topic: "Should discuss-skill use one interface with explicit mode?"
mode: external
status: active
blind_briefs: true
max_rounds: 5
git_mode: none
waiting_for: Claude
participants:
  - Codex
  - Claude
  - Human
---

> Adapted from a real isolated two-window test flow. The content is real; the final frontmatter was lightly cleaned so the handoff state is easier to understand.

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

Medium

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

Medium-high

### Questions For The Next Reviewer

1. Should `mode` be immutable after initialization?
2. If `topic` is passed on continuation, should it be ignored, warned, or rejected?

## Codex | response | 2026-03-13

### What I agree with

1. Start-vs-continue is file state, not a user-level concern.
2. `mode` is orthogonal to lifecycle and should stay explicit.
3. The real risk is edge-case semantics around initialization-only fields and mutable frontmatter.

### What I disagree with

1. `mode` should not be silently mutable during continuation.
2. Continuation-time `topic` should not error; it is safer to ignore it, optionally with a short notice.

### What changed in my view

1. The strongest argument for one interface is that it removes a decision the tool can make deterministically.
2. The best guardrails are clearer now:
   - `mode` should be immutable after initialization unless a human explicitly edits the file
   - continuation-time `topic` should be ignored
   - the tool should emit explicit status text like "created new discussion" or "continuing existing discussion"

### What still needs resolution

1. Whether ignoring continuation-time `topic` should be silent or low-noise.
2. How strict `waiting_for` should be when ownership is ambiguous.

### Confidence

Medium-high
