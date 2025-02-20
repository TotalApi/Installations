#!/bin/bash

systemctl daemon-reload
sudo systemctl enable ./save_influxdb_logs.service
sudo systemctl enable ./save_influxdb_logs.timer
sudo systemctl start save_influxdb_logs.timer
