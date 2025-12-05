#!/bin/bash

# TZ
TZ=${TZ:-UTC}
export TZ

# INTERNAL_IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

cd /home/container || exit 1

# Load NVM correctly
export NVM_DIR="/opt/nvm"
# shellcheck disable=SC1091
source "$NVM_DIR/nvm.sh"

# Colors
Y="\033[33m"
G="\033[32m"
C="\033[36m"
R="\033[0m"

# Banner
echo -e "${Y}=========================================${R}"
echo -e "${G}   🚀 Pterodactyl Node Multi-Runtime     ${R}"
echo -e "${Y}=========================================${R}"
echo -e "${C}Internal IP: ${INTERNAL_IP}${R}"
echo -e "${C}Timezone:    ${TZ}${R}"
echo -e "${Y}-----------------------------------------${R}"

# Print runtimes
echo -e "${G}Node.js: ${R}$(node -v 2>/dev/null || echo 'Not installed')"
echo -e "${G}npm:     ${R}$(npm -v 2>/dev/null || echo 'Not installed')"
echo -e "${G}yarn:    ${R}$(yarn -v 2>/dev/null || echo 'Not installed')"
echo -e "${G}pnpm:    ${R}$(pnpm -v 2>/dev/null || echo 'Not installed')"
echo -e "${G}bun:     ${R}$(bun -v 2>/dev/null || echo 'Not installed')"

echo -e "${Y}-----------------------------------------${R}"

# Parse STARTUP template (Pterodactyl)
PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")

echo -e "${Y}Executing:${R} ${PARSED}"

# Execute command
exec env ${PARSED}
