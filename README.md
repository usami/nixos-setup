# Create Bootable USB Drive

1. Download the lates NixOS image from [here](https://nixos.org/nixos/download.html)
1. Insert USB drive
1. Write the image to the USB drive:
```
# dd if=path-to-image of=/dev/sdX
```

# Install from the Bootable USB
1. Boot from the USB
1. Insert ethernet cable
1. Create partitions [ref](https://nixos.org/nixos/manual/index.html#sec-installation-partitioning-UEFI)
1. Get setup script
1. Run setup.sh:
```
# ./setup.sh /dev/sdX[boot partition] /dev/sdX[luks partition]
```
1. Generate config:
```
# nixos-generate-config --root /mnt
```
1. Setup keybase
