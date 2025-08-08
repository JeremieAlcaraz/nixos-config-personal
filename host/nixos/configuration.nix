# Configuration système NixOS
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  
    # ╭────────────────────── LOGS & KERNEL ──────────────────╮
  boot = {
    # Configuration du bootloader
    loader.systemd-boot.enable     = true;
    loader.efi.canTouchEfiVariables = true;

    # Configuration des logs et kernel
    kernelParams = [ "loglevel=4" "quiet" ];
    consoleLogLevel = 4;
    kernel.sysctl = {
      "kernel.printk" = "4 4 1 7";  # Réduire verbosité console
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
  networking.hostName              = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable          = true;
    allowedTCPPorts = [ 22 ];
  };

  # ╭────────────────────── LOCALISATION ───────────────────╮
  time.timeZone       = "Europe/Paris";
  i18n.defaultLocale  = "en_US.UTF-8";
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
    layout  = "fr";
    variant = "azerty";
  };
  console.keyMap = "fr";

  # ╭────────────────────── UTILISATEURS ───────────────────╮
  users.users.jeremie = {
    isNormalUser  = true;
    description   = "jeremie";
    extraGroups   = [ "networkmanager" "wheel" "video" "input" "seat" ];
    shell         = pkgs.zsh;
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
    enable             = true;
    wheelNeedsPassword = false;
  };

  # ╭────────────────────── PACKAGES SYSTÈME ───────────────╮
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git neovim                 # déjà présents
    wl-clipboard swaybg        # utilitaires Wayland
    xwayland-satellite         # X11 rootless pour Niri :contentReference[oaicite:0]{index=0}
  ];

  # ╭────────────────────── WAYLAND / Niri ─────────────────╮
  ## 1. Activer le compositeur
  programs.niri.enable = true;             # Niri dans nixpkgs-unstable :contentReference[oaicite:1]{index=1}

  ## 2. Audio & screencast (PipeWire + portail)
  services.pipewire.enable = true;         # Framework audio/vidéo moderne :contentReference[oaicite:2]{index=2}
  xdg.portal = {
    enable        = true;
    extraPortals  = [ pkgs.xdg-desktop-portal-gnome ];  # requis par Niri pour le screencast :contentReference[oaicite:3]{index=3}
  };

  ## 3. Seat management
  # Par défaut, NixOS utilise systemd-logind.  Si tu préfères seatd :
  # services.seatd.enable = true;          # backend seatd (facultatif) :contentReference[oaicite:4]{index=4}

  # ╭────────────────────── RESEAU & AUTRES SERVICES ───────╮
  services.tailscale = { enable = true; openFirewall = true; };
  services.openssh.enable = true;

  # ╭────────────────────── GIT SYSTÈME (OPTION) ───────────╮
  programs.git = {
    enable = true;
    config.user = {
      name  = "JeremieAlcaraz";
      email = "hello@jeremiealcaraz.com";
    };
  };

  # ╭────────────────────── EXPÉRIMENTAL (FLAKES) ──────────╮
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ╭──────────────────── STATE VERSION ────────────────────╮
  system.stateVersion = "25.05";
}
