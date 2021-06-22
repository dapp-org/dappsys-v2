let
  sources = import ./nix/sources.nix;
  pkgs = import sources.dapptools {};
in

pkgs.mkShell {
  buildInputs = with pkgs; [
    dapp
    seth
    hevm
    solc-static-versions.solc_0_8_4
  ];

  DAPP_SOLC="solc-0.8.4";
}
