#!/bin/bash

# Путь к базовой директории, где находятся папки
base_path="/your/base/path"

# Путь к файлу со списком папок
folders_file="folders.txt"

# Базовая директория для сохранения
downloads_base="$HOME/Downloads"

# Счётчик для папок folder1, folder2, ...
counter=1

# Чтение списка папок из файла
while IFS= read -r folder; do
    # Путь к папке report (предполагаем, что она существует)
    report_path="$base_path/$folder/report"

    # Целевая папка для копирования
    target_folder="$downloads_base/folder$counter"
    mkdir -p "$target_folder"

    echo "📁 Копирую .xlsx файлы из $report_path → $target_folder"

    # Копирование всех .xlsx и .XLSX файлов
    find "$report_path" -type f \( -iname "*.xlsx" -o -iname "*.XLSX" \) -exec cp {} "$target_folder/" \;

    ((counter++))
done < "$folders_file"

echo "✅ Готово: все файлы скопированы."
