#!/bin/bash

# Укажите путь к файлу, куда будут сохраняться логи
LOG_FILE="/var/log/influxdb/influxdb.log"
CURSOR_FILE="/var/log/influxdb/.journal_cursor"

mkdir -p $(dirname "$LOG_FILE")

journalctl -u influxdb.service --cursor-file="$CURSOR_FILE" --quiet >> "$LOG_FILE"

# Очищаем журнал systemd для экономии места (опционально)
journalctl --rotate 2> /dev/null
journalctl --vacuum-time=1d 2> /dev/null