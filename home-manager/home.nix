# Configuration utilisateur avec Home Manager
{ config, pkgs, inputs, ... }:  # ← Ajoutez inputs ici

{
  # ╭──────────────────────────────────────────────────────────────╮
  # │                       IDENTITÉ UTILISATEUR                   │
  # ╰──────────────────────────────────────────────────────────────╯
  home.username      = "jeremie";
  home.homeDirectory = "/home/jeremie";

  # ╭──────────────────────────────────────────────────────────────╮
  # │                 PAQUETS SANS MODULE HOME-MANAGER             │
  # ╰──────────────────────────────────────────────────────────────╯
  home.packages = with pkgs; [
    # Outils de développement
    inputs.neovim.packages.${pkgs.system}.default  # ← Changez ici
    tailscale
    openssh
    gh
    cowsay

    # Utilitaires divers (sans module HM)
    tree
  ];

  # ╭──────────────────────────────────────────────────────────────╮
  # │                  PROGRAMMES AVEC MODULES HM                  │
  # ╰──────────────────────────────────────────────────────────────╯
  ## Git
  programs.git = {
    enable         = true;
    userName       = "JeremieAlcaraz";
    userEmail      = "hello@jeremiealcaraz.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase        = false;
    };
  };

  ## zoxide (cd intelligent)
  programs.zoxide.enable = true;

  ## eza (remplaçant moderne de ls)
  programs.eza.enable = true;

  ## navi (cheatsheets interactives)
  programs.navi.enable = true;

  programs.starship = {
  enable = true;                     # installe starship + complétions
  enableZshIntegration = true;       # l’injecte dans ton zsh
  # enableBashIntegration = true;    # (décommente si tu utilises bash)
  # enableFishIntegration = true;    # (idem pour fish)
};

  # BAR WAYLAND : WAYBAR
  programs.waybar = {
    enable  = true;                     # active Waybar :contentReference[oaicite:0]{index=0}
    systemd.enable = true;  
    package = pkgs.waybar;              # (optionnel : version depuis nixpkgs)
    settings = {
      mainBar = {
        layer    = "top";
        position = "top";
        modules-left  = [ "niri/workspaces" ];   # intégration directe avec Niri :contentReference[oaicite:1]{index=1}
        modules-center = [ ];
        modules-right = [ "clock" "cpu" "memory" ];
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
  # │                  CONFIGURATION DU SHELL ZSH                  │
  # ╰──────────────────────────────────────────────────────────────╯
  programs.zsh = {
    enable               = true;
    enableCompletion     = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls  = "eza --group-directories-first --icons";
      ll  = "eza -l --git";
      la  = "eza -la --git";
      rebuild       = "sudo nixos-rebuild switch --flake ~/nix-config#nixos";
      rebuild-test  = "sudo nixos-rebuild test   --flake ~/nix-config#nixos";
      rebuild-boot  = "sudo nixos-rebuild boot   --flake ~/nix-config#nixos";
    };
  };

  # ╭──────────────────────────────────────────────────────────────╮
  # │                 VARIABLES & FICHIERS PERSONNELS              │
  # ╰──────────────────────────────────────────────────────────────╯
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file = {
    # Cheatsheets Navi personnelles
    "${config.xdg.dataHome}/navi/cheats".source =
       inputs.self + "/modules/navi/cheats";

      # config niri
    "${config.xdg.configHome}/niri/config.kdl".source =
       inputs.self + "/modules/niri/config.kdl";

    # Exemple de dotfile (commenté)
    # ".config/example/config.yml".text = ''
    #   key: value
    # '';
  };

  # ╭──────────────────────────────────────────────────────────────╮
  # │                       MÉTA-CONFIG HM                         │
  # ╰──────────────────────────────────────────────────────────────╯
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;





}
