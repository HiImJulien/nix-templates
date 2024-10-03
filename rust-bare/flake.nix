{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [(import rust-overlay)];
        pkgs = import nixpkgs { inherit system overlays; };
        manifest = (pkgs.lib.importTOML ./Cargo.toml).package;
      in rec {

        packages."${manifest.name}" = pkgs.rustPlatform.buildRustPackage {
            pname = manifest.name;
            version = manifest.version;
            src = pkgs.lib.cleanSource ./.;

            cargoLock.lockFile = ./Cargo.lock;
        };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            rust-bin.stable.latest.complete
          ];
        };
      }
    );
}
