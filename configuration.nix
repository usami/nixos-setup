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
      device = "/dev/nvme0n1p1";
      fsType = "vfat";
    };
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

  system.stateVersion = "19.03";
}
