# Module Waybar (Home Manager)
{ config
, pkgs
, ...
}:
{
  # ╭──────────────────────────────────────────────────────────────╮
  # │                            WAYBAR                            │
  # ╰──────────────────────────────────────────────────────────────╯
  programs.waybar = {
    enable = true; # active Waybar
    systemd.enable = true;
    package = pkgs.waybar; # (optionnel : version depuis nixpkgs)

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "niri/workspaces" ];
        modules-center = [ ];
        modules-right = [ "clock" "cpu" "memory" ];
      };
    };

    style = ''
      * { font-family: "FiraCode Nerd Font"; font-size: 11pt; }
      #clock { margin: 0 8px; }
    '';
  };
}
