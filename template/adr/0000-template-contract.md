# TPL-0000: Template contract

- **Status:** Accepted
- **Decides:** Which files are the template and which are the project, how a project is made, and what this template may hold.

## Context

A project made from this template copies its files, and the copies do not link back. So every sentence in a copied file must stay true in the project. A sentence that names the template or another repo turns false in the copy.

This repo is the language-agnostic base of the [blueprints](https://github.com/tabmadi/blueprints) set. Every other template in the set starts from it.

## Decision

### Two scopes

| Scope | Holds | In a project |
| --- | --- | --- |
| Project | Every file outside `template/`, written in the voice of the project | Copied |
| Template | The `template/` folder: this ADR, the agent hints, and the template checks and outputs | Not copied |

`flake.nix` loads `template/scope.nix` when it exists. That file adds the template checks and the `templates` output. A project has no `template/` folder, so it adds nothing.

### Making a project

`nix flake new -t github:tabmadi/github-project-template <dir>` copies the project scope. Its welcome text lists the first steps of the new project.

GitHub's template button copies every file, `template/` included. In that copy, `just init` prints the same first steps and removes `template/`.

### What this template holds

Nothing here is specific to one language or one project. Its project ADRs are [ADR-0000](../../docs/adr/0000-foundations.md), [ADR-0001](../../docs/adr/0001-documentation-conventions.md), and [ADR-0100](../../docs/adr/0100-toolchain.md).

## Consequences

The root `README.md` describes the template. A new project rewrites it, and the welcome text says so.

## Rules

- Every file that a project must not inherit lives in `template/`.
- A file outside `template/` never links into it. `(CI: lint-scope)`
- A project doc never names another repo or speaks as the template. `(CI: lint-scope)`
- Nothing in the project scope is specific to one language or one project.
- A change to a shared project ADR goes to every template of the same size in one pass.
