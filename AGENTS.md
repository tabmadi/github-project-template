# Agent guide

Tool-agnostic guide for any coding agent (Codex, Cursor, Claude Code, or another) working in this repo. `AGENTS.md` is the one standard: an agent either reads it or it does not — the repo carries no per-tool shim files (`CLAUDE.md`, `.cursor/rules/`, etc.). A tool that ignores `AGENTS.md` is a limitation of that tool, not something the repo works around.

## The one rule that outranks this file

**Humans are the first developers. [README.md](README.md) outranks this file.** It is the human-facing description of what this template provides and how to use it. This file holds only agent-specific operational hints: how to navigate, build, and run the repo.

## What this repo is

A language-agnostic GitHub repository scaffold: community health files, issue and PR templates, and the shared toolchain every other template in the set builds on. It carries no application code, and a project generated from it adds its own.

- **Everything here is inherited wholesale** by every repo generated from it. A line that is right for one project and wrong for the next does not belong in this repo.
- **The `format`, `lint`, and `test` tasks in `mise.toml` are `echo 'Ok'` on purpose.** They are the contract a generated project fills in with real commands. Keep the task names; never delete a task to avoid implementing it, and never add a language-specific tool here.
- **Adding a tool means adding it to `mise.toml`**, pinned to an exact version. An unpinned tool, or one assumed present on `PATH`, is a broken generated project on someone else's machine.

## Working in the repo

- The task runner is `mise` (root `mise.toml`); commands are `mise run <task>`. `mise run setup` installs the git hooks.
- Tools are pinned and installed by `mise`; a shell with mise inactive resolves a bare tool call (`lefthook`, `cog`, `act`, …) from `PATH`, at an unpinned version. `mise run <task>` activates the toolchain for that task's duration, a bare tool call does not.
- `mise run check` runs format, lint, and test together; `mise run pre-commit` is what the git hook calls.
- `mise run act` replays the pull request workflow locally with [act](https://github.com/nektos/act). It reads secrets from `.env` — copy `.env.example` first.
- CI is [.github/workflows/pr-checks.yml](.github/workflows/pr-checks.yml). It validates the PR title as a Conventional Commit and runs `mise run lint`. A change to a task's meaning is a change to CI's meaning; check both.

## Commits

- **Conventional Commits, enforced.** `cog verify` runs on `commit-msg` and `cog check` on `pre-push`, so a malformed message is rejected locally before CI sees it.
- Commit messages are a title only — no body, no footer.
- Never push unless asked to.
