{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "vfat" ];

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
