# Configuration utilisateur avec Home Manager
{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # ╭──────────────────────────────────────────────────────────────╮
  # │                       IDENTITÉ UTILISATEUR                   │
  # ╰──────────────────────────────────────────────────────────────╯
  home.username = "jeremie";
  home.homeDirectory = "/home/jeremie";

  # ╭──────────────────────────────────────────────────────────────╮
  # │                          IMPORTS MODULES                     │
  # ╰──────────────────────────────────────────────────────────────╯
  imports = [
    (inputs.self + "/modules/aliases")
    (inputs.self + "/modules/lazygit")
    (inputs.self + "/modules/navi")
    # (on ajoutera /modules/niri quand on fera le module dédié)
  ];

  # ╭──────────────────────────────────────────────────────────────╮
  # │                 PAQUETS SANS MODULE HOME-MANAGER             │
  # ╰──────────────────────────────────────────────────────────────╯
  home.packages = with pkgs; [
    # Outils de développement
    inputs.neovim.packages.${pkgs.system}.default
    gh
    cowsay

    # Utilitaires divers (sans module HM)
    tree
    fzf
    ripgrep
    delta  # pager utilisé par lazygit
  ];

  # ╭──────────────────────────────────────────────────────────────╮
  # │                  PROGRAMMES AVEC MODULES HM                  │
  # ╰──────────────────────────────────────────────────────────────╯
  ## Git
  programs.git = {
    enable = true;
    userName = "JeremieAlcaraz";
    userEmail = "hello@jeremiealcaraz.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  ## zoxide (cd intelligent)
  programs.zoxide.enable = true;

  ## eza (remplaçant moderne de ls)
  programs.eza.enable = true;

  ## navi (cheatsheets interactives)
  programs.navi.enable = true;

  programs.starship = {
    enable = true; # installe starship + complétions
    enableZshIntegration = true; # l’injecte dans ton zsh
    # enableBashIntegration = true;
    # enableFishIntegration = true;
  };

  # BAR WAYLAND : WAYBAR
  programs.waybar = {
    enable = true; # active Waybar
    systemd.enable = true;
    package = pkgs.waybar;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = ["niri/workspaces"];
        modules-center = [];
        modules-right = ["clock" "cpu" "memory"];
      };
    };
    style = ''
      * { font-family: "FiraCode Nerd Font"; font-size: 11pt; }
      #clock { margin: 0 8px; }
    '';
  };

  ## Alacritty (terminal Wayland)
  programs.alacritty = {
    enable = true;
    settings = {
      window.padding = { x = 6; y = 6; };
      window.decorations = "none";
      font.size = 11;
      colors.primary.background = "#1e1e2e";
      colors.primary.foreground = "#cdd6f4";
    };
  };

  # ╭──────────────────────────────────────────────────────────────╮
  # │                 VARIABLES & FICHIERS PERSONNELS              │
  # ╰──────────────────────────────────────────────────────────────╯
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file = {
    # Cheatsheets Navi personnelles (on déplacera dans le module navi à l'étape 3)
    "${config.xdg.dataHome}/navi/cheats".source =
      inputs.self + "/modules/navi/cheats";

    # config niri (on fera un module dédié à l'étape 2)
    "${config.xdg.configHome}/niri/config.kdl".source =
      inputs.self + "/modules/niri/config.kdl";
  };

  # ╭──────────────────────────────────────────────────────────────╮
  # │                       MÉTA-CONFIG HM                         │
  # ╰──────────────────────────────────────────────────────────────╯
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
