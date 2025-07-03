#!/bin/bash

USERNAME=$(whoami)
declare -A seen_servers

find_percent() {
    local file="$1"
    SERVER=$(basename "$file" | awk -F'_' '{print $3}' | sed -E 's/(.*\.com).*/\1/')

    # Пропускаем, если сервер уже обрабатывался
    if [[ ${seen_servers[$SERVER]} ]]; then
        return
    fi
    seen_servers[$SERVER]=1

    # Находим только один .log файл
    ssh "$SERVER" "find /SCRATCH/$USERNAME/ -type f -name '*.log' | head -n 1" 2>/dev/null | while read -r log_file; do
        # Копируем лог-файл во временную папку
        scp "$SERVER:$log_file" /tmp/ > /dev/null

        # Ищем последнюю строку с %
        last_percent=$(grep '%' /tmp/$(basename "$log_file") | tail -n 1)

        # Выводим результат
        echo "[$SERVER] $last_percent"
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
