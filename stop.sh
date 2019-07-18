#!/usr/bin/env sh

SCRIPT_DIR=$(dirname "$0")
SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)

ps -ef | grep -v "grep " | grep "${SCRIPT_DIR}/api.py"
if [ $? -eq 0 ]
then
  kill -9 $(ps -ef | grep -v "grep " | grep "${SCRIPT_DIR}/api.py" | awk '{print $2}')
fi
