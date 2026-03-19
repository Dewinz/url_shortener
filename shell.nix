{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    elixir
    elixir-ls  # For LSP hover documentation and features
  ];
}
# TODO: Set Git account properly.
