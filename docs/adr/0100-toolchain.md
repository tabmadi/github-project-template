# ADR-0100: Toolchain

- **Status:** Accepted
- **Decides:** Nix pins every tool and runs every check, `just` runs every task, Zed is the supported editor, and the same checks run at commit time, at push time, and in CI.

## Context

A tool choice is worth something only when every machine reproduces it. Four failures matter:

1. A tool resolves from `$PATH`, at whatever version the machine has.
2. Two machines have the same tool version, but the tool links against different system libraries, so it behaves differently.
3. A check runs only in CI, so every local commit passes it.
4. A pin goes stale because nobody updates it.

A repo can hold more than one language. It may ship artifacts, and it may run its own machines. A mechanism that pins tools for one language, or only on a laptop, leaves the other cases to a second tool with its own edge cases.

### Considered options

| Option | Pins | Down to system libraries | Builds artifacts and machines | Verdict |
| --- | --- | --- | --- | --- |
| A version manager, such as mise or asdf | The version of each tool | No. A tool links against the libraries of the machine, and some tools compile on install | No | Covers failure 1 only |
| Dev Containers | A container image | Yes, inside the container | Images only | Every command runs in a container. The image itself drifts unless it is built from pins |
| devbox, Flox, or devenv | Every tool, through Nix | Yes | Partly | A second layer with its own config on top of Nix. The underlying tool is the same |
| **Nix with flakes** | **Every tool and every dependency of each tool, through one lock file** | **Yes** | **Yes: packages, images, and whole machines with NixOS** | **Chosen** |
| Guix | The same model as Nix | Yes | Yes | A smaller package set, and an init system that no other tool here uses |

## Decision

### Nix pins every tool

`flake.nix` declares a dev shell that holds every tool of the repo. `flake.lock` pins the exact commit of `nixpkgs` and of every other input. From that commit, every tool and every library under it is fixed. Every engineer, every CI run, and every machine that builds from the flake gets the same tools.

Nix is the one mechanism for every language. A repo adds its language tools to the dev shell, not to a second version manager.

| Tool | Owns |
| --- | --- |
| Nix with flakes | Tool versions, the dev shell, and the sandboxed checks |
| `just` | Tasks |
| Zed | The supported editor, with its project settings in `.zed/` |
| `git-hooks.nix`, with `prek` | Git hooks, declared in `flake.nix` |
| cocogitto | Commit message shape |
| rumdl | Markdown style |
| gitleaks | Secret scanning |
| Renovate | Updates to `flake.lock` and to the GitHub Actions |

`nixpkgs` follows the `nixpkgs-unstable` branch, so tool versions stay current. A commit of `nixpkgs` has one version of each package. A repo selects a major line by attribute, such as `go_1_27`. The patch version follows the lock. A version that `nixpkgs` does not have comes from an overlay in `flake.nix`.

Each engineer enters the dev shell with `nix develop`, or automatically with direnv through the committed `.envrc`.

### `just` runs every task

Nix decides what is installed. A task runner decides what runs. These are two jobs, so they are two tools.

| Option | Verdict |
| --- | --- |
| Flake apps through `nix run .#task` | Each task is a derivation, so each change waits for an evaluation. There are no task dependencies or arguments |
| mise tasks | A full task runner, but mise is also a version manager. That second role overlaps with Nix |
| Make | Its file-target model and its whitespace rules do not fit a list of commands |
| **`just`** | **One small binary from the dev shell. Recipes have dependencies, arguments, and doc comments. A reader understands the file without learning a tool** |

| Recipe | Does |
| --- | --- |
| `setup` | Builds the dev shell and installs the git hooks |
| `format` | Applies every formatter |
| `lint` | Runs every linter |
| `test` | Runs the tests |
| `check` | Runs `lint` and `test`. It is the fast gate before a change is finished |
| `ci` | Runs `nix flake check`. It is exactly what CI runs |

A recipe that calls a tool runs only inside the dev shell. Outside it, the recipe stops with a message, so no tool resolves from `$PATH`.

### The same checks everywhere

Every check of the repo is a derivation under `checks` in `flake.nix`. `nix flake check` builds each one in the Nix sandbox, from the files that git tracks. A local change that git does not track cannot make a check pass.

| When | What runs |
| --- | --- |
| Commit | The `pre-commit` hook runs the fast checks on the staged files. The `commit-msg` hook runs `cog verify` |
| Push | The `pre-push` hook runs `cog check` on the commits that the push adds, and `just ci` |
| CI | The workflow runs `just ci` inside `nix develop`, on every push to `master` and on every pull request |

`git-hooks.nix` writes each hook with the store path of its tool. So a hook works from any terminal or editor, inside the dev shell or not. Entering the dev shell installs the hooks.

On a pull request, CI also verifies the title with `cog`, because the title becomes the squash commit. The title reaches the shell only through an environment variable.

### Zed is the supported editor

The editor decides how one person types, not what the code is. So the repo supports one editor fully and depends on none.

| Option | Verdict |
| --- | --- |
| **Zed** | **Chosen.** It loads the dev shell through direnv with no plugin, so it finds every tool at the pinned version. Its project settings and tasks are plain files in `.zed/`. It is native and open source |
| VS Code | It needs an extension to load the dev shell, and its settings mix the project and the person |
| A JetBrains IDE | It is commercial, and its project files hold personal state |
| Neovim or Helix | Each engineer builds a different setup, so a committed setup fits few people |

The dev shell holds the language servers and the formatters: `nixd` and `nixfmt` for Nix, and `rumdl` for Markdown. Every editor that loads the dev shell gets them at the pinned version.

`.zed/settings.json` formats on save with the formatters of the repo and selects the language servers. `.zed/tasks.json` runs the `just` recipes. A personal setting, such as a theme, a font, or a keymap, stays in the user settings of Zed.

Other editors work through the same dev shell and `.editorconfig`. The repo commits no config for them, and `.gitignore` excludes their folders. No check depends on the editor.

### Nix beyond the toolchain

This repo adopts the layers of Nix that its kind needs. The dev shell and the checks apply to every kind.

| Kind of repo | Builds its artifacts with Nix | Declares its machines with NixOS |
| --- | --- | --- |
| A library or a tool with no deploy | Not applicable | Not applicable |
| An app that a managed provider runs | When the provider takes an image | No. The provider runs the machine |
| An app on its own machines, with no orchestrator | Yes | Yes |
| An app on an orchestrator | Yes | Only the hosts outside the cluster. The nodes run the OS of the orchestrator |

## Consequences

Every engineer installs Nix and enables flakes. Nix runs on Linux and macOS. On Windows, it runs only inside WSL.

The Nix language is a skill that every maintainer learns. An evaluation error is often long, so a small, regular `flake.nix` is a requirement, not a style.

The first entry into the dev shell downloads every tool from the binary cache. Later entries take no download. A tool that the cache does not hold builds from source, and that takes longer.

Upstream Nix marks flakes as an experimental feature, so each engineer enables them with one setting. A committed `flake.lock` keeps building the same tools at its pinned commits, whatever upstream changes.

`nixpkgs-unstable` moves fast. The weekly lock update brings new versions of every tool at once. The CI gate decides, and a failing update stays open until the code or the pin is fixed.

CI downloads the tools on each run unless the workflow has a binary cache.

Zed loads the dev shell only through direnv. An engineer who uses the editor installs direnv, and nix-direnv for a fast reload, and allows `.envrc` once.

A push runs the full gate on the local machine first, so a slow gate makes every push slow. `git push --no-verify` skips it, and CI still runs it.

Renovate needs the Renovate GitHub app on the repository. Without it, the pins go stale.

## Rules

- Every tool comes from the dev shell of `flake.nix`. No tool is resolved from outside it.
- `flake.lock` is committed. Renovate updates it, and the CI gate decides.
- A language tool is added to the dev shell, never to a second version manager.
- Every task is a `just` recipe with a doc comment. A recipe that calls a tool runs only inside the dev shell.
- Every check that CI runs is a derivation under `checks` in `flake.nix`. `(CI: ci)`
- The git hooks are declared in `flake.nix`, and entering the dev shell installs them.
- The language servers and formatters of the editor come from the dev shell.
- `.zed/` holds project settings only. No check depends on the editor.
- `just check` passes before a change is finished.
- `just ci` is the only CI step after setup, and it runs inside `nix develop`. `(CI: ci)`
- Commit messages and pull request titles follow Conventional Commits with the type set in `cog.toml`. `(ref: Conventional Commits 1.0.0)`
- A workflow never puts event text, such as a pull request title, directly into a `run` script.
