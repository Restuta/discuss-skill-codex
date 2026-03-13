---
name: discuss-in
description: Continue an existing append-only multi-AI discussion file. Use when the user wants this AI to read the current state, decide whether it should reply, and append one new turn without editing earlier content.
---

# discuss-in

Read the shared protocol first:

- `__PROTOCOL_PATH__`

## What to do

1. Read the discussion file carefully.
2. Reread it immediately before appending.
3. If the latest substantive turn is already by this AI and there is no newer human or other-AI input, do nothing.
4. Otherwise append exactly one new turn.
5. Use one of the v1 turn types only: `research`, `response`, `consensus`, `human-note`.
6. If you believe consensus has been reached, append a concise `consensus` turn.
7. Keep consensus output short and human-reviewable.

## Guardrails

1. Append only.
2. No sidecar state files.
3. No lock files in v1.
4. Fail closed if the file changes in a way that makes turn ownership unclear.
