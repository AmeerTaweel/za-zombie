{
	description = "YouTube Music Downloader";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, flake-utils }:
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

		otherDependencies = with pkgs; {
			build = [ ];
			test = [ ];
			runtime = [ ffmpeg ];
		};

		dependencies = with pkgs; {
			build = otherDependencies.build ++ pythonDependencies.build;
			test = otherDependencies.test ++ pythonDependencies.test;
			runtime = otherDependencies.runtime ++ pythonDependencies.runtime;
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
			buildInputs = dependencies.build;
			propagatedBuildInputs = dependencies.runtime;
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
				otherDependencies.build
				otherDependencies.test
				otherDependencies.runtime
			];
			buildInputs = [ ];
		};
	});
}
