#!/bin/bash
# entrypoint.sh

MOUNT_DIR=""

for dir in /*/; do
    dirname=$(basename "$dir")

    if grep -qx "$dirname" /etc/system_dirs_snapshot.txt; then
        continue
    fi

    [[ "$dirname" == .* ]] && continue

    MOUNT_DIR="/$dirname"
    break
done

if [ -z "$MOUNT_DIR" ]; then
    for dir in /mnt/* /opt/*; do
        [ -d "$dir" ] && MOUNT_DIR="$dir" && break
    done
fi

START_DIR="${MOUNT_DIR:-/root}"
echo "Startowanie MC w: $START_DIR"

# Zmienna dostępna dla testów bez uruchamiania ttyd
export START_DIR

# Tryb testowy - tylko wykryj katalog, nie uruchamiaj ttyd
if [ "$ENTRYPOINT_TEST_MODE" = "1" ]; then
    echo "$START_DIR"
    exit 0
fi

exec ttyd -W bash -c "mc \"$START_DIR\"; bash"