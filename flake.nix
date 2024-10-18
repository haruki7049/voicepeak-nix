{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
      ];

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem = { pkgs, ... }:
      let
        voicepeak-v1211 = pkgs.callPackage ./voicepeak {
          url = "https://www.ah-soft.com/voice/setup/archives/voicepeak_v1211.zip";
          hash = "sha256-mvNgSI1OVYs1oRj/81JIkff2aB5MaviIeKpIvaIsF/s=";
        };
      in
      {
        treefmt = {
          projectRootFile = "flake.nix";
          programs.nixfmt.enable = true;
          programs.mdformat.enable = true;
        };

        packages = {
          inherit voicepeak-v1211;
          default = voicepeak-v1211;
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.nil
          ];
        };
      };
    };
}
