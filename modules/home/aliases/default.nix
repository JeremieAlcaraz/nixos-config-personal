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
      rebuild = ''
        repo_root="$(git rev-parse --show-toplevel 2>/dev/null || echo "$HOME/nix-config")" &&
        target="$NIXOS_FLAKE_HOST" &&
        { [ -n "$target" ] || target="nixos"; } &&
        nix flake update neovim --flake "$repo_root" &&
        sudo nixos-rebuild switch --flake "$repo_root#$target" &&
        exec zsh
      '';
      rebuild-all = ''
        repo_root="$(git rev-parse --show-toplevel 2>/dev/null || echo "$HOME/nix-config")" &&
        target="$NIXOS_FLAKE_HOST" &&
        { [ -n "$target" ] || target="nixos"; } &&
        nix flake update --flake "$repo_root" &&
        sudo nixos-rebuild switch --flake "$repo_root#$target"
      '';
      rebuild-test = ''
        repo_root="$(git rev-parse --show-toplevel 2>/dev/null || echo "$HOME/nix-config")" &&
        target="$NIXOS_FLAKE_HOST" &&
        { [ -n "$target" ] || target="nixos"; } &&
        sudo nixos-rebuild test --flake "$repo_root#$target"
      '';
      rebuild-boot = ''
        repo_root="$(git rev-parse --show-toplevel 2>/dev/null || echo "$HOME/nix-config")" &&
        target="$NIXOS_FLAKE_HOST" &&
        { [ -n "$target" ] || target="nixos"; } &&
        sudo nixos-rebuild boot --flake "$repo_root#$target"
      '';
      # Divers
      v = "nvim";
      ls = "eza --group-directories-first --icons";
      ll = "eza -l --git";
      la = "eza -la --git";
      # rebuild = "sudo nixos-rebuild switch --flake ~/nix-config#nixos";
    };
  };
}
