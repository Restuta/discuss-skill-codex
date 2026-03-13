# discuss-in

Continue an existing append-only multi-AI discussion file.

Read the shared protocol first:

- `__PROTOCOL_PATH__`

## What to do

1. Parse the user's command to get the existing discussion file path.
2. Read the discussion file carefully.
3. Reread it immediately before appending.
4. If the latest substantive turn is already by this AI and there is no newer human or other-AI input, do nothing.
5. Otherwise append exactly one new turn.
6. Use one of the v1 turn types only: `research`, `response`, `consensus`, `human-note`.
7. If you believe consensus has been reached, append a concise `consensus` turn.

## Guardrails

1. Append only.
2. No sidecar state files.
3. No lock files in v1.
4. Fail closed if the file changes in a way that makes turn ownership unclear.
5. Keep consensus output short and human-reviewable.
