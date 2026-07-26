{ ... }:
{
  inputs = {
    hermes-agent.url = "github:Hmbown/CodeWhale";
  };

  outputs = { hermes-agent, ... }: {
    nixosConfigurations.your-host = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        hermes-agent.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
