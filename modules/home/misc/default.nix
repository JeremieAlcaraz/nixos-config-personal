{ config, pkgs, ... }:

{
  ## zoxide (cd intelligent)
  programs.zoxide.enable = true;

  ## eza (remplaçant moderne de ls)
  programs.eza.enable = true;

  ## starship (prompt moderne)
  programs.starship = {
    enable = true; # installe starship + complétions
    enableZshIntegration = true;
    # enableBashIntegration = true;
    # enableFishIntegration = true;
  };
}
