# ADR-0000: Foundations

**Status:** Accepted
**Decides:** What this repo is, what a generated repo inherits from it, and the ADR process itself.

## Context

Every other template in the set starts from this repo. A file here is copied into each generated repo, and the copies do not link back. So a line that is right for one project and wrong for the next is a defect in every copy.

A repo without written decisions loses the reason for each choice. The next engineer then removes a check that exists for a reason, or adds a second tool for a job that one tool already does.

## Decision

This repo is a language-agnostic scaffold. It holds the community health files, the issue and pull request templates, the shared toolchain, and the documentation convention. It holds no application code.

**The task names are a contract.** `setup`, `format`, `lint`, `test`, `check`, and `ci` exist in every generated repo, per [ADR-0100](0100-toolchain.md). A generated repo fills them with real commands. It does not rename or delete them.

**Every decision is an ADR.** An ADR states what is true of the repo. It is law, not a plan: no roadmap, no follow-ups, and no remark on unfinished work. A gap between an ADR and the code is unfinished work.

**The ADR set has a size.** A repo of the template size has three ADRs: this one, [ADR-0001](0001-documentation-conventions.md) for the documentation conventions, and [ADR-0100](0100-toolchain.md) for the toolchain. A generated repo adds an ADR when it makes a decision that a reader would otherwise question.

**Planned work stays local.** It lives in an untracked `*.local.md` file, and `.gitignore` excludes these files.

## Consequences

The same text exists in many repos. The [blueprints](https://github.com/tabmadi/blueprints) repo keeps the copies in step: a change starts here and goes to every repo of the same size in one pass.

A generated repo inherits these ADRs. So an ADR is written for the engineer who maintains the repo, not for a person who decides whether to adopt it. Selection guidance belongs in the root `README.md`.

## Rules

- Every ADR carries a `Status`, a one-sentence `Decides` line, and a flat `Rules` section.
- An ADR states what is true, never what is intended. No roadmap, follow-up, or status section.
- The tasks `setup`, `format`, `lint`, `test`, `check`, and `ci` exist in every repo made from this one.
- Nothing in this repo is specific to one language or one project.
- Planned work lives in an untracked `*.local.md` file. No committed file links to one.
