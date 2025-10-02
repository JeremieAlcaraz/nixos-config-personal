{ lib, ... }:
{
  # Let nixos-generators manage the root filesystem via label.
  fileSystems."/" = {
    device = lib.mkForce "/dev/disk/by-label/nixos";
  };

  # Exclude swap devices from the generated image.
  swapDevices = lib.mkForce [ ];
}
