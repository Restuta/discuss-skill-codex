# Discussion: Should discuss-skill v1 stay protocol-first?

---
protocol: discuss-protocol-v1
topic: "Should discuss-skill v1 stay protocol-first?"
mode: external
status: closed
blind_briefs: true
max_rounds: 5
git_mode: none
waiting_for: none
participants:
  - Codex
  - Claude
  - Human
---

> Adapted from a real isolated integration test run between Codex and Claude. Paths and timestamps were cleaned up for readability.

## Purpose

Check whether the project should stay protocol-first in v1, or introduce a shared runtime earlier.

## Rules

1. Append only.
2. Keep turns concise.
3. Final consensus should be easy for a human to scan.

## Current State

- Closed.
- Final consensus reached.

## Codex | research | 2026-03-13

### Position

v1 should stay protocol-first because the main job is coordination through one durable file, not runtime invention.

### Evidence

1. The protocol already defines the source of truth, append-only behavior, turn shapes, and failure handling.
2. A protocol-first v1 keeps adapters thin and makes it easier for different AIs or humans to participate without sharing tooling.

### Challenges

1. Protocol-first can feel underspecified if common operations become repetitive or error-prone in practice.
2. Without stronger tooling, teams may drift in formatting quality or skip safety steps like reread-before-append.

### Confidence

Moderate

### Questions For The Next Reviewer

1. Which real v1 workflows break down if the system remains protocol-first?
2. What is the smallest non-protocol addition that would solve those failures without bloating v1?

## Claude | research | 2026-03-13

### Position

Yes, v1 should stay protocol-first. The opportunity cost of adding runtime machinery now is higher than the cost of living with a slightly underspecified text protocol.

### Evidence

1. A plain markdown file with a known structure can be consumed by any AI, any editor, and any human with a text viewer.
2. The protocol already handles the hard coordination problem with append-only rules, reread-before-append, turn types, and round limits.
3. Adapter simplicity compounds: each new host only needs to read the file, parse frontmatter, and append a section.

### Challenges

1. Format drift is real without validation tooling.
2. Polling for turn changes is inelegant and may become annoying with more participants.

### Confidence

High

### Questions For The Next Reviewer

1. Is there a concrete v1 use case where protocol-first already fails in practice?
2. If one extra piece of tooling were added, should it be a linter, watcher, or something else?

## Codex | consensus | 2026-03-13

### Decision

v1 should stay protocol-first.

### Why this won

It keeps the source of truth simple, adapters thin, and cross-tool participation easy while deferring heavier machinery until real failures appear.

### Core contention points

1. install friction vs runtime consistency
2. simplicity vs future hardening
3. protocol discipline vs extra tooling

### Resolved conflicts

1. Runtime machinery was deferred because there was no demonstrated v1 failure it clearly solved.
2. The main weaknesses point toward lightweight tooling later, not a heavier core architecture now.

### Unresolved conflicts

1. The exact threshold for adding watcher or validator features later is still open.

### Confidence

High
