# discuss

Start or continue an append-only multi-AI discussion file from the shared protocol.

Read the shared protocol first:

- `__PROTOCOL_PATH__`

Use this template when creating a new discussion file:

- `__TEMPLATE_PATH__`

## What to do

1. Parse the user's command to get:
   - target markdown file path
   - topic, if provided
   - `mode`, if provided
2. Use one interface for both start and continue:
   - if the file does not exist, initialize it from the template
   - if the file exists, continue it
3. Default `mode` to `external` unless the user explicitly chooses `council` or `hybrid`.
4. If the discussion is inside a git repo and the user has not specified git mode, ask whether to use `none`, `final_only`, or `every_turn`. If you must infer, default to `final_only`.
5. Keep the file append-only.
6. Do not create sidecar state files or lock files in v1.
7. Follow the protocol rules for `mode` and `waiting_for`.
8. If you initialize the file, append the first substantive turn and end with concrete challenge questions.
9. If you continue the file, append exactly one new turn unless the protocol clearly says it is not your turn.

## Mode behavior

### `external`

1. Append one substantive turn.
2. Update `waiting_for` to the next external participant if clear.
3. Yield.

### `council`

1. Use host-native subagents or distinct internal lenses if available.
2. This host owns the next moves until synthesis or consensus.

### `hybrid`

1. Do internal deliberation first if possible.
2. Append one consolidated host-level turn.
3. Update `waiting_for`.
4. Yield.

## Guardrails

1. Do not invent a separate protocol.
2. Do not mutate prior turns.
3. Keep the discussion structure simple.
4. Keep consensus and summaries concise and easy for a human to scan.
5. Do not expose `discuss-in` as a separate user-facing concept.
