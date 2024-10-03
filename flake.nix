{
  description = "Julian Kirsch's flake templates";

  outputs = { self, ... }: {
    templates = {
      rust-bare = {
        path = ./rust-bare;
        description = "A bare project using the latest stable Rust.";
      };
    };
  };
}
