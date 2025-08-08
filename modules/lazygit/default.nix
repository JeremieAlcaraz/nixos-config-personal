{ config, pkgs, ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      # Exemples utiles, modifie à ton goût :
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --line-numbers";
        };
      };
      gui = {
        nerdFontsVersion = "3";
        scrollHeight = 8;
        showFileTree = true;
      };
      keybinding = { universal = { quit = "q"; }; };
    };
  };
}
