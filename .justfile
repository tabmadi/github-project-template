# Every task, per ADR-0100. A recipe that calls a tool runs only inside the dev shell of flake.nix.

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
    nix fmt flake.nix
    biome format --write .
    taplo fmt
    yamlfmt -conf .config/yamlfmt.yaml .
    just --fmt

# Markdown structure and formatting, per ADR-0001
lint-md: in-shell
    rumdl check .

# Scan the working tree for committed secrets
lint-secrets: in-shell
    gitleaks dir . --no-banner

# JSON format, per ADR-0100
lint-json: in-shell
    biome format .

# TOML format, per ADR-0100
lint-toml: in-shell
    taplo fmt --check

# YAML format, per ADR-0100
lint-yaml: in-shell
    yamlfmt -conf .config/yamlfmt.yaml -lint .

# .justfile format, per ADR-0100
lint-just:
    just --fmt --check

# Run every linter
lint: lint-md lint-secrets lint-json lint-toml lint-yaml lint-just

# Run the tests
test:
    @echo "No tests"

# The fast gate: run it before you finish a change
check: lint test

# Run exactly what CI runs: every check of flake.nix, in the Nix sandbox
ci:
    nix flake check --print-build-logs

[private]
in-shell:
    @test -n "${IN_NIX_SHELL:-}" || { echo "Enter the dev shell first: run nix develop, or allow direnv." >&2; exit 1; }
