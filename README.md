# Create Bootable USB Drive

1. Download the lates NixOS image from [here](https://nixos.org/nixos/download.html)

1. Insert USB drive

1. Write the image to the USB drive:

```sh
# dd if=path-to-image of=/dev/sdb # specify whole device, not partition
```

# Install from the Bootable USB

1. Disable Secure Boot in BIOS

1. Change Graphics to Discrete Graphics if using Hybrid Graphics (Config -> Display -> Graphics Device)

1. Boot from the USB

1. Insert ethernet cable

> For easy setup, the following command does install in one script.
> ```sh
> $ sudo su root
> # curl -o start https://raw.githubusercontent.com/usami/nixos-setup/master/start
> # chmod +x start
> # ./start
> ```

1. Create partitions [ref](https://nixos.org/nixos/manual/index.html#sec-installation-partitioning-UEFI)

```sh
$ sudo su root
# curl -o partition https://raw.githubusercontent.com/usami/nixos-setup/master/partition
# chmod +x partition
# ./partition /dev/nvme0n1
```

1. Insert yubikey

1. Setup crypted volume

```sh
# curl -o setup https://raw.githubusercontent.com/usami/nixos-setup/master/setup
# chmod +x setup
# ./setup /dev/nvme0n1p1 /dev/nvme0n1p2 /dev/nvme0n1p3
```

1. Get minimal setup configuration

```sh
# cd /mnt/etc/nixos
# rm configuration.nix
# curl -o configuration.nix https://raw.githubusercontent.com/usami/nixos-setup/master/configuration.nix
```

1. Install and reboot

```sh
# nixos-install
# reboot
```

# Setup

> For easy setup, `finish-setup` command does all the following steps.

1. Login as user `yu` (initial password: `asdf`)

1. Add new device

```sh
$ keybase login
```

1. Clone nixos config git

```sh
$ git clone keybase://private/yusmi/nixos
```

1. Clone dotconfig git

```sh
$ git clone keybase://private/yusmi/dotconfig
```

1. Create symbolic links

```sh
$ cp /etc/nixos/hardware-configuration.nix /home/yu/nixos/
$ sudo rm -rf /etc/nixos
$ sudo ln -s /home/yu/nixos /etc/nixos
$ rm -rf .config
$ ln -s dotconfig .config
```

1. Rebuild
```sh
$ sudo nixos-rebuild switch
```
