# Agent guide for the template scope

This folder exists only in the template. A project made from it has no `template/` folder. Read [TPL-0000](adr/0000-template-contract.md) before you change anything.

- Write every file outside this folder in the voice of the project. It must stay true after the copy.
- A file outside this folder never links here, and never names another repo. `just lint-scope` checks the docs.
- A template-only fact, check, or output lives in this folder.
- A change to a shared project ADR goes to every template of the same size in one pass.
