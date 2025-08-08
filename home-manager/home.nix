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
    (inputs.self + "/modules/niri")
    (inputs.self + "/modules/waybar")
    (inputs.self + "/modules/alacritty")
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

  # ╭──────────────────────────────────────────────────────────────╮
  # │                 VARIABLES & FICHIERS PERSONNELS              │
  # ╰──────────────────────────────────────────────────────────────╯
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # home.file = {};

  # ╭──────────────────────────────────────────────────────────────╮
  # │                       MÉTA-CONFIG HM                         │
  # ╰──────────────────────────────────────────────────────────────╯
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
