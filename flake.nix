# The toolchain, the git hooks, and the checks, per ADR-0100.
{
  description = "The language-agnostic base for a new repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # The linter of prose, comments, and ADRs, per ADR-0001. A new version is a new tag here.
    tablint = {
      url = "github:tabmadi/tablint/v0.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.git-hooks.follows = "git-hooks";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      git-hooks,
      tablint,
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
        GITLEAKS_CONFIG = ".config/gitleaks.toml";
      };

      # The configs in .config/ that a tool finds only through a flag. Every call of the tool passes it.
      configFlags = {
        cog = "--config .config/cog.toml";
      };

      # The one formatter of JSON, JSONC, TOML, and YAML, per ADR-0100. dprint takes its config
      # and its plugins only as flags after the subcommand, so this wrapper adds both to every call.
      dprint =
        pkgs:
        let
          plugins = with pkgs.dprint-plugins; [
            dprint-plugin-json
            dprint-plugin-toml
            g-plane-pretty_yaml
          ];
          pluginFiles = pkgs.lib.concatMapStringsSep " " (plugin: "${plugin}/plugin.wasm") plugins;
        in
        pkgs.writeShellScriptBin "dprint" ''
          case "''${1:-}" in
            fmt | check | file-paths | output-file-paths | resolved-config | output-resolved-config)
              command=$1
              shift
              exec ${pkgs.dprint}/bin/dprint "$command" --plugins ${pluginFiles} --config .config/dprint.json "$@"
              ;;
            *) exec ${pkgs.dprint}/bin/dprint "$@" ;;
          esac
        '';

      tablintPackage = pkgs: tablint.packages.${pkgs.stdenv.hostPlatform.system}.default;

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
            data = {
              enable = true;
              name = "dprint";
              entry = "${dprint pkgs}/bin/dprint check";
              files = "\\.(jsonc?|toml|ya?ml)$";
            };
            prose = {
              enable = true;
              name = "tablint";
              entry = "${tablintPackage pkgs}/bin/tablint check";
              pass_filenames = false;
            };
            justfile = {
              enable = true;
              name = "just --fmt";
              entry = "${pkgs.just}/bin/just --fmt --check";
              files = "(^|/)justfile$";
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
            (tablintPackage pkgs)
            # The formatter of JSON, TOML, and YAML, per ADR-0100.
            (dprint pkgs)
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
          lint-prose = check pkgs "lint-prose" [ (tablintPackage pkgs) ] "tablint check";
          lint-md = check pkgs "lint-md" [ pkgs.rumdl ] "rumdl check .";
          lint-secrets = check pkgs "lint-secrets" [ pkgs.gitleaks ] "gitleaks dir . --no-banner";
          lint-data = check pkgs "lint-data" [ (dprint pkgs) ] "DPRINT_CACHE_DIR=$TMPDIR/dprint dprint check";
          lint-just = check pkgs "lint-just" [ pkgs.just ] "just --fmt --check";
        }
        // templateScope.checks pkgs
      );

      formatter = forEachSystem (pkgs: pkgs.nixfmt);
    }
    // templateScope.outputs;
}
