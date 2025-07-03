find_percent() {
    local file="$1"

    # Извлекаем имя сервера: всё после второго "_" до ".com"
    SERVER=$(echo "$file" | awk -F'_' '{print $3}' | grep -o '[^_]*\.com')

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
