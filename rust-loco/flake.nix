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
        binName = "${manifest.name}-bin";
      in rec {

        packages."${binName}" = pkgs.rustPlatform.buildRustPackage {
          pname = manifest.name;
          version = manifest.version;
          src = pkgs.lib.cleanSource ./.;

          cargoLock.lockFile = ./Cargo.lock;
        };

        packages."${manifest.name}" = pkgs.dockerTools.buildImage {
          name = manifest.name;
          tag = manifest.version;

          config = {
            Cmd = [ "${packages.${binName}}"];
          };

          created = "now";
        };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            openssl
            pkg-config
            rust-bin.stable.latest.complete
          ];

          shellHook = ''
            if ! command -v loco 2>&1 >/dev/null
            then
              cargo install loco-cli
            fi

            if ! command -v sea 2>&1 >/dev/null
            then
              cargo install sea-orm-cli
            fi
          '';
        };
      }
    );
}
