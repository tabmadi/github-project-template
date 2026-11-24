# The toolchain, the git hooks, and the checks, per ADR-0100. The tabkit module holds every shared part.
{
  description = "The language-agnostic base for a new repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    # A new version is a new tag here.
    tabkit = {
      url = "github:tabmadi/tabkit/v0.21.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      # Only the own checks of tabkit read this input, so it adds no second nixpkgs here.
      inputs.nixos-stable.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, tabkit, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # The template scope adds its own checks and outputs. A copy has no template/ folder, so it adds nothing.
      imports = [
        tabkit.flakeModules.default
      ]
      ++ inputs.nixpkgs.lib.optional (builtins.pathExists ./template/scope.nix) ./template/scope.nix;
    };
}
