# Configuration système NixOS
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/ssh

  ];

  # ╭────────────────────── LOGS & KERNEL ──────────────────╮
  boot = {
    # Configuration du bootloader
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Configuration des logs et kernel
    kernelParams = [ "loglevel=4" "quiet" ];
    consoleLogLevel = 4;
    kernel.sysctl = {
      "kernel.printk" = "4 4 1 7"; # Réduire verbosité console
    };
  };

  services.journald = {
    extraConfig = ''
      MaxLevelStore=notice
      MaxLevelKMsg=warning
      Storage=persistent
      Compress=yes
      SystemMaxUse=500M
      RuntimeMaxUse=100M
      MaxRetentionSec=1week
    '';
  };


  # ╭──────────────────────── RÉSEAU ───────────────────────╮
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.useNetworkd = false;
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  # ╭────────────────────── LOCALISATION ───────────────────╮
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

  # ╭────────────────────── CLAVIER & CONSOLE ──────────────╮
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };
  console.keyMap = "fr";

  # ╭────────────────────── UTILISATEURS ───────────────────╮
  users.users.jeremie = {
    isNormalUser = true;
    description = "jeremie";
    extraGroups = [ "networkmanager" "wheel" "video" "input" "seat" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  # Auto-login (optionnel)
  services.getty.autologinUser = "jeremie";

  environment.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
      exec niri --session
    fi
  '';

  # ╭────────────────────── SUDO ───────────────────────────╮
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # ╭────────────────────── PACKAGES SYSTÈME ───────────────╮
  nixpkgs.config.allowUnfree = true;

  # ╭────────────────────── WAYLAND / Niri ─────────────────╮
  programs.niri.enable = true;

  # Portals adaptés à Niri (wlroots)
  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Outils utilisés dans ta config Niri
  environment.systemPackages = with pkgs; [
    git
    neovim
    wl-clipboard
    swaybg
    xwayland-satellite
    waybar
    alacritty
    fuzzel
    swaylock
    brightnessctl
  ];

  ## 3. Seat management
  # Par défaut, NixOS utilise systemd-logind.  Si tu préfères seatd :
  # services.seatd.enable = true;          # backend seatd (facultatif) :contentReference[oaicite:4]{index=4}

  # ╭────────────────────── RESEAU & AUTRES SERVICES ───────╮
  services.tailscale = { enable = true; openFirewall = true; };
  services.openssh.enable = true;
  services.dbus.enable = true;
  services.qemuGuest.enable = true;
  services.cloud-init.enable = true;

  # ╭────────────────────── GIT SYSTÈME (OPTION) ───────────╮
  programs.git = {
    enable = true;
    config.user = {
      name = "JeremieAlcaraz";
      email = "hello@jeremiealcaraz.com";
    };
  };

  # ╭────────────────────── EXPÉRIMENTAL (FLAKES) ──────────╮
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [ "https://vicinae.cachix.org" ];
    extra-trusted-public-keys = [
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
  };

  # ╭──────────────────── STATE VERSION ────────────────────╮
  system.stateVersion = "25.05";
}
