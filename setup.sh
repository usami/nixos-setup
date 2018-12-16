BOOT_PARTITION="$1" # e.g. /dev/sda3
LUKS_PARTITION="$2"
SALT_LENGTH=16
KEY_LENGTH=512
ITERATIONS=1000000
CIPHER=aes-xts-plain64
HASH=sha512
SLOT=2
LUKSROOT=crypted
VGNAME=cryptedpool
FSROOT=root
SWAP_SIZE=16GiB

setup_boot_partition() {
        label="$1"
        mount_point="$2"

        mkfs.fat -F 32 -n "$label" "$BOOT_PARTITION"
        mkdir -p "$mount_point"
        mount /dev/disk/by-label/$label "$mount_point"
}

rbtohex() {
        ( od -An -vtx1 | tr -d ' \n' )
}

hextorb() {
        ( tr '[:lower:]' '[:upper:]' | sed -e 's/\([0-9A-F]\{2\}\)/\\\\\\x\1/gI' | xargs printf )
}

setup_crypt() {
        boot_dir="$1"

        nix-env -i gcc-wrapper
        nix-env -i yubikey-personalization
        nix-env -i openssl
        cc -O3 -I$(find / | grep "openssl/evp\.h" | head -1 | sed -e 's|/openssl/evp\.h$||g' | tr -d '\n') \
                -L$(find / | grep "lib/libcrypto" | head -1 | sed -e 's|/libcrypto\..*$||g' | tr -d '\n') \
                $(find / | grep "pbkdf2-sha512\.c" | head -1 | tr -d '\n') -o ./pbkdf2-sha512 -lcrypto

        salt="$(dd if=/dev/random bs=1 count=$SALT_LENGTH 2>/dev/null | rbtohex)"

        k_yubi="$(dd if=/dev/random bs=1 count=20 2>/dev/null | rbtohex)"
        ykpersonalize -"$SLOT" -ochal-resp -ochal-hmac -a"$k_yubi"

        challenge="$(echo -n $salt | openssl dgst -binary -sha512 | rbtohex)"
        response="$(echo -n $challenge | hextorb | openssl dgst -binary -sha1 -mac HMAC -macopt hexkey:$k_yubi | rbtohex)"

        k_luks="$(echo | ./pbkdf2-sha512 $(($KEY_LENGTH / 8)) $ITERATIONS $response | rbtohex)"

        echo -n "$k_luks" | hextorb | cryptsetup luksFormat --cipher="$CIPHER" --key-size="$KEY_LENGTH" --hash="$HASH" --key-file=- "$LUKS_PARTITION"

        storage=/crypt-storage/default
        mkdir -p "$(dirname $boot_dir$storage)"
        echo -ne "$salt\n$ITERATIONS" > "$boot_dir$storage"
        echo -n "$k_luks" | hextorb | cryptsetup luksOpen --key-file=- "$LUKS_PARTITION" "$LUKSROOT"
}

setup_luks_partition() {
        pvcreate "/dev/mapper/$LUKSROOT"

        vgcreate "$VGNAME" "/dev/mapper/$LUKSROOT"

        lvcreate -L "$SWAP_SIZE" -n swap "$VGNAME"
        lvcreate -l 100%FREE -n "$FSROOT" "$VGNAME"

        vgchange -ay

        mkfs.ext4 -L "$FSROOT" "/dev/$VGNAME/$FSROOT"
        mkswap -L swap "/dev/$VGNAME/swap"

        mount "/dev/$VGNAME/$FSROOT" /mnt
        swapon "/dev/$VGNAME/swap"
}

boot_dir=/mnt/boot
setup_boot_partition boot "$boot_dir"
setup_crypt "$boot_dir"
setup_luks_partition
