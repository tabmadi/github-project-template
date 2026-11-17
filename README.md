# GitHub Project Template

A language-agnostic base for a new GitHub repository. It holds the community health files, the issue and pull request templates, a pinned toolchain, git hooks, a CI gate, and the documentation convention. Every other template in the [blueprints](https://github.com/tabmadi/blueprints) set starts from it.

It holds no application code. A repo made from it adds the language tools and fills in the task contract.

## Stack

| Tool | Owns |
| --- | --- |
| [Nix](https://nixos.org) with flakes | Tool versions, the dev shell, and the sandboxed checks |
| [just](https://just.systems) | Tasks |
| [Zed](https://zed.dev) | The supported editor, with project settings in `.zed/` |
| [git-hooks.nix](https://github.com/cachix/git-hooks.nix) | Git hooks |
| [cocogitto](https://docs.cocogitto.io) | Conventional Commits checks |
| [rumdl](https://github.com/rvben/rumdl) | Markdown lint |
| [gitleaks](https://github.com/gitleaks/gitleaks) | Secret scan |
| [Renovate](https://docs.renovatebot.com) | Updates to the pinned versions |

## Getting started

1. Install [Nix](https://nixos.org/download) and enable flakes. For the editor, also install [Zed](https://zed.dev), and [direnv](https://direnv.net) with [nix-direnv](https://github.com/nix-community/nix-direnv). direnv enters the dev shell on `cd`, and Zed loads it through direnv.
2. Clone the repo and enter the dev shell. The first entry downloads every tool and installs the git hooks:

   ```bash
   git clone git@github.com:tabmadi/github-project-template.git
   cd github-project-template
   nix develop
   ```

3. Run the gate:

   ```bash
   just check
   ```

## Editor

Open the folder in Zed, and run `direnv allow` once. Zed then uses the language servers and formatters of the dev shell, formats on save, and lists every recipe under `task: spawn`. Any other editor works through the same dev shell.

## Tasks

| Recipe | Does |
| --- | --- |
| `just setup` | Builds the dev shell and installs the git hooks |
| `just format` | Applies every formatter |
| `just lint` | Runs every linter: `lint-md` and `lint-secrets` |
| `just test` | Runs the tests. Here it is a placeholder |
| `just check` | Runs `lint` and `test`. Run it before you finish a change |
| `just ci` | Runs `nix flake check`, exactly what CI runs. The `pre-push` hook runs it too |

## Layout

```text
.
├── .github/
│   ├── ISSUE_TEMPLATE/     Bug, feature, and documentation issue forms
│   ├── workflows/check.yml The CI gate: just ci
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── renovate.json       Updates to the pinned versions
├── docs/adr/               The decisions of the project: foundations, doc conventions, toolchain
├── template/               What only the template needs: its contract, checks, and outputs
├── flake.nix               The dev shell, the git hooks, and the checks
├── flake.lock              The pinned nixpkgs and inputs
├── .zed/                Zed project settings and tasks
├── justfile                Tasks
├── .envrc                  Enters the dev shell through direnv
├── cog.toml                Commit types
├── .rumdl.toml             Markdown rules
├── .gitleaks.toml          Secret scan rules
├── AGENTS.md               Hints for coding agents
├── CODE_OF_CONDUCT.md
├── SECURITY.md
└── LICENSE
```

## Using this template

Make a new project with Nix. It copies every file except the `template/` folder, which holds what only the template needs. This is the preferred way:

```bash
nix flake new -t github:tabmadi/github-project-template my-project
```

Then follow the steps that it prints:

1. In the new folder, run `git init` and `git add -A`. A flake sees only the files that git tracks.
2. Run `nix develop`. It downloads the tools and installs the git hooks.
3. Add your language tools to the dev shell in `flake.nix`, and your checks under `checks`.
4. Fill in the `format`, `lint`, and `test` recipes in `justfile` with real commands. Keep the recipe names.
5. Rewrite this README with the template skeleton from [readme-template](https://github.com/tabmadi/readme-template).
6. Update the contacts in `SECURITY.md` and the copyright line in `LICENSE`.
7. Install the [Renovate app](https://github.com/apps/renovate) on the new repository.

### With the GitHub template button

The button copies every file, the `template/` folder included. Remove it in the first commit:

1. Clone the new repository, and run `nix develop` in it.
2. Run `just init`. It prints the first steps, and it removes the `template/` folder with git.
3. Commit the removal.
4. Follow the printed steps from step 2. Your repository already has git.

## Decisions

The ADRs in [docs/adr](docs/adr/README.md) record every decision and the reason for it. `template/adr/0000-template-contract.md` records what makes this repo a template. [ADR-0001](docs/adr/0001-documentation-conventions.md) is the house style for all text.

## Contributing

Follow the [Code of Conduct](CODE_OF_CONDUCT.md). Commit messages follow [Conventional Commits](https://www.conventionalcommits.org), and the `commit-msg` hook checks them. Run `just check` before you open a pull request.

## Security

To report a vulnerability, follow [SECURITY.md](SECURITY.md).

## License

Apache License 2.0. See [LICENSE](LICENSE).
