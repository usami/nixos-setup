{ config, pkgs, ... }:

let
finish-setup = pkgs.writeScriptBin "finish-setup" ''
  #!${pkgs.stdenv.shell}

  set -eufx -o pipefail

  keybase login --devicename="setup $(uuidgen | cut -d '-' -f 1)"

  git clone keybase://private/yusmi/nixos
  git clone keybase://private/yusmi/dotconfig

  cp /etc/nixos/hardware-configuration.nix /home/yu/nixos
  sudo rm -rf /etc/nixos
  sudo ln -s /home/yu/nixos /etc/nixos
  rm -rf .config
  ln -s dotconfig .config

  sudo nixos-rebuild switch
  reboot
'';

in {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "vfat" ];
  boot.earlyVconsoleSetup = true;

  environment.systemPackages = with pkgs; [ git kbfs finish-setup ];

  services.keybase.enable = true;
  programs.ssh.startAgent = true;

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
