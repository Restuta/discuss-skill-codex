# discuss-skill

Let your AIs argue on paper.

`discuss-skill` gives Claude, Codex, or another AI one shared markdown file to think in together, disagree in, and eventually converge in, without losing the plot.

What you can do with it:

1. start a cross-AI discussion in one file
2. let different models challenge each other instead of replying in isolation
3. preserve the full discussion trace
4. end with a short decision summary, core contention points, and unresolved risks

The whole interface is intentionally tiny:

```text
/discuss --mode external "Should we rewrite auth?" notes/auth-discussion.md
/discuss notes/auth-discussion.md
```

One file.
One protocol.
One command surface: `discuss`.
Explicit mode: `external`, `council`, or `hybrid`.

That is basically the whole trick.

## Why This Exists

Most AI collaboration setups are either:

1. trapped inside one tool
2. hard to audit
3. too infrastructure-heavy for everyday use

`discuss-skill` keeps the source of truth as a plain markdown file, so:

1. humans can read everything
2. Claude and Codex can participate in the same discussion
3. the protocol is portable across tools and projects

No daemon.
No fancy coordination server.
No mystery state hiding somewhere else.
Just one discussion file you can open like a normal person.

## Quick Start

### If you use Claude

Install the Claude command:

```bash
./scripts/install.sh --claude
```

Then:

```text
/discuss --mode external "Should we rewrite auth?" notes/auth-discussion.md
/discuss notes/auth-discussion.md
```

### If you use Codex

Install the Codex skill:

```bash
./scripts/install.sh --codex
```

Then:

```text
discuss --mode external "Should we rewrite auth?" notes/auth-discussion.md
discuss notes/auth-discussion.md
```

### If you use another AI environment

You do not need a special runtime.

Give the AI:

1. [protocol/discuss-protocol-v1.md](protocol/discuss-protocol-v1.md)
2. [templates/discussion-template.md](templates/discussion-template.md)
3. a discussion file path

Then prompt it like this:

```text
Use discuss-protocol-v1.
If the file does not exist, create it from the template.
If it exists, continue it.
Mode is external.
Append exactly one new turn if appropriate.
Do not rewrite earlier content.
Write to: notes/auth-discussion.md
Topic: Should we rewrite auth?
```

That is the portability point of this project: any AI that can read files and append markdown can participate.

## How It Works

Each discussion is one append-only markdown file with:

1. minimal frontmatter
2. explicit `mode`
3. explicit `waiting_for`
4. structured turns like `research`, `response`, `consensus`, and `human-note`

The protocol decides the rules.
Adapters for Claude and Codex only provide a thin command surface.

In other words:

1. the file is the shared brain
2. the protocol is the etiquette
3. the adapters are just translators

## Modes

### `external`

Use this when one AI writes a turn, then another AI or a human is expected to pick it up later from the same file.

### `council`

Use this when one host should run its own little internal panel before converging.

### `hybrid`

Use this when one host should think internally first, then hand one consolidated turn to another external participant.

## Install

Clone the repo, then run:

```bash
cd discuss-skill-codex
./scripts/install.sh
```

This installs:

1. Claude command: `~/.claude/commands/discuss.md`
2. Codex skill: `~/.codex/skills/discuss/SKILL.md`

Install only one host if needed:

```bash
./scripts/install.sh --claude
./scripts/install.sh --codex
```

## Install Examples For Agents

If you are an agent, or a human setting this up for an agent, these are the concrete installation paths.

### Install for Claude agents

Fast path:

```bash
cd /path/to/discuss-skill-codex
./scripts/install.sh --claude
```

That creates:

```text
~/.claude/commands/discuss.md
```

Manual install example:

```bash
repo=/path/to/discuss-skill-codex
mkdir -p ~/.claude/commands
sed \
  -e "s#__PROTOCOL_PATH__#$repo/protocol/discuss-protocol-v1.md#g" \
  -e "s#__TEMPLATE_PATH__#$repo/templates/discussion-template.md#g" \
  "$repo/adapters/claude/discuss/command.template.md" \
  > ~/.claude/commands/discuss.md
```

### Install for Codex agents

Fast path:

```bash
cd /path/to/discuss-skill-codex
./scripts/install.sh --codex
```

That creates:

```text
~/.codex/skills/discuss/SKILL.md
```

Manual install example:

```bash
repo=/path/to/discuss-skill-codex
mkdir -p ~/.codex/skills/discuss
sed \
  -e "s#__PROTOCOL_PATH__#$repo/protocol/discuss-protocol-v1.md#g" \
  -e "s#__TEMPLATE_PATH__#$repo/templates/discussion-template.md#g" \
  "$repo/adapters/codex/discuss/SKILL.template.md" \
  > ~/.codex/skills/discuss/SKILL.md
```

### Install for other AI environments

If the environment supports custom commands, skills, or reusable prompts:

1. create one command called `discuss`
2. make it read [protocol/discuss-protocol-v1.md](protocol/discuss-protocol-v1.md)
3. make it use [templates/discussion-template.md](templates/discussion-template.md) for initialization
4. make it follow the same start-or-continue rules

If the environment does not support installable commands:

1. give the AI this README
2. give it [protocol/discuss-protocol-v1.md](protocol/discuss-protocol-v1.md)
3. give it [templates/discussion-template.md](templates/discussion-template.md)
4. ask it to behave as `discuss`

Minimum install contract for any agent:

1. read protocol file
2. read or create discussion markdown file
3. append exactly one turn without rewriting earlier content

## How To Use With Claude

After installation, use the custom command:

```text
/discuss --mode external "Should we rewrite auth?" notes/auth-discussion.md
```

To continue an existing discussion:

```text
/discuss notes/auth-discussion.md
```

Claude should:

1. create the file if it does not exist
2. continue it if it already exists
3. follow the shared protocol
4. respect `mode` and `waiting_for`

## How To Use With Codex

After installation, invoke the `discuss` skill in Codex with the same inputs:

```text
discuss --mode council "What architecture should we use?" notes/architecture.md
discuss notes/architecture.md
```

Codex should behave the same way:

1. initialize if missing
2. continue if present
3. respect `mode`
4. append exactly one turn unless the mode clearly allows internal ownership

## How To Use In Other AI Environments

This repo is intentionally protocol-first, so it should work outside Claude and Codex too.

If your AI environment supports custom commands, tools, skills, or templates:

1. create one command called `discuss`
2. point it at [protocol/discuss-protocol-v1.md](protocol/discuss-protocol-v1.md)
3. point it at [templates/discussion-template.md](templates/discussion-template.md)
4. make it follow the same start-or-continue rules

If your AI environment does not support custom commands:

1. open the protocol file
2. open the template file
3. give the AI the discussion file path
4. tell it whether this is a new or existing discussion
5. ask it to append one turn under the protocol

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

Minimum capability required from the AI environment:

1. read a markdown protocol file
2. read or create a markdown discussion file
3. append text without rewriting earlier sections

If it can do those three things, it can play.

## Recommended Workflow

For cross-model discussion:

1. start with `--mode external`
2. let the first AI write the opening turn
3. open the same file in the second AI
4. alternate through the same file until consensus or explicit no-consensus

For same-host internal debate:

1. start with `--mode council`
2. let the host run internal lenses or subagents
3. append only the durable shared log output

## Consensus Output

A good final consensus should make it easy for a human to scan:

1. what decision was made
2. why it won
3. the core contention points
4. how key conflicts were resolved
5. what remains unresolved

Keep it short.
The log is the full movie.
The consensus is the trailer a busy human actually watches.

## Project Docs

Current project docs:

1. [README.md](README.md)
   Human-facing overview, install, usage, workflow, and agent notes.
2. [protocol/discuss-protocol-v1.md](protocol/discuss-protocol-v1.md)
   Source of truth for file format, modes, turn types, and behavior rules.
3. [templates/discussion-template.md](templates/discussion-template.md)
   Starter file for new discussions.
4. [examples/discussion-example.md](examples/discussion-example.md)
   Small concrete example of a completed discussion.
5. [adapters/claude/discuss/command.template.md](adapters/claude/discuss/command.template.md)
   Claude-specific command surface.
6. [adapters/codex/discuss/SKILL.template.md](adapters/codex/discuss/SKILL.template.md)
   Codex-specific skill surface.
7. [scripts/install.sh](scripts/install.sh)
   Installer for Claude and Codex.

Recommended future docs:

1. `docs/design-notes.md`
   Why the protocol chose one interface and explicit mode.
2. `docs/validation-rules.md`
   Lint and validation guidance for later hardening.
3. `docs/examples/`
   More examples for `external`, `council`, and `hybrid`.

## Current Limits

v1 intentionally does not include:

1. a shared runtime engine
2. a lock file
3. a database
4. real-time sync
5. a derived summary file

If those become necessary later, they should be added in response to real failures, not because we got carried away in a productive-sounding architecture conversation.

## For Agents

Read this section after the human-facing sections above.

### Source of truth

1. The discussion markdown file is the source of truth.
2. The protocol is defined in [protocol/discuss-protocol-v1.md](protocol/discuss-protocol-v1.md).
3. Do not invent competing local rules.

### Start vs continue

1. If the target file does not exist, initialize it.
2. If the target file exists, continue it.
3. Never overwrite an existing discussion file.

### Field mutability

Treat these as initialization-time fields:

1. `topic`
2. `mode`
3. `participants`
4. `blind_briefs`
5. `max_rounds`
6. `git_mode`

Rules:

1. `mode` is immutable after initialization unless a human explicitly edits the file.
2. If a caller passes `topic` while continuing an existing file, ignore it. A short low-noise notice is acceptable.
3. `waiting_for` and `status` may evolve during the discussion.

### Append-only rule

Never:

1. rewrite earlier turns
2. delete earlier turns
3. reorder earlier turns

Always reread before appending.
If the file changed unexpectedly, fail closed and reassess.

### Human review priority

Consensus output should optimize for fast human review:

1. `Decision`
2. `Why this won`
3. `Core contention points`
4. `Resolved conflicts`
5. `Unresolved conflicts`
6. `Confidence`
