# GitHub Project Template

A language-agnostic base for a new GitHub repository. It holds the community health files, the issue and pull request templates, a pinned toolchain, git hooks, a CI gate, and the documentation convention. Every other template in the [blueprints](https://github.com/tabmadi/blueprints) set starts from it.

It holds no application code. A repo made from it adds the language tools and fills in the task contract.

## Stack

| Tool | Owns |
| --- | --- |
| [mise](https://mise.jdx.dev) | Tool versions and tasks |
| [lefthook](https://github.com/evilmartians/lefthook) | Git hooks |
| [cocogitto](https://docs.cocogitto.io) | Conventional Commits checks |
| [rumdl](https://github.com/rvben/rumdl) | Markdown lint |
| [gitleaks](https://github.com/gitleaks/gitleaks) | Secret scan |
| [Renovate](https://docs.renovatebot.com) | Updates to the pinned versions |

## Getting started

1. Install [mise](https://mise.jdx.dev/getting-started.html).
2. Clone the repo and install the tools and hooks:

   ```bash
   git clone git@github.com:tabmadi/github-project-template.git
   cd github-project-template
   mise install
   mise run setup
   ```

3. Run the gate:

   ```bash
   mise run check
   ```

## Tasks

| Task | Does |
| --- | --- |
| `mise run setup` | Installs the git hooks |
| `mise run format` | Applies every formatter |
| `mise run lint` | Runs every linter: `lint:md` and `lint:secrets` |
| `mise run test` | Runs the tests. Here it is a placeholder |
| `mise run check` | Runs `lint` and `test`. Run it before you finish a change |
| `mise run ci` | Runs exactly what CI runs. The `pre-push` hook runs it too |

## Layout

```text
.
├── .github/
│   ├── ISSUE_TEMPLATE/     Bug, feature, and documentation issue forms
│   ├── workflows/check.yml The CI gate: mise run ci
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── renovate.json       Updates to the pinned versions
├── docs/adr/               The decisions: foundations, doc conventions, toolchain
├── .mise.toml              Tool pins and tasks
├── .lefthook.yml           Git hooks
├── cog.toml                Commit types
├── .rumdl.toml             Markdown rules
├── .gitleaks.toml          Secret scan rules
├── AGENTS.md               Hints for coding agents
├── CODE_OF_CONDUCT.md
├── SECURITY.md
└── LICENSE
```

## Using this template

1. Create a repository from this template on GitHub.
2. Add your language tools to `[tools]` in `.mise.toml`, pinned to an exact version.
3. Fill in the `format`, `lint`, and `test` tasks with real commands. Keep the task names.
4. Rewrite this README with the template skeleton from [readme-template](https://github.com/tabmadi/readme-template).
5. Update the contacts in `SECURITY.md` and the copyright line in `LICENSE`.
6. Install the [Renovate app](https://github.com/apps/renovate) on the new repository.

## Decisions

The ADRs in [docs/adr](docs/adr/README.md) record every decision and the reason for it. [ADR-0001](docs/adr/0001-documentation-conventions.md) is the house style for all text.

## Contributing

Follow the [Code of Conduct](CODE_OF_CONDUCT.md). Commit messages follow [Conventional Commits](https://www.conventionalcommits.org), and the `commit-msg` hook checks them. Run `mise run check` before you open a pull request.

## Security

To report a vulnerability, follow [SECURITY.md](SECURITY.md).

## License

Apache License 2.0. See [LICENSE](LICENSE).
