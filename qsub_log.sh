#!/bin/bash

USERNAME=$(whoami)

find_percent() {
    local file="$1"
    SERVER=$(basename "$file" | awk -F'_' '{print $3}' | sed -E 's/(.*\.com).*/\1/')

    ssh "$SERVER" "find /SCRATCH/$USERNAME/ -type f -name '*.log'" 2>/dev/null | while read -r log_file; do
        # Считываем последнюю строку с символом %
        ssh "$SERVER" "grep '%' \"$log_file\" | tail -n 1" | while read -r percent_line; do
            echo "[$SERVER] $percent_line"
        done
    done
}

# Проверка, что скрипт запущен из папки qsub_log
if [[ $(basename "$PWD") != "qsub_log" ]]; then
    echo "❌ Пожалуйста, запустите скрипт из папки qsub_log!"
    exit 1
fi

# Обработка всех файлов в текущей директории
for file in *; do
    find_percent "$file" &
done

wait
