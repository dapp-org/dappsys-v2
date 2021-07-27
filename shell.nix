let
  sources = import ./nix/sources.nix;
  pkgs = import sources.dapptools {};
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    dapp
    seth
    hevm
    mdbook
  ];

  DAPP_STANDARD_JSON=./input.json;
  DAPP_SOLC="${pkgs.solc-static-versions.solc_0_8_6}/bin/solc-0.8.6";
}
