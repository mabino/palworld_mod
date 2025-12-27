#!/usr/bin/env bash
set -euo pipefail

# Colors
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${BLUE}Test and verify FunnyHat plugin${RESET}"
read -p "Enter path to BepInEx LogOutput.log [~/Palworld/BepInEx/LogOutput.log]: " log
log=${log:-~/Palworld/BepInEx/LogOutput.log}
log=$(eval echo "$log")

if [ ! -f "$log" ]; then
  echo -e "${RED}Log file not found:${RESET} $log"
  exit 1
fi

echo -e "${GREEN}Tailing the log:${RESET} $log\n${YELLOW}Start the game if not running. Press Ctrl-C to stop.${RESET}"

tail -n 200 -f "$log"
