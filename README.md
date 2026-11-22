# GitHub Project Template

A language-agnostic base for a new GitHub repository. It holds the community health files, the issue and pull request templates, a pinned toolchain, git hooks, a CI gate, and the documentation convention. Every other template in the [blueprints](https://github.com/tabmadi/blueprints) set starts from it.

It holds no application code. A repo made from it adds the language tools and fills in the task contract.

## Stack

| Tool | Owns |
| --- | --- |
| [Nix](https://nixos.org) with flakes | Tool versions, the dev shell, and the sandboxed checks |
| [tabkit](https://github.com/tabmadi/tabkit) | The shared dev shell, git hooks, and checks, and the rules for prose, comments, and ADRs |
| [just](https://just.systems) | Tasks |
| [Zed](https://zed.dev) | The supported editor, with project settings in `.zed/` |
| [git-hooks.nix](https://github.com/cachix/git-hooks.nix) | Git hooks |
| [cocogitto](https://docs.cocogitto.io) | Conventional Commits checks |
| [rumdl](https://github.com/rvben/rumdl) | Markdown lint |
| [dprint](https://dprint.dev) | JSON, TOML, and YAML format |
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

Open the folder in Zed, and run `direnv allow` once. Zed suggests its Nix extension when you open `flake.nix`, so install it once on each machine. Zed then uses the language servers and formatters of the dev shell, formats on save, and lists every recipe under `task: spawn`. Zed loads the dev shell when it opens the folder. After a change to `flake.nix`, open the folder again, so Zed loads the new tools. Any other editor works through the same dev shell.

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
├── .config/
│   ├── cog.toml            Commit types
│   ├── dprint.json         JSON, TOML, and YAML format rules
│   ├── gitleaks.toml       Secret scan rules
│   └── rumdl.toml          Markdown rules
├── .github/
│   ├── ISSUE_TEMPLATE/     Bug, feature, and documentation issue forms
│   ├── workflows/check.yml The CI gate: just ci
│   ├── CODE_OF_CONDUCT.md
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── SECURITY.md
│   └── renovate.json       Updates to the pinned versions
├── .zed/                   Zed project settings and tasks
├── docs/adr/               The decisions of the project: foundations, doc conventions, toolchain
├── template/               What only the template needs: its contract, checks, and outputs
├── .envrc                  Enters the dev shell through direnv
├── flake.nix               The dev shell, the git hooks, and the checks
├── flake.lock              The pinned nixpkgs and inputs
├── justfile                Tasks
├── AGENTS.md               Hints for coding agents
├── README.md
└── LICENSE
```

## Starting a project

Make a new project with Nix. It copies every file except the `template/` folder, which holds what only the template needs. This is the preferred way:

```bash
nix flake new -t github:tabmadi/github-project-template my-project
```

Then follow these steps:

1. In the new folder, run `git init` and `git add -A`. A flake sees only the files that git tracks.
2. Run `nix develop`. It downloads the tools and installs the git hooks.
3. Add your language tools to the dev shell in `flake.nix`, and your checks under `checks`.
4. Fill in the `format`, `lint`, and `test` recipes in `justfile` with real commands. Keep the recipe names.
5. Rewrite this README for the project, with the sections that ADR-0001 sets for its kind of repo.
6. Update the contacts in `.github/SECURITY.md` and the copyright line in `LICENSE`.
7. Delete the line that starts with `A new copy` from `AGENTS.md`.
8. Set the squash merge message to the pull request title, with no body, and turn off the other merge styles:

   ```bash
   gh api -X PATCH repos/OWNER/REPO -f squash_merge_commit_title=PR_TITLE -f squash_merge_commit_message=BLANK -F allow_merge_commit=false -F allow_rebase_merge=false
   ```

9. Add a `RENOVATE_TOKEN` repository secret. The `renovate` workflow uses it to open update pull requests.

### With the GitHub template button

The button copies every file, the `template/` folder included. Its first commit, `Initial commit`, is not a Conventional Commit.

1. Clone the new repository, and run `nix develop` in it.
2. Run `just init`. It removes the `template/` folder and the `A new copy` line of `AGENTS.md`.
3. Replace the first commit of GitHub. This is safe before anyone else clones the repository:

   ```bash
   git add -A
   git commit --amend -m "chore: start from <template> <release>"
   git push --force-with-lease
   ```

4. Follow the steps above from step 2, and skip the step on `AGENTS.md`. Your repository already has git.

## Decisions

The ADRs in [docs/adr](docs/adr/README.md) record every decision and the reason for it. `template/adr/0000-template-contract.md` records what makes this repo a template. [ADR-0001](docs/adr/0001-documentation-conventions.md) is the house style for all text.

## Contributing

Follow the [Code of Conduct](.github/CODE_OF_CONDUCT.md). Commit messages follow [Conventional Commits](https://www.conventionalcommits.org), and the `commit-msg` hook checks them. Run `just check` before you open a pull request.

## Security

To report a vulnerability, follow [SECURITY.md](.github/SECURITY.md).

## License

Apache License 2.0. See [LICENSE](LICENSE).
