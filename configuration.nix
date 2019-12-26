{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;

  boot = {
    initrd = {
      kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
      luks = {
        cryptoModules = [ "aes" "xts" "sha512" ];
        yubikeySupport = true;
        devices = [ {
          name = "crypted";
          device = "/dev/nvme0n1p1";
          preLVM = true;
          yubikey = {
            slot = 2;
            twoFactor = false;
            storage = {
              device = "/dev/nvme0n1p3";
            };
          };
        } ];
      };
    };
  };

  swapDevices = [ { device = "/dev/nvme0n1p2"; } ];

  fileSystems."/" = {
    label = "root";
    device = "/dev/mapper/crypted";
    fsType = "btrfs";
    options = [ "subvol=nixos" ];
  };

  fileSystems."/boot" = {
    label = "uefi";
    device = "/dev/nvme0n1p3";
    fsType = "vfat";
  };

  environment.systemPackages = with pkgs; [ git kbfs ];

  services.keybase.enable = true;

  users.users.yu = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/yu";
    extraGroups = [ "wheel" ];
    hashedPassword = "$6$K6lTQoT.OXejCKr$r23AvjQurXbgj0wbkOT1UXxRkraHseJbtP3.lVmGqST3MU.fjRcQKsZfERNWj9DoMkdSwY7kBJpHLWmeilHx8.";
  };

  system.stateVersion = "19.09";
}
