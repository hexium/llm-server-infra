{
  description = "Forge LLM server";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  outputs = { nixpkgs, ... }: {
    nixosConfigurations.forge = nixpkgs.lib.nixosSystem {
      # Change to aarch64-linux for an ARM server.
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
