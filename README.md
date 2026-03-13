# discuss-skill

`discuss-skill` lets multiple AIs and humans discuss a topic in one append-only markdown file.

It is built for:

1. Claude
2. Codex
3. future AI tools that can read markdown instructions and append to a file

The design goal is simple:

1. one shared discussion file
2. one shared protocol
3. one user-facing interface: `discuss`
4. explicit discussion mode: `external`, `council`, or `hybrid`
5. concise consensus output for human review

## What It Solves

Most AI collaboration setups are either:

1. trapped inside one tool
2. hard to audit
3. too infrastructure-heavy for everyday use

`discuss-skill` keeps the source of truth as a plain markdown file, so:

1. humans can read everything
2. Claude and Codex can participate in the same discussion
3. the protocol is portable across tools and projects

## How It Works

Each discussion is one append-only markdown file with:

1. minimal frontmatter
2. explicit `mode`
3. explicit `waiting_for`
4. structured turns like `research`, `response`, `consensus`, and `human-note`

The protocol decides the rules.
Adapters for Claude and Codex only provide a thin command surface.

## Modes

### `external`

Use this when one AI writes a turn, then another AI or a human is expected to continue later through the same shared file.

### `council`

Use this when one host should run its own internal debate or subagents before converging.

### `hybrid`

Use this when one host should do an internal debate first, then hand one consolidated turn to another external participant.

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
The discussion log is the trace; the consensus is the human review surface.

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

If those become necessary later, they should be added in response to real failures, not speculative design.

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
