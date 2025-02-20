#!/bin/bash

# ������� ���� � �����, ���� ����� ����������� ����
LOG_FILE="/var/log/influxdb/influxdb.log"
CURSOR_FILE="/var/log/influxdb/.journal_cursor"

mkdir -p $(dirname "$LOG_FILE")

journalctl -u influxdb.service --cursor-file="$CURSOR_FILE" --quiet >> "$LOG_FILE"

# ������� ������ systemd ��� �������� ����� (�����������)
journalctl --rotate 2> /dev/null
journalctl --vacuum-time=1d 2> /dev/null