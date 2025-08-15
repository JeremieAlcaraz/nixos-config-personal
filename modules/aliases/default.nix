{
  config,
  pkgs,
  ...
}: {
  # ╭──────────────────────────────────────────────────────────────╮
  # │                  CONFIGURATION DU SHELL ZSH                  │
  # ╰──────────────────────────────────────────────────────────────╯
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # Git
      gco = "git checkout";
      gst = "git status";
      gcm = "git commit -m";

      # Lazygit
      lg = "lazygit";

      # Nix
      # Mets à jour SEULEMENT l'input neovim du flake AU BON CHEMIN,
      # puis rebuild NixOS pour l'host "nixos" (adapte si ton host s'appelle autrement)
      rebuild = "nix flake update --update-input neovim $HOME/nix-config && sudo nixos-rebuild switch --flake $HOME/nix-config#nixos";

      # (optionnel) tout mettre à jour
      rebuild-all = "nix flake update --flake $HOME/nix-config && sudo nixos-rebuild switch --flake $HOME/nix-config#nixos";
      rebuild-test = "sudo nixos-rebuild test   --flake ~/nix-config#nixos";
      rebuild-boot = "sudo nixos-rebuild boot   --flake ~/nix-config#nixos";
      # Divers
      v = "nvim";
      ls = "eza --group-directories-first --icons";
      ll = "eza -l --git";
      la = "eza -la --git";
      # rebuild = "sudo nixos-rebuild switch --flake ~/nix-config#nixos";
    };
  };
}
