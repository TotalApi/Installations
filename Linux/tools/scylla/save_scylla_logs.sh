#!/bin/bash

# ������� ���� � �����, ���� ����� ����������� ����
LOG_FILE="/var/log/scylla/scylla.log"
CURSOR_FILE="/var/log/scylla/.journal_cursor"

mkdir -p $(dirname "$LOG_FILE")

journalctl -u scylla-server --cursor-file="$CURSOR_FILE" --quiet >> "$LOG_FILE"

# ������� ������ systemd ��� �������� ����� (�����������)
journalctl --rotate 2> /dev/null
journalctl --vacuum-time=1d 2> /dev/null