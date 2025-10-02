# Module Navi (Home Manager)
{ config
, pkgs
, ...
}:
{
  # ╭──────────────────────────────────────────────────────────────╮
  # │                             NAVI                             │
  # ╰──────────────────────────────────────────────────────────────╯
  programs.navi.enable = true;

  # Cheatsheets personnelles
  xdg.dataFile."navi/cheats".source = ./cheats;
}
