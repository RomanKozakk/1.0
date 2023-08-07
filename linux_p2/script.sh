#!/bin/bash

# Визначення шляху до директорії та дати
source_dir="/d/study devops/1.0/linux_p2"
backup_dir="$source_dir/backup"
old_backup_dir="$source_dir/old_backup"
current_date=$(date +%Y-%m-%d)
old_date=$(date -d "3 minutes ago" +%Y-%m-%d)

# Створення директорій backup та old_backup, якщо вони не існують
mkdir -p "$backup_dir" "$old_backup_dir"

# Цикл для архівації та переміщення старих архівів
for i in {1..20}; do
    file="$source_dir/$i.txt"
    if [ -f "$file" ]; then
        base_name=$(basename "$file")
        echo "Архівую файл: $base_name"
        tar -czf "$backup_dir/${base_name}_${current_date}.tar.gz" "$file"

        # Перевірка, чи файл старший за 3 хвилини
        if [[ $(stat -c %Y "$file") -lt $(date -d "3 minutes ago" +%s) ]]; then
            mv "$backup_dir/${base_name}_${current_date}.tar.gz" "$old_backup_dir/"
        fi
    fi
done

echo "Архівація та переміщення завершено."

# Додати крон-завдання
(crontab -l ; echo "*/5 * * * * $(which bash) $PWD/script.sh") | crontab -

