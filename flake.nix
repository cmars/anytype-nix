{
  description = "API resource versioning tool";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        stdenv = pkgs.gcc10Stdenv;
      in rec {
        packages = flake-utils.lib.flattenTree {
          anytype = pkgs.callPackage ./default.nix { };
        };
        defaultPackage = packages.anytype;
        defaultApp = flake-utils.lib.mkApp { drv = packages.anytype; };
      });
}
