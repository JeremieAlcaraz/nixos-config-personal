# Configuration système NixOS
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Réseau
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Localisation
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Clavier
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };
  console.keyMap = "fr";

  # Utilisateurs
  users.users.jeremie = {
    isNormalUser = true;
    description = "jeremie";
    extraGroups = [ "networkmanager" "wheel" ];
        # --- ICI : choix du shell par défaut ---
    shell = pkgs.zsh;        # ← ligne à ajouter
  };

  # juste après la section packages ou où tu veux, au niveau racine
  programs.zsh.enable = true;

  users.groups.jeremie = {
    name = "jeremie";
    members = ["jeremie"];
  };

  # Auto-login (optionnel)
  services.getty.autologinUser = "jeremie";

  # Sudo sans mot de passe pour wheel
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # Packages système essentiels seulement
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  # Services système
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  services.openssh.enable = true;

  # Configuration git système (peut être déplacée dans home-manager)
  programs.git = {
    enable = true;
    config = {
      user.name = "JeremieAlcaraz";
      user.email = "hello@jeremiealcaraz.com";
    };
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05";
}
