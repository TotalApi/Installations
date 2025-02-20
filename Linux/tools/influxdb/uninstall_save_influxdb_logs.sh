#!/bin/bash

systemctl daemon-reload
systemctl stop save_influxdb_logs.timer
systemctl disable save_influxdb_logs.timer
systemctl disable save_influxdb_logs.service
