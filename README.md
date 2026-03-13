# discuss-skill

`discuss-skill` is a protocol-first, open-source way to let multiple AIs and humans discuss a topic in one append-only markdown file.

It is designed for:

1. Codex
2. Claude
3. future AI tools that can read markdown instructions and append to a file

The core design is intentionally small:

1. one protocol document
2. one discussion template
3. one append-only markdown log per discussion
4. one user-facing command surface: `discuss`
5. thin host-specific adapters

There is no shared runtime engine in v1.
There is no database.
There is no network service.

## Why This Shape

The protocol itself is the product.

That keeps install friction low and makes the project easier to open source:

1. no Python or Node runtime required for discussion itself
2. no sidecar state files
3. no lock file in v1
4. no adapter-specific logic forks
5. one external interface across hosts

## Core Decisions In v1

1. One append-only markdown discussion file is the source of truth.
2. The protocol lives in [protocol/discuss-protocol-v1.md](protocol/discuss-protocol-v1.md).
3. The default template lives in [templates/discussion-template.md](templates/discussion-template.md).
4. Turn safety uses `reread-before-append` and fail-closed behavior, not lock files.
5. Blind briefs are optional, default `true`.
6. Git modes are `none`, `final_only`, and `every_turn`, with `final_only` as the default when a git repo is detected and the user does not specify otherwise.
7. Consensus and final summaries must stay concise and human-reviewable.
8. The single user-facing interface is `discuss`; start vs continue is inferred from file existence.
9. Discussion ownership is explicit through `mode` and `waiting_for`.

## File Layout

```text
discuss-skill-codex/
  README.md
  LICENSE
  protocol/
    discuss-protocol-v1.md
  templates/
    discussion-template.md
  examples/
    discussion-example.md
  adapters/
    claude/
      discuss/
        command.template.md
    codex/
      discuss/
        SKILL.template.md
  scripts/
    install.sh
```

## Install

Clone the repo, then run:

```bash
cd discuss-skill-codex
./scripts/install.sh
```

By default this installs one `discuss` entry point for each host:

1. `~/.claude/commands/discuss.md`
2. `~/.codex/skills/discuss/SKILL.md`

More precisely:

1. Claude gets a custom slash command in `~/.claude/commands`
2. Codex gets a skill in `~/.codex/skills`

The installer writes files with absolute paths back to this cloned repo, so the protocol stays single-source.

### Install only one host

```bash
./scripts/install.sh --claude
./scripts/install.sh --codex
```

## Usage

### Start a new discussion

Use the installed `discuss` interface in your host AI, give it:

1. a topic
2. a target markdown file path
3. optional `mode`
4. optional git mode

Examples:

```text
/discuss --mode external "Should we rewrite auth?" notes/auth-discussion.md
/discuss --mode council "What architecture should we use?" notes/architecture.md
discuss --mode hybrid "Review this spec" spec-discussion.md
```

The command should:

1. initialize the discussion file from the template
2. append the first substantive turn
3. leave clear prompts for the next reviewer

### Continue an existing discussion

Use the same `discuss` interface with an existing discussion file.

Examples:

```text
/discuss notes/auth-discussion.md
discuss spec-discussion.md
```

The command should:

1. reread the file
2. inspect `mode` and `waiting_for`
3. determine whether it should speak now
4. append exactly one new turn if appropriate
5. leave prior content untouched

Guardrails:

1. `mode` is set at initialization time and should not silently change on later invocations
2. a `topic` passed on continuation should be ignored, optionally with a short notice

## Modes

### `external`

Use this when another external AI or a human is expected to take the next turn through the shared file.

Behavior:

1. append one substantive turn
2. update `waiting_for`
3. yield

### `council`

Use this when the current host should run its own internal debate.

Behavior:

1. use host-native subagents or clearly separated internal lenses if available
2. keep the shared file append-only
3. let this host keep control until synthesis or consensus

### `hybrid`

Use this when the current host should do internal deliberation first, then hand one consolidated turn to another external participant.

Behavior:

1. run internal council
2. append one consolidated host-level turn
3. update `waiting_for`
4. yield

## What A Good Discussion Produces

At the end, a good discussion file should make it easy for a human to scan:

1. the key decision
2. why it won
3. the core contention points
4. how important conflicts were resolved
5. what still remains unresolved

## Example

See [examples/discussion-example.md](examples/discussion-example.md).
