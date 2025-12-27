#!/usr/bin/env bash
set -euo pipefail

echo "Test and verify FunnyHat plugin"
read -p "Enter path to BepInEx LogOutput.log [~/Palworld/BepInEx/LogOutput.log]: " log
log=${log:-~/Palworld/BepInEx/LogOutput.log}
log=$(eval echo "$log")

if [ ! -f "$log" ]; then
  echo "Log file not found: $log"
  exit 1
fi

echo "Tailing the log ($log). Start the game now if not running. Press Ctrl-C to stop."

tail -n 200 -f "$log"
