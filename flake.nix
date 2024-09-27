{
  description = "Supernote Screensaver Utils";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        makeScript = name: script: pkgs.writeShellApplication {
          inherit name;
          runtimeInputs = [ pkgs.imagemagick ];
          text = builtins.readFile script;
        };

        encode-script = makeScript "snencode" ./encode.sh;
        decode-script = makeScript "sndecode" ./decode.sh;
      in
      {
        packages = {
          snencode = encode-script;
          sndecode = decode-script;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.imagemagick
            encode-script
            decode-script
          ];

          shellHook = ''
            echo "ImageMagick version: $(magick -version)"
          '';
        };
      }
    );
}
