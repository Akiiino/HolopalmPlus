{
  description = "HolopalmPlus mod for I Was a Teenage Exocolonist";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ pkgs.dotnet-sdk_8 ];
      };

      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "HolopalmPlus";
        version = "1.0.0";
        src = ./.;

        nativeBuildInputs = [ pkgs.dotnet-sdk_8 ];

        # Set GAME_LIBS env var to path containing game's Managed DLLs
        buildPhase = ''
          export DOTNET_CLI_TELEMETRY_OPTOUT=1
          export HOME=$(mktemp -d)
          
          if [ -z "$GAME_LIBS" ]; then
            echo "Error: Set GAME_LIBS to game's Managed folder"
            echo "e.g.: nix build --impure --expr '(builtins.getFlake (toString ./.)).packages.x86_64-linux.default.overrideAttrs (o: { GAME_LIBS = \"/path/to/Exocolonist_Data/Managed\"; })'"
            exit 1
          fi
          
          dotnet build -c Release -p:GameLibs="$GAME_LIBS"
        '';

        installPhase = ''
          mkdir -p $out
          cp bin/Release/net472/HolopalmPlus.dll $out/
        '';
      };
    };
}
