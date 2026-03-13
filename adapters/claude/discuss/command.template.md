# discuss

Start a new append-only multi-AI discussion file from the shared protocol.

Read the shared protocol first:

- `__PROTOCOL_PATH__`

Use this template when creating a new discussion file:

- `__TEMPLATE_PATH__`

## What to do

1. Parse the user's command to get the topic and target markdown file path.
2. Create the target discussion markdown file from the template if it does not exist.
3. Fill in the topic, questions, participants, and initial state.
4. If the discussion is inside a git repo and the user has not specified git mode, ask whether to use `none`, `final_only`, or `every_turn`. If you must infer, default to `final_only`.
5. Append the first substantive turn as this host AI.
6. Keep the file append-only.
7. Do not create sidecar state files or lock files in v1.
8. End the first turn with concrete challenge questions for the next reviewer.

## Guardrails

1. Do not invent a separate protocol.
2. Do not mutate prior turns.
3. Keep the discussion structure simple.
4. Keep consensus and summaries concise and easy for a human to scan.
