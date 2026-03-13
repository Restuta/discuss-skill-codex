# Discussion: Should we migrate from REST to GraphQL for the patient-facing API?

---
protocol: discuss-protocol-v1
topic: "Should we migrate from REST to GraphQL for the patient-facing API?"
mode: external
status: closed
blind_briefs: true
max_rounds: 5
git_mode: none
waiting_for: none
participants:
  - Claude
  - Codex
  - Human
---

> Adapted from a real-style deadlock discussion. This is here on purpose: a good discussion system should be able to end with "the human needs to decide" instead of forcing fake consensus.

## Purpose

Decide whether a patient-facing API should migrate from REST to GraphQL now, later, or not at all.

## Rules

1. Append only.
2. Keep turns concise.
3. Deadlock is allowed if the real crux depends on missing business context.

## Current State

- Closed.
- Deadlock reached.
- Human decision needed.

## Claude | research | 2026-03-13

### Position

Migrating to GraphQL right now is too risky.

### Evidence

1. The migration scope is large relative to team size and current launch pressure.
2. The team has limited GraphQL production experience.
3. Dual-running REST and GraphQL would create operational and observability overhead.

### Challenges

1. The current mobile UX likely suffers from multiple REST calls per screen.
2. GraphQL may be the correct long-term direction anyway.

### Confidence

Moderate-high

### Questions For The Next Reviewer

1. Is the mobile pain urgent enough to justify migration risk now?
2. Is there a lower-risk middle path?

## Codex | research | 2026-03-13

### Position

GraphQL is likely the right direction, but I am not yet sure the migration should happen immediately.

### Evidence

1. GraphQL could reduce round-trips and improve mobile performance.
2. A single schema could serve multiple future consumers better than many ad hoc REST shapes.
3. Type generation and frontend autonomy are real advantages.

### Challenges

1. Migration timing may be wrong even if the destination is right.
2. The cost of running REST and GraphQL side-by-side could be underweighted.

### Confidence

Moderate

### Questions For The Next Reviewer

1. Would an intermediate aggregation/BFF layer solve the worst UX pain now?
2. What is the cost of waiting six months?

## Claude | response | 2026-03-13

### What I agree with

1. GraphQL probably is the long-term direction.
2. The strongest pro-GraphQL argument is user-facing performance plus future flexibility.

### What I disagree with

1. I do not think those benefits are enough to justify pre-launch migration risk.
2. I would rather solve immediate UX pain with a smaller step than change the API architecture now.

### What changed in my view

1. The real disagreement is no longer "GraphQL good or bad."
2. The real disagreement is timing and appetite for launch-period risk.

### What still needs resolution

1. Whether current mobile pain is materially affecting retention.
2. Whether a BFF or aggregation layer is acceptable "throwaway" work.

### Confidence

Moderate

## Codex | response | 2026-03-13

### What I agree with

1. The timing question matters more than the technology preference.
2. A smaller intermediate step may be more realistic given current team capacity.

### What I disagree with

1. I still think "wait entirely" may underprice the compounding cost of staying on the current REST shape.
2. I am less convinced than Claude that a BFF is harmless temporary work.

### What changed in my view

1. I now think the technical tradeoffs are understood well enough.
2. The remaining disagreement is mainly business context, not architecture mechanics.

### What still needs resolution

1. Are growth targets high enough that current UX friction is unacceptable?
2. Will the team actually have more capacity later, or is "migrate later" wishful thinking?

### Confidence

Moderate

## Claude | consensus | 2026-03-13

### Decision

Deadlock. Both sides agree GraphQL is plausible long-term, but the timing decision depends on product priorities and business constraints that are not present in the discussion.

### Why this won

The technical debate narrowed the crux correctly: this is not mainly a protocol or API-style argument anymore. It is a business-priority argument.

### Core contention points

1. migration risk now vs. compounding cost later
2. BFF-now pragmatism vs. throwaway-work concern
3. unknown impact of current UX pain on retention and growth

### Resolved conflicts

1. Both sides converged that GraphQL is not obviously wrong.
2. Both sides converged that the real disagreement is timing, not raw technical feasibility.

### Unresolved conflicts

1. How urgent the UX problem really is
2. Whether future team capacity is likely enough to make "later" realistic

### Confidence

Medium
