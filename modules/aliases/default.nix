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
      rebuild = "sudo nixos-rebuild switch --flake .#nixos";

      # Divers
      v = "nvim";
      ls = "eza --group-directories-first --icons";
      ll = "eza -l --git";
      la = "eza -la --git";
      # rebuild = "sudo nixos-rebuild switch --flake ~/nix-config#nixos";
      rebuild-test = "sudo nixos-rebuild test   --flake ~/nix-config#nixos";
      rebuild-boot = "sudo nixos-rebuild boot   --flake ~/nix-config#nixos";
    };
  };
}
