# Design Notes

This file records a few deliberate v1 choices that came up during review.

## 1. Why `status` stays simple

`discuss-skill` currently uses a coarse status model:

1. `active`
2. `closed`

Why:

1. the append-only body already carries most of the useful substate
2. `waiting_for` is the real ownership signal during active discussions
3. richer state machines add more ways for adapters to drift or become inconsistent

For v1, we prefer:

1. simple top-level state
2. richer detail in the body
3. explicit handoff through `waiting_for`

We may revisit richer states later if automation needs them badly enough.

## 2. Turn numbers are optional, not the trust boundary

Turn numbers are useful for navigation.
They are not useful as the core correctness mechanism.

Why:

1. an agent can still take the wrong turn while incrementing a number correctly
2. numbering does not actually prevent incorrect ownership
3. mandatory numbering adds one more thing agents can get wrong

The real trust boundary in v1 is:

1. `mode`
2. `waiting_for`
3. reread-before-append
4. fail closed if the file changed unexpectedly

If turn numbers appear in examples or future export views, treat them as navigation aids, not authoritative synchronization.

## 3. Confidence should be calibrated, not theatrical

The goal of confidence is not fake precision.
The goal is better epistemic hygiene.

For v1:

1. research and response turns should prefer percentage-style confidence when practical
2. consensus can keep simpler labels like `High`, `Medium`, `Low`

This is a style preference, not a mathematical guarantee.

## 4. Why install remains repo-linked

Claude-style one-line raw installs are attractive, but the current repo-linked install has one important advantage:

1. the installed adapter always knows exactly where the shared protocol and template live

Tradeoff:

1. more setup friction
2. less ambiguity about the active source of truth

For now, `discuss-skill-codex` prefers:

1. one shared repo checkout
2. install-time path substitution
3. protocol and template staying single-source

## 5. Why the example set looks the way it does

The current examples are meant to cover:

1. small synthetic consensus
2. real test-derived consensus
3. real handoff between participants
4. realistic deadlock

That is enough for v1.

If another example is added later, the most valuable one would be a longer multi-round consensus example, not more tiny synthetic ones.
