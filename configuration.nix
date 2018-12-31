{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
      luks = {
        cryptoModules = [ "aes" "xts" "sha512" ];
        yubikeySupport = true;
        devices = {
          "crypted" = {
            device = "/dev/nvme0n1p2";
            preLVM = true;
            yubikey = {
              twoFactor = false;
              gracePeriod = 60;
              storage.device = "/dev/nvme0n1p1";
            };
          };
        };
      };
    };
  };

  swapDevices = [
    { label = "swap"; }
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/root";
      fsType = "ext4";
      options = [ "noatime" "nodiratime" "discard" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  system.stateVersion = "18.09";
}
