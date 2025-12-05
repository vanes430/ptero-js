#!/bin/bash
set -e

# --- Timezone ---
TZ=${TZ:-UTC}
export TZ

# --- Detect internal IP ---
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2); exit}')
export INTERNAL_IP

# --- Switch to container directory ---
cd /home/container || exit 1

# --- Load NVM properly ---
export NVM_DIR="/opt/nvm"

# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

# --- Select Node version based on ENV ---
if [[ -n "${NODEJS_VERSION}" ]]; then
    echo -e "\033[33mSelecting Node.js version from NODEJS_VERSION=${NODEJS_VERSION}\033[0m"

    # Validate version exists
    if nvm ls | grep -q "v${NODEJS_VERSION}"; then
        nvm use "${NODEJS_VERSION}" >/dev/null 2>&1 || true
    else
        echo -e "\033[31mRequested Node.js version '${NODEJS_VERSION}' is not installed!\033[0m"
        echo -e "\033[33mFalling back to default Node version...\033[0m"
        nvm use default >/dev/null 2>&1 || true
    fi
else
    # No version provided → use default
    nvm use default >/dev/null 2>&1 || true
fi

# Refresh command hash to avoid PATH caching problems
hash -r

# --- Colors ---
Y="\033[33m"
G="\033[32m"
C="\033[36m"
R="\033[0m"

# --- Banner ---
echo -e "${Y}=========================================${R}"
echo -e "${G}   🚀 Pterodactyl Node Multi-Runtime     ${R}"
echo -e "${Y}=========================================${R}"
echo -e "${C}Internal IP: ${INTERNAL_IP}${R}"
echo -e "${C}Timezone:    ${TZ}${R}"

# Display Node version selected
echo -e "${C}Active Node: $(node -v 2>/dev/null || echo 'Not installed')${R}"
echo -e "${Y}-----------------------------------------${R}"

# --- Print Runtime Versions ---
echo -e "${G}Node.js:${R} $(node -v 2>/dev/null || echo 'Not installed')"
echo -e "${G}npm:    ${R} $(npm -v 2>/dev/null || echo 'Not installed')"
echo -e "${G}yarn:   ${R} $(yarn -v 2>/dev/null || echo 'Not installed')"
echo -e "${G}pnpm:   ${R} $(pnpm -v 2>/dev/null || echo 'Not installed')"
echo -e "${G}bun:    ${R} $(bun -v 2>/dev/null || echo 'Not installed')"

echo -e "${Y}-----------------------------------------${R}"

# --- Safe STARTUP Parser ---
PARSED=$(echo "${STARTUP}" | sed -e 's/{{\([^}]*\)}}/\${\1}/g')

echo -e "${Y}Executing:${R} ${PARSED}"

# --- Execute ---
exec env ${PARSED}
