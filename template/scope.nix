# The template scope, per TPL-0000. The template module of tabnix adds the lint-scope check and the templates output.
{ inputs, ... }:
{
  imports = [ inputs.tabnix.flakeModules.template ];

  tabnix.template = {
    extraVoice = [
      "github\\.com/tabmadi"
      "blueprints"
    ];
    description = "A language-agnostic base: community files, a pinned toolchain, git hooks, a CI gate, and the doc rules";
    welcomeText = ''
      # A new project

      Follow `Starting a project` in `README.md`.
    '';
  };
}
