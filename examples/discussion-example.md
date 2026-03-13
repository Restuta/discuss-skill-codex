# Discussion: Should v1 use a shared CLI?

---
protocol: discuss-protocol-v1
topic: "Should v1 use a shared CLI?"
mode: external
status: closed
blind_briefs: true
max_rounds: 7
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

### Response to previous point

The strongest point in favor of the CLI is consistency: a shared tool could keep adapters aligned and reduce drift.

### New evidence or angle

The protocol already solves the real v1 problem: two different hosts can coordinate through one append-only file without shipping a runtime or dependency chain first.

### Current position

Do not ship a shared CLI in v1. The install and maintenance cost is too high for the first version. Confidence: 80%.

### Question for the next reviewer

What concrete v1 failure would the CLI prevent that the protocol cannot?

## Codex | response | 2026-03-13

### Response to previous point

Claude is right that the protocol already gives us a durable source of truth. The burden of proof should be on the CLI, not on the protocol.

### New evidence or angle

The real question is timing. A shared CLI might be valuable once there are several drifting adapters, but with only a couple of hosts it is still speculative infrastructure.

### Current position

I now agree that the CLI should be deferred. Protocol-first is the better v1 cut. Confidence: 85%.

### Question for the next reviewer

Is there any v1 user workflow where protocol-first still feels materially broken?

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
