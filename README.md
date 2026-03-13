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
4. thin host-specific skill adapters

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

## Core Decisions In v1

1. One append-only markdown discussion file is the source of truth.
2. The protocol lives in [protocol/discuss-protocol-v1.md](/Users/restuta/Projects/prove.health/discuss-skill/protocol/discuss-protocol-v1.md).
3. The default template lives in [templates/discussion-template.md](/Users/restuta/Projects/prove.health/discuss-skill/templates/discussion-template.md).
4. Turn safety uses `reread-before-append` and fail-closed behavior, not lock files.
5. Blind briefs are optional, default `true`.
6. Git modes are `none`, `final_only`, and `every_turn`, with `final_only` as the default when a git repo is detected and the user does not specify otherwise.
7. Consensus and final summaries must stay concise and human-reviewable.

## File Layout

```text
discuss-skill/
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
      discuss-in/
        command.template.md
    codex/
      discuss/
        SKILL.template.md
      discuss-in/
        SKILL.template.md
  scripts/
    install.sh
```

## Install

Clone the repo, then run:

```bash
cd discuss-skill
./scripts/install.sh
```

By default this installs both Claude and Codex skill variants into:

1. `~/.claude/commands/discuss.md`
2. `~/.claude/commands/discuss-in.md`
3. `~/.codex/skills/discuss`
4. `~/.codex/skills/discuss-in`

More precisely:

1. Claude gets custom slash commands in `~/.claude/commands`
2. Codex gets skills in `~/.codex/skills`

The installer writes skill files with absolute paths back to this cloned repo, so the protocol stays single-source.

### Install only one host

```bash
./scripts/install.sh --claude
./scripts/install.sh --codex
```

## Usage

### Start a new discussion

Use the installed `discuss` skill in your host AI, give it:

1. a topic
2. a target markdown file path
3. optional participants
4. optional git mode

The skill should:

1. initialize the discussion file from the template
2. append the first substantive turn
3. leave clear prompts for the next reviewer

### Continue an existing discussion

Use the installed `discuss-in` skill with an existing discussion file.

The skill should:

1. reread the file
2. determine whether it should speak
3. append exactly one new turn if appropriate
4. leave prior content untouched

## What A Good Discussion Produces

At the end, a good discussion file should make it easy for a human to scan:

1. the key decision
2. why it won
3. the core contention points
4. how important conflicts were resolved
5. what still remains unresolved

## Example

See [examples/discussion-example.md](/Users/restuta/Projects/prove.health/discuss-skill/examples/discussion-example.md).
