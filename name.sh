#!/bin/bash

# Путь к папке, где находятся все указанные папки
base_path="/your/base/path"  # ЗАМЕНИТЕ на ваш путь

# Путь к файлу со списком папок
folders_file="folders.txt"

# Базовая папка для загрузки
downloads_base="$HOME/Downloads"

# Расширение файлов
file_ext="xlsx"

# Счётчик для папок
counter=1

# Проверка наличия файла со списком папок
if [ ! -f "$folders_file" ]; then
    echo "❌ Файл $folders_file не найден!"
    exit 1
fi

# Чтение каждой строки из файла
while IFS= read -r folder; do
    report_path="$base_path/$folder/report"
    target_folder="$downloads_base/folder$counter"

    if [ -d "$report_path" ]; then
        echo "📁 Создаю папку: $target_folder"
        mkdir -p "$target_folder"

        echo "🔍 Ищу .${file_ext} в $report_path"
        find "$report_path" -type f -name "*.${file_ext}" | while read -r file; do
            echo "⬇️ Копирую: $file → $target_folder"
            cp "$file" "$target_folder/"
        done
    else
        echo "⚠️ Папка report не найдена в $folder"
    fi

    ((counter++))
done < "$folders_file"

echo "✅ Все файлы скопированы в папки folder1, folder2 и т.д. в ~/Downloads"
