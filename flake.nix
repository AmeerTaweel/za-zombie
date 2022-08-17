{
	description = "YouTube Music Downloader";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, mach-nix, flake-utils }:
	flake-utils.lib.eachDefaultSystem (system: let
		pkgs = import nixpkgs { inherit system; };

		pythonInterpreter = pkgs.python310;
		pythonPackages = pythonInterpreter.pkgs;
		buildPythonApplication = pythonPackages.buildPythonApplication;

		pythonDependencies = with pythonPackages; {
			build = [ flit ];
			test = [ ];
			runtime = [ mutagen rich yt-dlp ];
		};

		pythonDevelopmentEnvironment = pythonInterpreter.withPackages (_:
			pythonDependencies.build ++ 
			pythonDependencies.test ++ 
			pythonDependencies.runtime
		);

		za-zombie = buildPythonApplication {
			name = "za-zombie";
			format = "pyproject";
			src = ./.;
			buildInputs = pythonDependencies.build;
			propagatedBuildInputs = pythonDependencies.runtime;
		};
	in {
		packages = {
			default = za-zombie;
			inherit za-zombie;
		};
		overlays.default = final: prev: {
			inherit za-zombie;
		};	
		devShell = pkgs.mkShell {
			nativeBuildInputs = with pkgs; [
				pythonDevelopmentEnvironment
			];
			buildInputs = [ ];
		};
	});
}
