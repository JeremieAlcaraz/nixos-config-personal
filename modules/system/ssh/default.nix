{ lib, config, pkgs, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;   # mets à false après test
      PubkeyAuthentication = true;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users.jeremie.openssh.authorizedKeys.keys = [
    # Colle ta clé publique de ton Mac ici
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKmKLrSci3dXG3uHdfhGXCgOXj/ZP2wwQGi36mkbH/YM jeremie@mac"
  ];
}
