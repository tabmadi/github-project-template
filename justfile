# Every task, per ADR-0103. A recipe that calls a tool runs only inside the dev shell of flake.nix.

set shell := ["bash", "-euo", "pipefail", "-c"]

import? 'template/justfile'

# List the recipes
default:
    @just --list

# Build the dev shell and install the git hooks
setup:
    nix develop --command true

# Apply every formatter
format: in-shell
    rumdl check --fix .
    nixfmt $(git ls-files '*.nix')
    dprint fmt
    just --fmt

# Prose, comments, and ADRs, per ADR-0001
lint-prose: in-shell
    tabkit check

# Markdown structure and formatting, per ADR-0001
lint-md: in-shell
    rumdl check .

# Scan the working tree for committed secrets
lint-secrets: in-shell
    gitleaks dir . --no-banner

# JSON, JSONC, TOML, and YAML format, per ADR-0104
lint-data: in-shell
    dprint check

# Nix format, per ADR-0104
lint-nix: in-shell
    nixfmt --check $(git ls-files '*.nix')

# justfile format, per ADR-0104
lint-just:
    just --fmt --check

# Run every linter
lint: lint-prose lint-md lint-secrets lint-data lint-nix lint-just

# Run the tests
test:
    @echo "No tests"

# The fast gate: run it before you finish a change
check: lint test

# Run exactly what CI runs: every check of flake.nix, in the Nix sandbox
ci:
    nix flake check --print-build-logs

# Push what CI built to the binary cache, per ADR-0101. Without NIX_CACHE_URL it does nothing
cache-push: in-shell
    nix-cache-push

# Run Renovate over this repository, per ADR-0102. The renovate workflow calls it
ci-renovate: in-shell
    nix run --inputs-from . nixpkgs#renovate

# Write the files that follow a dependency change, per ADR-0102. This repo has none
deps-sync:
    @true

[private]
in-shell:
    @test -n "${IN_NIX_SHELL:-}" || { echo "Enter the dev shell first: run nix develop, or allow direnv." >&2; exit 1; }
