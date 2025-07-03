#!/bin/bash

USERNAME=$(whoami)

open_log() {
    local file="$1"
    SERVER=$(basename "$file" | awk -F'_' '{print $3}' | sed -E 's/(.*\.com).*/\1/')

    ssh "$SERVER" "find /SCRATCH/$USERNAME/ -type f -name '*.log' | head -n 1 | xargs less"
}

if [[ $(basename "$PWD") != "qsub_log" ]]; then
    echo "❌ Запусти скрипт из папки qsub_log!"
    exit 1
fi

for file in *; do
    open_log "$file" &
done

wait
