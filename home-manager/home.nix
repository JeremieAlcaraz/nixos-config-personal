# Configuration utilisateur avec Home Manager
{ config, pkgs, ... }:

{
  # Informations utilisateur
  home.username = "jeremie";
  home.homeDirectory = "/home/jeremie";

  # Packages utilisateur
  home.packages = with pkgs; [
    # Outils de développement
    tailscale
    openssh
    gh
    cowsay
    
    # Ajoutez d'autres packages utilisateur ici
    # firefox
    # vscode
    # discord
  ];

  # Configuration git (déplacée du système vers l'utilisateur)
  programs.git = {
    enable = true;
    userName = "JeremieAlcaraz";
    userEmail = "hello@jeremiealcaraz.com";
    
    # Configuration git supplémentaire
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  # Configuration Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Configuration du shell (exemple avec zsh)
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      rebuild = "sudo nixos-rebuild switch --flake ~/nix-config#nixos";
      rebuild-test = "sudo nixos-rebuild switch --flake ~/nix-config#nixos";
      rebuild-boot = "sudo nixos-rebuild switch --flake ~/nix-config#nixos";
    };
  };

  # Variables d'environnement
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Dotfiles et configuration personnalisée
  home.file = {
    # Exemple : fichier de configuration personnalisé
    # ".config/example/config.yml".text = ''
    #   key: value
    # '';
  };

  # Version de Home Manager
  home.stateVersion = "24.11";

  # Permettre à Home Manager de gérer lui-même
  programs.home-manager.enable = true;
}