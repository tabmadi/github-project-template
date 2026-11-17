# ADR-0001: Documentation conventions

- **Status:** Accepted
- **Decides:** The house style for every text in the repo: Simple English on the ASD-STE100 model.

## Context

Humans and LLMs read every text in this repo. Many readers do not speak English as a first language.

Style drifts where it is a matter of taste. So each rule here is a closed list or a limit, and a reviewer cites it instead of arguing taste.

## Decision

### Adopted standards

This ADR adopts published standards and states only its own additions.

| Standard | Covers |
| --- | --- |
| [ASD-STE100](https://www.asd-ste100.org) Simplified Technical English | The model for the Simple English profile |
| [ISO 24495-1:2023](https://www.iso.org/standard/78907.html) plain language | Prose and docs |
| [Google Developer Documentation Style Guide](https://developers.google.com/style) | Present tense and active voice |
| [Google Style Guides](https://google.github.io/styleguide/) | Code comments in each language |

### Simple English

Every text uses Simple English: docs, ADRs, comments, commit titles, task output, error messages, and UI copy. The profile takes the writing rules of STE and replaces its fixed dictionary with the CEFR B1 word level.

| Rule | Bad | Good |
| --- | --- | --- |
| Use the most common word at CEFR B1 | `utilize`, `leverage`, `prior to`, `in order to` | `use`, `use`, `before`, `to` |
| Keep technical terms. Never swap one for a general word that changes the meaning | `the server draws the page` | `the server renders the page` |
| One term for one concept, and one meaning for one word | `seam` in one ADR and `boundary` in the next | `seam` in both |
| A single verb instead of a phrasal verb. A phrasal verb that is a technical name stays | `figure out`, `carry out` | `find`, `do`. `set up` stays |
| No idioms | `under the hood`, `out of the box` | `inside`, `by default` |
| No Latin abbreviations and no contractions | `e.g.`, `etc.`, `don't` | `for example`, a full list, `do not` |

A sentence has one idea and at most 25 words. It uses active voice and present tense. A code span counts as one word, and each table cell, list item, and heading counts on its own.

Three or more steps are a numbered list, and each step starts with its verb. Three or more items that share two or more attributes are a table.

### Punctuation

Prose uses only the period, the comma, the colon, and the possessive apostrophe.

| Instead of | Write |
| --- | --- |
| A semicolon or a dash between two clauses | Two sentences, or a colon when the second part explains the first |
| Parentheses or dashes around an aside | A separate sentence, or nothing |
| A citation in parentheses, `(ADR-0100)` | A link in the sentence: `per [ADR-0100](0100-toolchain.md)` |
| A question | The answer, as a statement |
| Quote marks around literal text | Backticks |
| `&`, `and/or`, or `A / B` | `and`, `or`, or a list |

These are not prose, and the punctuation rules do not apply to them:

- Markdown syntax, code, paths, URLs, and identifiers.
- A hyphen inside a word, such as `read-only`.
- The annotations `(CI: <task>)` and `(ref: <standard>)`.
- A third-party text adopted verbatim, such as a license.

The em dash, the en dash, the ellipsis, curly quotes, and emoji appear in no tracked text file, code included.

### Banned constructs

| Banned | Example | Write instead |
| --- | --- | --- |
| Chronology | `we moved to X`, `previously Y` | What is true now. Git holds the history |
| Intensifiers | `very`, `really`, `simply`, `just`, `clearly` | Nothing |
| Hedges | `basically`, `generally`, `typically` | A decision |
| Meta-commentary | `Note that`, `This section explains` | The thing itself |
| Planned work | A `Follow-ups` list, a roadmap, a `TODO` with no issue | Nothing. State the rule and stop |
| Implementation status | `not yet wired`, `for now`, `currently` | The rule, with no qualifier |
| A link to an untracked file | `[plan](plan.local.md)` | Nothing |
| A number that goes stale | `~25 components` | A link to the list |

A number is part of a decision only when doubling it would change the decision.

### Where each text lives

| Path | Holds |
| --- | --- |
| `docs/adr/` | One decision per file |
| `docs/guide/` | A procedure that someone follows |
| `docs/reference/` | A lookup, a registry, or live state |
| `README.md` at the root | What the repo is, who it is for, and how to start |

### Markdown layout

Markdown is not hard-wrapped: each paragraph, list item, or table row is one line. Tables are compact, with one space inside each pipe and a bare `---` delimiter. Both rules keep a one-word edit a one-line diff.

`rumdl` enforces the table rule with `MD060`. `MD013` is off in `.config/rumdl.toml`, because it would force hard wraps.

### Code comments

The reader is an expert with an LLM at hand. A comment holds only what neither the code nor the ADRs show.

The first answer to a comment is a better name: extract a function, as in the Comments smell of [Fowler's *Refactoring*](https://martinfowler.com/books/refactoring.html). A name reaches every call site and cannot drift from the code.

A comment that remains must pass three tests:

| Test | The comment fails when |
| --- | --- |
| Deletion | A reader would make the same change without it. Doubt means delete |
| Genre | It stays true after the file is deleted. Then it is a decision, procedure, or lookup, and the comment cites that doc |
| Length | It is longer than one paragraph of three lines. One line is the norm |

A comment states one of these facts:

- An external system's behavior that its own docs omit or contradict.
- A constraint that an ADR owns and the code cannot express, cited as `ADR-XXXX`.
- An order or timing dependency that the call site does not show.
- A deliberate omission that a reader would otherwise add back.
- On an exported identifier: units, null values, bounds, side effects, or errors that the signature cannot state.

These comments are never committed:

- A comment that explains confusing code. Rewrite the code.
- A comment about a state that a later edit makes false, such as a placeholder to replace.
- A comment that teaches a third-party tool, or repeats what the path or name says.
- Commented-out code, changelog, author, or date comments, and decorative banners. Git holds the history.

## Consequences

No task checks the Simple English profile, the banned constructs, or the comment rules. Review is the gate, and the closed lists give the reviewer a clear reason to reject a text.

## Rules

- Every text uses the Simple English profile: B1 words, kept technical terms, one term per concept, no idioms, no Latin abbreviations, and no contractions. `(ref: ASD-STE100)`
- Prose is plain language in active voice and present tense. `(ref: ISO 24495-1, Google dev-docs)`
- A sentence has one idea and at most 25 words.
- Prose punctuation is the period, the comma, the colon, and the possessive apostrophe.
- The em dash, the en dash, the ellipsis, curly quotes, and emoji appear in no tracked text file. Third-party text adopted verbatim is exempt.
- Three or more steps are a numbered list. Three or more items with two or more shared attributes are a table.
- No document or comment holds chronology, intensifiers, hedges, meta-commentary, questions, planned work, or implementation status.
- A number is stated only when doubling it would change the decision.
- No tracked file links to an untracked one.
- A decision lives in `docs/adr/`, a procedure in `docs/guide/`, and a lookup in `docs/reference/`.
- Markdown is not hard-wrapped, tables are compact, and every Markdown file passes `rumdl`. `(CI: lint-md)`
- A comment passes the deletion, genre, and length tests, and states one of the allowed facts.
- A `TODO` cites an issue or an ADR.
