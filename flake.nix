# The toolchain, the git hooks, and the checks, per ADR-0100.
{
  description = "The language-agnostic base for a new repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      git-hooks,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSystem = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});

      # The template scope adds its own checks and outputs. A copy has no template/ folder, so it adds nothing.
      templateScope =
        if builtins.pathExists ./template/scope.nix then
          import ./template/scope.nix { inherit self nixpkgs; }
        else
          {
            checks = _: { };
            outputs = { };
          };

      # The configs in .config/ that a tool does not find by itself. The paths are relative to the repo root.
      configEnv = {
        TAPLO_CONFIG = ".config/taplo.toml";
        GITLEAKS_CONFIG = ".config/gitleaks.toml";
      };

      # The configs in .config/ that a tool finds only through a flag. Every call of the tool passes it.
      configFlags = {
        yamlfmt = "-conf .config/yamlfmt.yaml";
        cog = "--config .config/cog.toml";
      };

      # A check runs a command on a writable copy of the tracked files, so a tool can write its cache.
      check =
        pkgs: name: tools: command:
        pkgs.runCommand name ({ nativeBuildInputs = tools; } // configEnv) ''
          cp -r ${self} source
          chmod -R u+w source
          cd source
          ${command}
          touch $out
        '';

      hooks =
        pkgs:
        git-hooks.lib.${pkgs.stdenv.hostPlatform.system}.run {
          src = ./.;
          package = pkgs.prek;
          hooks = {
            markdown = {
              enable = true;
              name = "rumdl";
              entry = "${pkgs.rumdl}/bin/rumdl check";
              files = "\\.md$";
            };
            json = {
              enable = true;
              name = "biome";
              entry = "${pkgs.biome}/bin/biome format --no-errors-on-unmatched";
              files = "\\.jsonc?$";
            };
            toml = {
              enable = true;
              name = "taplo";
              entry = "${pkgs.taplo}/bin/taplo fmt --config ${configEnv.TAPLO_CONFIG} --check";
              files = "\\.toml$";
            };
            yaml = {
              enable = true;
              name = "yamlfmt";
              entry = "${pkgs.yamlfmt}/bin/yamlfmt ${configFlags.yamlfmt} -lint";
              files = "\\.ya?ml$";
            };
            justfile = {
              enable = true;
              name = "just --fmt";
              entry = "${pkgs.just}/bin/just --fmt --check";
              files = "(^|/)\\.?justfile$";
              pass_filenames = false;
            };
            secrets = {
              enable = true;
              name = "gitleaks";
              entry = "${pkgs.gitleaks}/bin/gitleaks git --config ${configEnv.GITLEAKS_CONFIG} --pre-commit --staged --no-banner";
              pass_filenames = false;
            };
            commit-message = {
              enable = true;
              name = "cog verify";
              entry = "${pkgs.cocogitto}/bin/cog ${configFlags.cog} verify --file";
              stages = [ "commit-msg" ];
            };
            # Only the commits that this push adds. Older history, such as the first commit
            # that GitHub writes for a repo made from a template, can predate the convention.
            commit-range = {
              enable = true;
              name = "cog check";
              entry = "${pkgs.cocogitto}/bin/cog ${configFlags.cog} check origin/master..HEAD";
              stages = [ "pre-push" ];
              pass_filenames = false;
              always_run = true;
            };
            ci = {
              enable = true;
              name = "just ci";
              entry = "${pkgs.just}/bin/just ci";
              stages = [ "pre-push" ];
              pass_filenames = false;
              always_run = true;
            };
          };
        };
    in
    {
      devShells = forEachSystem (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            just
            cocogitto
            rumdl
            gitleaks
            # The formatters of JSON, TOML, and YAML, per ADR-0100.
            biome
            taplo
            yamlfmt
            # The language server and formatter of flake.nix, for the editor.
            nixd
            nixfmt
          ];
          env = configEnv;
          shellHook = (hooks pkgs).shellHook;
        };
      });

      checks = forEachSystem (
        pkgs:
        {
          lint-md = check pkgs "lint-md" [ pkgs.rumdl ] "rumdl check .";
          lint-secrets = check pkgs "lint-secrets" [ pkgs.gitleaks ] "gitleaks dir . --no-banner";
          lint-json = check pkgs "lint-json" [ pkgs.biome ] "biome format --vcs-enabled=false .";
          lint-toml = check pkgs "lint-toml" [ pkgs.taplo ] "taplo fmt --check";
          lint-yaml = check pkgs "lint-yaml" [ pkgs.yamlfmt ] "yamlfmt ${configFlags.yamlfmt} -lint .";
          lint-just = check pkgs "lint-just" [ pkgs.just ] "just --fmt --check";
        }
        // templateScope.checks pkgs
      );

      formatter = forEachSystem (pkgs: pkgs.nixfmt);
    }
    // templateScope.outputs;
}
