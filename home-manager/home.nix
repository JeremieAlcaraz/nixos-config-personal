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
  imports =
    let
      # On lit tous les dossiers dans modules/
      moduleDirs = builtins.attrNames (builtins.readDir (inputs.self + "/modules"));
      # On filtre pour retirer ce qui commence par "_" ou les fichiers indésirables
      filtered = builtins.filter (name:
        name != ".DS_Store" && !(builtins.match "^_" name != null)
      ) moduleDirs;
    in
      builtins.map (name: inputs.self + "/modules/${name}") filtered;


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
