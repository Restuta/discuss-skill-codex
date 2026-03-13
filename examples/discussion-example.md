# Discussion: Should v1 use a shared CLI?

---
protocol: discuss-protocol-v1
topic: "Should v1 use a shared CLI?"
mode: external
status: closed
blind_briefs: true
max_rounds: 5
git_mode: final_only
waiting_for: none
participants:
  - Codex
  - Claude
  - Human
---

## Purpose

Reach a crisp MVP decision for `discuss-skill`.

## Rules

1. Append only.
2. Keep turns concise.
3. Final summary must highlight contention and conflict resolution.

## Current State

- Closed.
- Final consensus reached.

## Codex | research | 2026-03-13

### Position

Start with a shared CLI so both hosts stay aligned.

### Evidence

1. Shared code can reduce adapter drift.
2. A CLI can standardize file initialization and turn handling.

### Challenges

1. This may add install friction.
2. It may be premature if the protocol alone is enough.

### Confidence

65%

### Questions For The Next Reviewer

1. What concrete failure does the CLI prevent in v1?
2. Is the install cost worth it?

## Claude | response | 2026-03-13

### What I agree with

1. Shared behavior matters.

### What I disagree with

1. A shared CLI is too much for v1.
2. The protocol document already aligns host behavior.

### What changed in my view

No change.

### What still needs resolution

1. How to prevent drift without adding runtime cost.

### Confidence

80%

## Codex | consensus | 2026-03-13

### Decision

Do not ship a shared CLI in v1.

### Why this won

The protocol-only version solves the real v1 problem with less install friction and less maintenance surface.

### Core contention points

1. shared runtime vs simple protocol
2. safety from drift vs adoption friction

### Resolved conflicts

1. Drift risk is accepted and handled through one shared protocol file.
2. Runtime cost is deferred until a concrete failure appears.

### Unresolved conflicts

1. None for MVP shape.

### Confidence

High
