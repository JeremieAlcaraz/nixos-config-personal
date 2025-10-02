# Module Alacritty (Home Manager)
{ config
, pkgs
, ...
}:
{
  # ╭──────────────────────────────────────────────────────────────╮
  # │                          ALACRITTY                           │
  # ╰──────────────────────────────────────────────────────────────╯
  programs.alacritty.enable = true;

  xdg.configFile."alacritty/alacritty.toml".source = ./alacritty.toml;
}
