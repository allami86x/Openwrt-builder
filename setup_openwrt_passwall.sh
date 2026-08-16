#!/usr/bin/env bash
#
# Setup script for building OpenWrt 24.10.7 with the Passwall feed added.
# Each step is checked after it runs; if a step fails, the script stops with an error message.
#
# Usage:
#   chmod +x setup_openwrt_passwall.sh
#   ./setup_openwrt_passwall.sh
#
set -uo pipefail

# --- Helper function: runs a command and checks its result ---
run_step() {
    local description="$1"
    shift
    echo ">>> Running: ${description}"
    if "$@"; then
        echo "OK: ${description}"
        echo ""
    else
        echo "ERROR: step '${description}' failed. Stopping script." >&2
        exit 1
    fi
}

# 1) Update the apt package list
run_step "apt update" sudo apt update

# 2) Build the list of build dependencies
#    Note: python3-distutils was removed from the repos on Ubuntu 22.04+ / newer Debian
#    (Python 3.12+), so we check for it before installing so the whole install step
#    doesn't fail if it's missing on this system.
PKG_LIST=(build-essential file libncurses-dev zlib1g-dev gawk git gettext libssl-dev xsltproc rsync wget unzip python3)

if apt-cache show python3-distutils >/dev/null 2>&1; then
    PKG_LIST+=(python3-distutils)
else
    echo "WARNING: python3-distutils is not available on this system, removed from the install list."
    echo ""
fi

# 3) Install build dependencies
run_step "Install build dependencies" sudo apt install -y "${PKG_LIST[@]}"

# 4) Clone the OpenWrt repository
run_step "Clone openwrt/openwrt" git clone https://github.com/openwrt/openwrt.git

# 5) Enter the openwrt directory
run_step "Enter openwrt directory" cd openwrt

# 6) Check out release 24.10.7
#    Note: the actual git tag for this release is v24.10.7 (lowercase v prefix),
#    not openwrt-24.10.7.
run_step "Checkout v24.10.7" git checkout v24.10.7

# 7) Add the Passwall feeds to feeds.conf.default (only if not already present)
FEEDS_FILE="feeds.conf.default"
LINE1="src-git passwall https://github.com/Openwrt-Passwall/openwrt-passwall2"
LINE2="src-git passwalldepend https://github.com/Openwrt-Passwall/openwrt-passwall-packages"

echo ">>> Running: add Passwall feeds to ${FEEDS_FILE}"
if grep -qF "${LINE1}" "${FEEDS_FILE}" 2>/dev/null; then
    echo "OK: Passwall feeds already present in the file, skipping."
    echo ""
else
    if printf '%s\n%s\n' "${LINE1}" "${LINE2}" >> "${FEEDS_FILE}"; then
        echo "OK: Passwall feeds added to ${FEEDS_FILE}."
        echo ""
    else
        echo "ERROR: failed to add lines to ${FEEDS_FILE}. Stopping script." >&2
        exit 1
    fi
fi

# 8) Update feeds
run_step "./scripts/feeds update -a" ./scripts/feeds update -a

# 9) Install feeds
run_step "./scripts/feeds install -a" ./scripts/feeds install -a

echo "All steps completed successfully."
