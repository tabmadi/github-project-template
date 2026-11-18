# The template scope, per TPL-0000. The template module of tabnix adds the lint-scope check and the templates output.
{ inputs, ... }:
{
  imports = [ inputs.tabnix.flakeModules.template ];

  tabnix.template = {
    description = "A language-agnostic base: community files, a pinned toolchain, git hooks, a CI gate, and the doc rules";
    welcomeText = ''
      # A new project

      1. In a new folder, run `git init` and `git add -A`. A flake sees only the files that git tracks.
      2. Run `nix develop`. It downloads the tools and installs the git hooks.
      3. Rewrite `README.md` for this project.
      4. Update the contacts in `.github/SECURITY.md` and the copyright line in `LICENSE`.
      5. Install the Renovate app on the new repository.
    '';
  };
}
