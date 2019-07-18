#!/usr/bin/env sh

SCRIPT_DIR=$(dirname "$0")
SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)

sh ${SCRIPT_DIR}/stop.sh
nohup python3 ${SCRIPT_DIR}/api.py >> /dev/null &
