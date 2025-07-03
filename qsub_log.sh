#!/bin/bash

# Получение имени пользователя
USERNAME=$(whoami)

# Функция для поиска и вывода последнего символа '%'
find_percent() {
    local file="$1"

    # Извлечение имени сервера из названия файла
    SERVER=$(basename "$file" | awk -F'_' '{print $3}' | sed -E 's/(.*\.com).*/\1/')

    echo "🔍 Обрабатываю файл: $file"
    echo "🌐 Извлечён сервер: $SERVER"

    echo "📡 Подключаюсь к $SERVER и ищу .log/.log0 в /SCRATCH/$USERNAME/..."
    ssh "$SERVER" "find /SCRATCH/$USERNAME/ -type f \( -name '*.log' -o -name '*.log0' \)" 2>/dev/null | while read -r log_file; do
        echo "📁 Найден лог-файл: $log_file"
        echo "⬇️ Копирую файл с сервера..."
        scp "$SERVER:$log_file" /tmp/ > /dev/null

        echo "🔎 Ищу последнюю строку с %..."
        #last_percent=$(grep -o '%.*' /tmp/$(basename "$log_file") | tail -n 1)
        last_percent=$(grep '%' /tmp/$(basename "$log_file") | tail -n 1)

        echo "✅ [$SERVER] $log_file → $last_percent"
    done
}

# Проверка, что скрипт запущен из qsub_log
if [[ $(basename "$PWD") != "qsub_log" ]]; then
    echo "❌ Пожалуйста, запустите скрипт из папки qsub_log!"
    exit 1
fi

# Поиск файлов в текущей директории и выполнение функции в фоне
for file in *; do
    find_percent "$file" &
done

# Ждём завершения всех фоновых задач
wait

echo "🎉 Готово!"
