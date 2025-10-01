{ config, lib, pkgs, inputs, ... }:
let
  vicinaeModule = inputs.vicinae.homeManagerModules.default;
  vicinaePkg = inputs.vicinae.packages.${pkgs.system}.default;
  cfg = config.services.vicinae;
in
{
  imports = [ vicinaeModule ];

  services.vicinae = {
    enable = lib.mkDefault true;
    autoStart = lib.mkDefault true;
    package = vicinaePkg;
  };

  xdg.desktopEntries.vicinae = {
    name = "Vicinae";
    comment = "Client Vicinae";
    exec = "${cfg.package or vicinaePkg}/bin/vicinae";
    icon = "vicinae";
    categories = [ "Network" "Utility" ];
    terminal = false;
  };
}
