# Architecture Decision Records

Each ADR ends with a flat **Rules** section and has a one-sentence **Decides** line in its header. The *Decides* column below is the fastest complete pass over the set.

| ADR | Decides |
| --- | --- |
| [0000](0000-foundations.md) | What this repo is, what a generated repo inherits from it, and the ADR process itself |
| [0001](0001-documentation-conventions.md) | The house style for every document, comment, and UI string: Simple English on the ASD-STE100 model |
| [0100](0100-toolchain.md) | Nix pins every tool and runs every check, `just` runs every task, and the same checks run at commit time, at push time, and in CI |

A new ADR starts from [`_template.md`](_template.md).
