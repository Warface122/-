#!/bin/bash

USERNAME=$(whoami)

find_percent() {
    local file="$1"
    SERVER=$(basename "$file" | awk -F'_' '{for (i=1; i<=NF; i++) if ($i ~ /\.com$/) print $i}')

    if [[ -z "$SERVER" ]]; then
        echo "⚠️ Не удалось извлечь имя сервера из файла: $file"
        return
    fi

    ssh "$SERVER" "find /SCRATCH/$USERNAME/ -type f -name '*.log'" 2>/dev/null | while read -r log_file; do
        tmp_file="/tmp/$(basename "$log_file")"
        scp "$SERVER:\"$log_file\"" "$tmp_file" > /dev/null 2>&1

        if [[ -f "$tmp_file" ]]; then
            last_percent=$(grep '%' "$tmp_file" | tail -n 1)
            echo "[$SERVER] $last_percent"
            rm -f "$tmp_file"
        else
            echo "⚠️ Не удалось скопировать файл: $log_file с сервера $SERVER"
        fi
    done
}

# Проверка, что скрипт запущен из папки qsub_log
if [[ $(basename "$PWD") != "qsub_log" ]]; then
    echo "❌ Запусти скрипт из папки qsub_log!"
    exit 1
fi

# Обработка всех файлов в текущей директории
for file in *; do
    find_percent "$file" &
done

wait
