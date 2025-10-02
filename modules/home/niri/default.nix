# Module Niri (Home Manager)
{ config
, pkgs
, ...
}:
{
  # ╭──────────────────────────────────────────────────────────────╮
  # │                            NIRI (HM)                         │
  # ╰──────────────────────────────────────────────────────────────╯
  xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
