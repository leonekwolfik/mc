#!/bin/bash
# entrypoint.sh

MOUNT_DIR=""

# 1. Preferencyjnie używamy /data (jeśli istnieje i nie jest pusty)
if [ -d "/data" ] && [ "$(ls -A /data)" ]; then
    MOUNT_DIR="/data"
    echo "Użyto /data (zamontowany wolumen)"
else
    # 2. Fallback: szukaj w /mnt/* i /opt/*
    for dir in /mnt/* /opt/*; do
        if [ -d "$dir" ]; then
            MOUNT_DIR="$dir"
            echo "Użyto auto-detekcji: $MOUNT_DIR"
            break
        fi
    done
fi

# Jeśli nic nie znaleziono, użyj domykłowego katalogu użytkownika
START_DIR="${MOUNT_DIR:-/home/mcuser}"
echo "Startowanie MC w: $START_DIR"

# Zmienna dostępna dla testów bez uruchamiania ttyd
export START_DIR

# Tryb testowy - tylko wykryj katalog, nie uruchamiaj ttyd
if [ "$ENTRYPOINT_TEST_MODE" = "1" ]; then
    echo "$START_DIR"
    exit 0
fi

exec ttyd -W tmux new-session -A -s mc "mc \"$START_DIR\"; bash"
