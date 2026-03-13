# discuss-skill

Let your AIs argue on paper. ✨

`discuss-skill` gives Claude, Codex, or another AI one shared markdown file to think in together, disagree in, and eventually converge in, without losing the plot.

What you get:

1. one append-only discussion file
2. one shared protocol
3. one command surface: `discuss`
4. a concise final consensus for humans

Use it in three ways:

1. `external`
   Two external AIs take turns in the same file.
2. `council`
   One AI runs its own internal subagents or internal debate.
3. `hybrid`
   One AI debates internally first, then hands a consolidated turn to another external participant.

Install rule:

1. if two external AIs will participate, install it in both
2. if you are using two windows of the same AI, install it once in that AI environment
3. if you are using `council`, install it only in the host that will run the internal debate

## Tiny Interface

```bash
/discuss --mode external "Should we rewrite auth?" notes/auth-discussion.md
/discuss notes/auth-discussion.md
```

That is basically the whole trick.

In practice:

```bash
# Agent A window
/discuss --mode external "Should we rewrite auth?" notes/auth-discussion.md

# Agent B window
/discuss notes/auth-discussion.md

# If Agent A needs to resume after an interruption
/discuss notes/auth-discussion.md
```

Keep taking turns in the same `file.md`.
When the discussion reaches consensus, read it in that same file.

Important nuance:

1. the protocol is designed for automatic turn-taking if your host supports loops, automations, or watch-style reruns
2. `discuss file.md` is also the safe resume command if a discussion is interrupted
3. v1 does not ship one universal background watcher for every AI environment

So the intended flow is:

1. automatic if your host can keep calling `discuss file.md`
2. manual resume if it cannot, or if the discussion gets interrupted

That means:

1. `Claude + Codex` external discussion: install in Claude and Codex
2. `Claude + Claude` or `Codex + Codex` external discussion: install once in that environment, open two windows
3. `council` mode: one AI can do the whole thing internally

## Why It Exists

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

## Why This Helps 🧪

This is not just a cute workflow gimmick.
There is real research behind the idea that multiple reasoning paths or debating agents can improve outcomes when the process is structured well.

Short version:

1. multi-agent debate can help reduce bad answers and hallucination-like failures
2. multiple reasoning paths can improve reasoning accuracy
3. adaptive debate can keep the gains without wasting as much compute

Primary sources:

1. [Improving Factuality and Reasoning in Language Models through Multiagent Debate](https://arxiv.org/abs/2305.14325)
   Includes the result that debate helped by "reducing fallacious answers and hallucinations."
2. [Self-Consistency Improves Chain of Thought Reasoning in Language Models](https://arxiv.org/abs/2203.11171)
   Reports gains including "GSM8K (+17.9%)" from multiple reasoning paths.
3. [Debate Only When Necessary: Adaptive Multiagent Collaboration for Efficient LLM Reasoning](https://arxiv.org/abs/2504.05047)
   Shows adaptive debate can improve efficiency "by up to six times."

Longer notes live in [docs/research.md](docs/research.md).

## Quick Start

### Claude

```bash
./scripts/install.sh --claude
/discuss --mode external "Should we rewrite auth?" notes/auth-discussion.md
```

### Codex

```bash
./scripts/install.sh --codex
discuss --mode external "Should we rewrite auth?" notes/auth-discussion.md
```

### Other AI environments

Give the AI:

1. [protocol/discuss-protocol-v1.md](protocol/discuss-protocol-v1.md)
2. [templates/discussion-template.md](templates/discussion-template.md)
3. the target discussion file path

Then tell it:

```text
Use discuss-protocol-v1.
If the file does not exist, create it from the template.
If it exists, continue it.
Mode is external.
Append exactly one new turn if appropriate.
Do not rewrite earlier content.
```

## Modes

1. `external`
   One AI writes, another AI or human picks it up later.
2. `council`
   One host runs its own internal debate first.
3. `hybrid`
   One host debates internally, then hands a consolidated turn to another external participant.

## Git

If the discussion file lives inside a git repo, `discuss-skill` can use:

1. `none`
2. `final_only`
3. `every_turn`

If it must infer a default, it should use `final_only`.
It should not stage unrelated files, rewrite history, or push automatically.

## Example Discussions

1. [examples/discussion-example.md](examples/discussion-example.md)
   Small synthetic example.
2. [examples/test-run-protocol-first.md](examples/test-run-protocol-first.md)
   Real test-derived example with final consensus.
3. [examples/test-run-external-handoff.md](examples/test-run-external-handoff.md)
   Real test-derived example showing handoff between participants.

## Read Next

1. [docs/setup.md](docs/setup.md)
   Install details, agent install examples, other AI environments, and git behavior.
2. [protocol/discuss-protocol-v1.md](protocol/discuss-protocol-v1.md)
   The actual source of truth.
3. [templates/discussion-template.md](templates/discussion-template.md)
   Starter file for new discussions.
4. [docs/research.md](docs/research.md)
   Short research notes and primary-source links.

## For Agents

README is the overview, not the protocol.

After install, read:

1. [protocol/discuss-protocol-v1.md](protocol/discuss-protocol-v1.md)
2. [templates/discussion-template.md](templates/discussion-template.md)
3. your installed host adapter
