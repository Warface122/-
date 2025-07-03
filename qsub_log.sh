#!/bin/bash

USERNAME=$(whoami)

find_percent() {
    local file="$1"
    SERVER=$(basename "$file" | awk -F'_' '{print $3}' | sed -E 's/(.*\.com).*/\1/')

    ssh "$SERVER" "find /SCRATCH/$USERNAME/ -type f \( -name '*.log' -o -name '*.log0' \)" 2>/dev/null | while read -r log_file; do
        scp "$SERVER:$log_file" /tmp/ > /dev/null
        last_percent=$(grep '%' /tmp/$(basename "$log_file") | tail -n 1)
        echo "[$SERVER] $last_percent"
    done
}

if [[ $(basename "$PWD") != "qsub_log" ]]; then
    echo "❌ Запусти скрипт из папки qsub_log!"
    exit 1
fi

for file in *; do
    find_percent "$file" &
done

wait
