#!/bin/bash

# Получение имени пользователя
USERNAME=$(whoami)

# Функция для поиска и вывода последнего символа '%'
find_percent() {
    local file="$1"
    local server=$(basename "$file" | grep -oP '(?<=_.*?_).*?\.com')
    
    ssh "$server" "find /SCRATCH/$USERNAME/ -type f \( -name '*.log' -o -name '*.log0' \)" | while read -r log_file; do
        scp "$server:$log_file" /tmp/
        local last_percent=$(grep -o '%.*' /tmp/$(basename "$log_file") | tail -n 1)
        echo "File: $log_file"
        echo "Last occurrence of '%': $last_percent"
    done
}

# Поиск файлов в текущей директории (qsub_log) и выполнение функции в фоновом режиме
for file in *; do
    find_percent "$file" &
done

# Сохраните этот скрипт в файл, например, `find_percent.sh`, и сделайте его исполняемым:
# chmod +x find_percent.sh

# Затем вы можете запустить его из папки qsub_log:
# cd qsub_log
# ../find_percent.sh
