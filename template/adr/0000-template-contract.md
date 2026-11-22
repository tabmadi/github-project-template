# TPL-0000: Template contract

- **Status:** Accepted
- **Decides:** Which files are the template and which are the project, how a project is made, and what this template may hold.

## Context

A project made from this template copies its files, and the copies do not link back. So every sentence in a copied file must stay true in the project. A sentence that names the template or another repo turns false in the copy.

This repo is the language-agnostic base of the [blueprints](https://github.com/tabmadi/blueprints) set. Every other template in the set starts from it.

## Decision drivers

1. **No second tool.** A project is made with the tools that the repo already has.
2. **No link back.** A project owns its files. Nothing ties it to the template after the copy.
3. **Two paths.** A project can start from the command line and from the template button of GitHub.
4. **Template files stay out.** A file that only the template needs never reaches a project.

## Considered options

| Option | 1 No second tool | 2 No link back | 3 Two paths | 4 Template files stay out | Verdict |
| --- | --- | --- | --- | --- | --- |
| The GitHub template button alone | Yes | Yes | One path | No. It copies every file | Rejected on drivers 3 and 4 |
| cookiecutter | Needs Python | Yes | One path | Yes | Rejected on drivers 1 and 3 |
| Copier | Needs Python | No. It records the template version, so that a project takes later template changes | One path | Yes | Rejected on driver 2. A repo with setup modes and template updates can choose it |
| **`nix flake new` with the `templates` output, and `just init` for the button** | **Yes** | **Yes** | **Yes** | **Yes. `template/` is filtered out, and `just init` removes it** | **Chosen** |

Sources:

- Copier updates a project from a later template version, and cookiecutter copies once: [Copier, comparisons](https://copier.readthedocs.io/en/stable/comparisons/).
- [nix flake new](https://nix.dev/manual/nix/latest/command-ref/new-cli/nix3-flake-new).

## Decision

### Two scopes

| Scope | Holds | In a project |
| --- | --- | --- |
| Project | Every file outside `template/`, written in the voice of the project | Copied |
| Template | The `template/` folder: this ADR, the agent hints, and the template checks and outputs | Not copied |

`flake.nix` loads `template/scope.nix` when it exists. That file imports the template module of tabkit and sets its description and welcome text. The module adds the template checks and the `templates` output. A project has no `template/` folder, so it adds nothing.

### Making a project

`nix flake new -t github:tabmadi/github-project-template <dir>` copies the project scope. Its welcome text lists the first steps of the new project.

GitHub's template button copies every file, `template/` included. In that copy, `just init` prints the same first steps and removes `template/`.

### What this template holds

Nothing here is specific to one language or one project. Its project ADRs are listed in [the ADR index](../../docs/adr/README.md).

## Consequences

The root `README.md` describes the template. A new project rewrites it, and the welcome text says so.

## Rules

- Every file that a project must not inherit lives in `template/`.
- A file outside `template/` never links into it. `(CI: lint-scope)`
- A project doc never names another repo or speaks as the template. `(CI: lint-scope)`
- Nothing in the project scope is specific to one language or one project.
- A change to a shared project ADR goes to every template of the same size in one pass.
