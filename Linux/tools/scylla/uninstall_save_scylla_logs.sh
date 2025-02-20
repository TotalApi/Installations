#!/bin/bash

systemctl daemon-reload
systemctl stop save_scylla_logs.timer
systemctl disable save_scylla_logs.timer
systemctl disable save_scylla_logs.service
