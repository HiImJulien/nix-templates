# nix-templates

This repository holds a collection of my own nix(OS) flake templates, which
include the necessary definitions to host a development shell and build the
resulting packages and, if applicable, the appropriate docker images.

## Templates

| Template  | Description                                                                   | Docker Image?      |
| --------- | ----------------------------------------------------------------------------- | ------------------ |
| rust-bare | A simple bare-bones Rust package using Rust's latest stable toolchain.        | :x:                |
| rust-loco | A simple bare-bones Loco.rs application using Rust's latest stable toolchain. | :white_check_mark: |
