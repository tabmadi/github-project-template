# ADR-0000: Foundations

- **Status:** Accepted
- **Decides:** What this repo holds, the recipe contract, and how ADRs work.

## Context

A repo without written decisions loses the reason for each choice. The next engineer removes a check that has a reason, or adds a second tool for a job that one tool already does.

A repo also needs fixed entry points. An engineer or a coding agent that knows the name of the gate runs it without reading every file first.

## Decision

This repo holds the community health files, the issue and pull request forms, a pinned toolchain, and the documentation convention. A project builds its code and its own decisions on that base.

**The recipe names are a contract.** The recipes `setup`, `format`, `lint`, `test`, `check`, and `ci` always exist, per [ADR-0100](0100-toolchain.md). Their names do not change.

**Every decision is an ADR.** An ADR states a rule as true now. A gap between an ADR and the code is a defect in the code.

**An ADR has a fixed shape.** It has a `Status`, a one-sentence `Decides` line, and the sections `Context`, `Decision`, `Consequences`, and `Rules`. The `Rules` section is a flat list, so a grep over all ADRs finds every convention.

**Inside this repo, an ADR links only to other ADRs.** A README or a guide moves, and the ADR outlives it. A link to a published standard is allowed.

## Consequences

An ADR is for the engineer who maintains the repo. The root `README.md` helps a reader choose the repo and start.

## Rules

- Every ADR has a `Status`, a one-sentence `Decides` line, and a flat `Rules` section.
- Inside this repo, an ADR links only to other ADRs.
- The recipes `setup`, `format`, `lint`, `test`, `check`, and `ci` exist, and their names do not change.
