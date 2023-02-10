{
  description = "YouTube Music Downloader";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];

    mkZaZombie = pkgs:
      pkgs.python3Packages.buildPythonApplication {
        name = "za-zombie";
        format = "pyproject";
        src = ./.;
        buildInputs = with pkgs.python3Packages; [
          flit
        ];
        propagatedBuildInputs =
          (with pkgs; [
            ffmpeg
          ])
          ++ (with pkgs.python3Packages; [
            mutagen
            rich
            yt-dlp
          ]);
      };
  in {
    packages = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
      za-zombie = mkZaZombie pkgs;
    in {
      inherit za-zombie;
      default = za-zombie;
    });

    devShells = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
      pythonEnv = pkgs.python3.withPackages (pythonPkgs:
        with pythonPkgs; [
          mutagen
          rich
          yt-dlp
        ]);
    in {
      default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          pythonEnv
          ffmpeg
        ];
        buildInputs = [];
      };
    });

    overlays.default = final: prev: let
      pkgs = import nixpkgs {inherit (final) system;};
      za-zombie = mkZaZombie pkgs;
    in {
      inherit za-zombie;
    };

    formatter = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        pkgs.alejandra
    );
  };
}
