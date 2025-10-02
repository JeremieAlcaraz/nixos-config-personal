{ config
, pkgs
, ...
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

      # Zsh
      reload = "exec zsh";

      # Nix
      rebuild = "nix flake update neovim --flake /home/jeremie/nix-config && sudo nixos-rebuild switch --flake /home/jeremie/nix-config#nixos && exec zsh";
      rebuild-all = "nix flake update --flake $HOME/nix-config && sudo nixos-rebuild switch --flake $HOME/nix-config#nixos";
      rebuild-test = "sudo nixos-rebuild test --flake $HOME/nix-config#nixos";
      rebuild-boot = "sudo nixos-rebuild boot --flake $HOME/nix-config#nixos";
      # Divers
      v = "nvim";
      ls = "eza --group-directories-first --icons";
      ll = "eza -l --git";
      la = "eza -la --git";
      # rebuild = "sudo nixos-rebuild switch --flake ~/nix-config#nixos";
    };
  };
}
