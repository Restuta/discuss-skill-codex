---
name: discuss
description: Start a new append-only multi-AI discussion file from the shared protocol. Use when the user wants to initialize a fresh discussion log, seed the first turn, and invite another AI or human to challenge the topic.
---

# discuss

Read the shared protocol first:

- `__PROTOCOL_PATH__`

Use this template when creating a new discussion file:

- `__TEMPLATE_PATH__`

## What to do

1. Create the target discussion markdown file from the template.
2. Fill in the topic, questions, participants, and initial state.
3. If the discussion is inside a git repo and the user has not specified git mode, ask whether to use `none`, `final_only`, or `every_turn`. If you must infer, default to `final_only`.
4. Append the first substantive turn as this host AI.
5. Keep the file append-only.
6. Do not create sidecar state files or lock files in v1.
7. Keep the initial turn useful for another reviewer by ending with concrete challenge questions.

## Output expectations

The created file should:

1. be human-readable
2. be easy for another AI to continue
3. follow the protocol closely

## Guardrails

1. Do not invent a separate protocol.
2. Do not mutate prior turns.
3. Keep the discussion structure simple.
