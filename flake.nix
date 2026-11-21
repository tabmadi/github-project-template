# The toolchain, the git hooks, and the checks, per ADR-0100. The tabnix module holds every shared part.
{
  description = "The language-agnostic base for a new repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    # A new version is a new tag here.
    tabnix = {
      url = "github:tabmadi/tabnix/v0.15.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs =
    inputs@{ flake-parts, tabnix, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # The template scope adds its own checks and outputs. A copy has no template/ folder, so it adds nothing.
      imports = [
        tabnix.flakeModules.default
      ]
      ++ inputs.nixpkgs.lib.optional (builtins.pathExists ./template/scope.nix) ./template/scope.nix;
    };
}
