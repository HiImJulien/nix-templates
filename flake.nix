{
  description = "Julian Kirsch's flake templates";

  outputs = { self, ... }: {
    templates = {
      rust-bare = {
        path = ./rust-bare;
        description = "A bare project using the latest stable Rust.";
      };

      rust-loco = {
        path = ./rust-loco;
        description = "A bare project with the necessary packages for loco.rs";
      };
    };
  };
}
