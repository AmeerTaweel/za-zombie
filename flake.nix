{
	description = "YouTube Music Downloader";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, mach-nix, flake-utils }:
	flake-utils.lib.eachDefaultSystem (system: let
		pkgs = import nixpkgs { inherit system; };

		pythonBuildDependencies = pythonPackages: with pythonPackages; [ ];
		pythonTestDependencies = pythonPackages: with pythonPackages; [ ];
		pythonRuntimeDependencies = pythonPackages: with pythonPackages; [
			yt-dlp
			mutagen
		];

		pythonDevelopmentEnvironment = pkgs.python310.withPackages (pythonPackages:
    		pythonBuildDependencies pythonPackages ++
			pythonTestDependencies pythonPackages ++
			pythonRuntimeDependencies pythonPackages
		);
	in {
		devShell = pkgs.mkShell {
			nativeBuildInputs = with pkgs; [
				pythonDevelopmentEnvironment
			];
			buildInputs = [ ];
		};
	});
}
