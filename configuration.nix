{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "forge";
  networking.useDHCP = true;

  # Assumes UEFI boot; replace these for a BIOS installation.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.dwarf = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    # Add your public SSH key before deploying for remote access.
    openssh.authorizedKeys.keys = [ ];
  };

  # NVIDIA's management utility is distributed under an unfree license.
  nixpkgs.config.allowUnfreePredicate = pkg:
    pkgs.lib.getName pkg == "nvidia-x11";

  environment.systemPackages = with pkgs; [
    ripgrep
    dig
    curl
    git
    python3
    docker-compose
    config.hardware.nvidia.package.bin # nvidia-smi; follows the selected driver.
  ];

  virtualisation.docker.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  networking.firewall.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Keep this at the release used for the initial installation.
  system.stateVersion = "26.05";
}
