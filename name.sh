#!/bin/bash

# Список папок
folders=("project1" "project2" "project3")

# Базовый путь к проектам
base_path="/home/user/projects"

# Расширение файлов
file_ext="xlsx"

# Базовая папка для загрузки
downloads_base="$HOME/Downloads"

# Счётчик для папок
counter=1

for folder in "${folders[@]}"; do
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
done

echo "✅ Все файлы скопированы в папки folder1, folder2 и т.д. в ~/Downloads"
