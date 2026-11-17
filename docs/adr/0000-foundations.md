# ADR-0000: Foundations

- **Status:** Accepted
- **Decides:** What this repo holds, the recipe contract, and the ADR process itself.

## Context

A repo without written decisions loses the reason for each choice. The next engineer then removes a check that exists for a reason, or adds a second tool for a job that one tool already does.

A repo also needs fixed entry points. An engineer or a coding agent that knows the name of the gate runs it without reading every file first.

## Decision

This repo holds the community health files, the issue and pull request forms, a pinned toolchain, and the documentation convention. Its code and its own decisions build on that base.

**The recipe names are a contract.** `setup`, `format`, `lint`, `test`, `check`, and `ci` exist in this repo, per [ADR-0100](0100-toolchain.md). Each one runs the real commands of the repo. Their names do not change.

**Every decision is an ADR.** An ADR states what is true of the repo. It is law, not a plan: no roadmap, no follow-ups, and no remark on unfinished work. A gap between an ADR and the code is unfinished work.

**An ADR is added for a decision that a reader would otherwise question.** [ADR-0001](0001-documentation-conventions.md) holds the documentation conventions, and [ADR-0100](0100-toolchain.md) holds the toolchain.

## Consequences

An ADR is written for the engineer who maintains the repo, not for a person who decides whether to adopt it. Selection guidance belongs in the root `README.md`.

An ADR names other ADRs only. A link to a README, a guide, or another repo breaks when that file moves, and the ADR outlives it.

## Rules

- Every ADR carries a `Status`, a one-sentence `Decides` line, and a flat `Rules` section.
- An ADR states what is true, never what is intended. No roadmap, follow-up, or status section.
- An ADR links to other ADRs only.
- The recipes `setup`, `format`, `lint`, `test`, `check`, and `ci` exist in this repo.
