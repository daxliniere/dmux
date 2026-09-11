#!/usr/bin/env bash

# dmux installer v1.3.6

set -euo pipefail

REPO_URL="https://github.com/daxliniere/dmux.git"
INSTALL_PATH="/usr/bin/dmux"
TMP_DIR=""

cleanup() {
    if [[ -n "${TMP_DIR}" && -d "${TMP_DIR}" ]]; then
        rm -rf "${TMP_DIR}"
    fi
}

ensure_command() {
    local command_name
    local package_name

    command_name="$1"
    package_name="$2"

    if command -v "${command_name}" >/dev/null 2>&1; then
        return 0
    fi

    if command -v apt-get >/dev/null 2>&1; then
        echo "${command_name} is not installed. Installing ${package_name}..."

        if ! apt-get update; then
            echo
            echo "Warning: apt-get update failed, possibly because of an unrelated broken repository."
            echo "dmux will still attempt to install ${package_name} using the existing package lists."
            echo
        fi

        if ! apt-get install -y "${package_name}"; then
            echo
            echo "Unable to install required dependency: ${package_name}" >&2
            echo "Fix your APT repository configuration, then run this installer again." >&2
            exit 1
        fi
    else
        echo "Missing dependency: ${command_name}" >&2
        echo "Install '${package_name}' with your system package manager, then run this installer again." >&2
        exit 1
    fi
}

trap cleanup EXIT

ensure_command git git
ensure_command tmux tmux

TMP_DIR="$(mktemp -d)"

git clone --depth 1 "${REPO_URL}" "${TMP_DIR}/dmux"
install -m 0755 "${TMP_DIR}/dmux/bin/dmux" "${INSTALL_PATH}"

if ! command -v dmux >/dev/null 2>&1; then
    echo "dmux was installed to ${INSTALL_PATH}, but the shell cannot locate it." >&2
    exit 1
fi

echo
echo "dmux installed successfully:"
command -v dmux
dmux --version 2>/dev/null || true
