# Agent guide

This guide is for any coding agent that works in this repo. `AGENTS.md` is the one standard, and the repo has no per-tool files such as `CLAUDE.md`.

**Humans are the first developers. The ADRs, `docs/`, and `README.md` rank above this file.** This file holds only operational hints.

## Read first

- A new copy starts with the steps in `Starting a project` in `README.md`. Delete this line when they are done.
- If a `template/` folder exists, read `template/AGENTS.md` before anything else.
- [ADR-0000](docs/adr/0000-foundations.md): what this repo is and the ADR process.
- [docs/adr/README.md](docs/adr/README.md): the ADR index. To check a convention, grep the `Rules` sections first.

## Write in Simple English

Every text follows the Simple English profile in [ADR-0001](docs/adr/0001-documentation-conventions.md#simple-english): docs, ADRs, comments, commit titles, and task descriptions.

- Use common words. One idea per sentence, at most 25 words.
- In prose, use only period, comma, colon, and the possessive apostrophe. No em dash, semicolon, parentheses, or `?`.
- No emoji, no contractions, and no `e.g.` or `etc.`
- No chronology, intensifiers, hedges, or planned work. State what is true now.
- `just lint-prose` checks these rules with tabkit.

## Working in the repo

- Work inside the dev shell: run `nix develop`, or allow direnv. Then run every task as `just <recipe>`.
- Keep the recipe names, per [ADR-0000](docs/adr/0000-foundations.md).
- Add a tool to the dev shell in `flake.nix`, never to a second version manager.
- Before you finish a change, run `just check`. `just ci` runs the full sandboxed gate that CI runs.
- Commit messages are a Conventional Commits title only, with no body. Never push unless asked to.
