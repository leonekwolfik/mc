#!/bin/bash
# entrypoint.sh

MOUNT_DIR=""

for dir in /*/; do
    dirname=$(basename "$dir")

    # Pomiń jeśli istniał już podczas budowania obrazu
    if grep -qx "$dirname" /etc/system_dirs_snapshot.txt; then
        continue
    fi

    # Pomiń ukryte
    [[ "$dirname" == .* ]] && continue

    MOUNT_DIR="/$dirname"
    break
done

# Sprawdź też /mnt/* i /opt/* na wszelki wypadek
if [ -z "$MOUNT_DIR" ]; then
    for dir in /mnt/* /opt/*; do
        [ -d "$dir" ] && MOUNT_DIR="$dir" && break
    done
fi

START_DIR="${MOUNT_DIR:-/root}"
echo "Startowanie MC w: $START_DIR"

exec ttyd -W bash -c "mc \"$START_DIR\"; bash"