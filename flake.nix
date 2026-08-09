{
  description = "My nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-flatpak — declarative Flatpak management with overrides support
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # Stylix — system-wide theming with base16 color schemes
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs =
    {
      #     self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # Nordic-cursors 光标主题包：源文件在仓库 assets/nordic-cursors/ 内，离线可复现
      nordic-cursors-overlay = final: prev: {
        nordic-cursors = final.stdenvNoCC.mkDerivation {
          pname = "nordic-cursors";
          version = "0.1.0";
          src = ./assets/nordic-cursors;
          installPhase = ''
            mkdir -p $out/share/icons/Nordic-cursors
            cp -r $src/. $out/share/icons/Nordic-cursors/
          '';
        };
      };
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # FIXME replace with your hostname
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          # > Our main nixos configuration file <
          modules = [
            ./nixos/configuration.nix
            { nixpkgs.overlays = [ nordic-cursors-overlay ]; }
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        # FIXME replace with your username@hostname
        "kid@nixos" = home-manager.lib.homeManagerConfiguration {
          # Home-manager requires 'pkgs' instance
          # Import nixpkgs with allowUnfree so standalone home-manager
          # can install packages like Steam without env vars.
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ nordic-cursors-overlay ];
          };
          extraSpecialArgs = {
            inherit inputs;
          };
          # > Our main home-manager configuration file <
          modules = [ ./home-manager/home.nix ];
        };
      };
    };
}
