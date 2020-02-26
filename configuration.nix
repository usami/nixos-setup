{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.initrd.kernelModules = [ "vfat" ];
  boot.earlyVconsoleSetup = true;

  environment.systemPackages = with pkgs; [ git kbfs ];

  services.keybase.enable = true;

  i18n.consoleFont = "ter-i32b";
  i18n.consolePackages = with pkgs; [ terminus_font ];

  users.users.yu = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/yu";
    extraGroups = [ "wheel" ];
    hashedPassword = "$6$K6lTQoT.OXejCKr$r23AvjQurXbgj0wbkOT1UXxRkraHseJbtP3.lVmGqST3MU.fjRcQKsZfERNWj9DoMkdSwY7kBJpHLWmeilHx8.";
  };

  system.stateVersion = "19.09";
}
