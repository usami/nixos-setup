# Create Bootable USB Drive

1. Download the lates NixOS image from [here](https://nixos.org/nixos/download.html)
1. Insert USB drive
1. Write the image to the USB drive:
```
# dd if=path-to-image of=/dev/sdb # specify whole device, not partition
```

# Install from the Bootable USB
1. Disable Secure Boot in BIOS
1. Change Graphics to Discrete Graphics if using Hybrid Graphics (Config -> Display -> Graphics Device)
1. Boot from the USB
1. Insert ethernet cable
1. Create partitions [ref](https://nixos.org/nixos/manual/index.html#sec-installation-partitioning-UEFI)
```
# nix-env -i wget
# wget https://raw.githubusercontent.com/usami/nixos-setup/master/partition
# chmod +x partition
# ./partition /dev/nvme0n1
```
1. Insert yubikey
1. Setup crypted volume
```
# wget https://raw.githubusercontent.com/usami/nixos-setup/master/setup
# chmod +x setup
# ./setup /dev/nvme0n1p1 /dev/nvme0n1p2 /dev/nvme0n1p3
```
1. Get minimal setup configuration
```
# cd /mnt/etc/nixos
# rm configuration.nix
# wget https://raw.githubusercontent.com/usami/nixos-setup/master/configuration.nix
```
1. Remove filesystem entries in hardware.nix
1. Install and reboot
```
# nixos-install
# reboot
```

# Setup keybase
1. Login as user `yu` (initial password: `asdf`)
1. Add new device
```
$ keybase login
```

# Setup
1. Clone nixos config git
```
$ git clone keybase://private/yusmi/nixos
```
1. Clone dotconfig git
```
$ git clone keybase://private/yusmi/dotconfig
```
1. Create symbolic links
```
$ sudo rm -rf /etc/nixos
$ sudo ln -s /home/yu/nixos /etc/nixos
$ rm -rf .config
$ ln -s dotconfig .config
```
1. Rebuild
```
$ sudo nixos-rebuild switch
```
