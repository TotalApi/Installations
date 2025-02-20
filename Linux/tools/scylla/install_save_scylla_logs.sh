#!/bin/bash

systemctl daemon-reload
sudo systemctl enable ./save_scylla_logs.service
sudo systemctl enable ./save_scylla_logs.timer
sudo systemctl start save_scylla_logs.timer
