# Setup

This page is for the longer, practical setup details that do not belong in the top-level README.

## What Gets Installed

`discuss-skill` installs one `discuss` entry point per host:

1. Claude: `~/.claude/commands/discuss.md`
2. Codex: `~/.codex/skills/discuss/SKILL.md`

## Fast Install

From the repo root:

```bash
./scripts/install.sh
```

Install only one host if needed:

```bash
./scripts/install.sh --claude
./scripts/install.sh --codex
```

## Install Examples For Agents

### Claude

Fast path:

```bash
cd /path/to/discuss-skill-codex
./scripts/install.sh --claude
```

Manual install:

```bash
repo=/path/to/discuss-skill-codex
mkdir -p ~/.claude/commands
sed \
  -e "s#__PROTOCOL_PATH__#$repo/protocol/discuss-protocol-v1.md#g" \
  -e "s#__TEMPLATE_PATH__#$repo/templates/discussion-template.md#g" \
  "$repo/adapters/claude/discuss/command.template.md" \
  > ~/.claude/commands/discuss.md
```

### Codex

Fast path:

```bash
cd /path/to/discuss-skill-codex
./scripts/install.sh --codex
```

Manual install:

```bash
repo=/path/to/discuss-skill-codex
mkdir -p ~/.codex/skills/discuss
sed \
  -e "s#__PROTOCOL_PATH__#$repo/protocol/discuss-protocol-v1.md#g" \
  -e "s#__TEMPLATE_PATH__#$repo/templates/discussion-template.md#g" \
  "$repo/adapters/codex/discuss/SKILL.template.md" \
  > ~/.codex/skills/discuss/SKILL.md
```

## Other AI Environments

If your AI environment supports custom commands, skills, or reusable prompts:

1. create one command called `discuss`
2. point it at [../protocol/discuss-protocol-v1.md](../protocol/discuss-protocol-v1.md)
3. point it at [../templates/discussion-template.md](../templates/discussion-template.md)
4. make it follow the same start-or-continue rules

If your AI environment does not support installable commands:

1. give the AI [../protocol/discuss-protocol-v1.md](../protocol/discuss-protocol-v1.md)
2. give it [../templates/discussion-template.md](../templates/discussion-template.md)
3. ask it to behave as `discuss`

Generic start prompt:

```text
Read discuss-protocol-v1 and follow it exactly.
Create a new discussion file from the template.
Mode: external
Topic: Should we rewrite auth?
Write to: notes/auth-discussion.md
Append the first substantive turn and end with challenge questions.
```

Generic continue prompt:

```text
Read discuss-protocol-v1 and follow it exactly.
Continue this existing discussion file:
notes/auth-discussion.md
Respect mode and waiting_for.
Append exactly one new turn if appropriate.
Do not rewrite earlier content.
```

Minimum capability required:

1. read a markdown protocol file
2. read or create a markdown discussion file
3. append text without rewriting earlier sections

## Git Behavior

If the discussion file lives inside a git repo, `discuss-skill` can version the discussion like normal work.

Supported git modes:

1. `none`
2. `final_only`
3. `every_turn`

Default behavior:

1. if the tool can ask, it should ask once
2. if it must infer, it should default to `final_only`

Safety rules:

1. do not stage unrelated files
2. do not rewrite history
3. do not push automatically

## For Agents

README is not the protocol.

After installation, read these files next:

1. [../protocol/discuss-protocol-v1.md](../protocol/discuss-protocol-v1.md)
2. [../templates/discussion-template.md](../templates/discussion-template.md)
3. your installed host adapter
   Claude: `~/.claude/commands/discuss.md`
   Codex: `~/.codex/skills/discuss/SKILL.md`
