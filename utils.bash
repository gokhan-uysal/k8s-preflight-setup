#!/bin/bash

# Logger helper function
function log {
    local LEVEL=$1
    shift
    local MESSAGE
    local TIMESTAMP
    MESSAGE="$*"
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

    echo "${TIMESTAMP} [${LEVEL}] ${MESSAGE}"
}

function log_error {
    log "ERROR" "$@"
}

function log_info {
    log "INFO" "$@"
}

function log_debug {
    log "DEBUG" "$@"
}

function log_warning {
    log "WARNING" "$@"
}

# Archive helper functions
function verify_sha256_sum {
    sha256sum -c "$1"
}

function verify_asc_sum {
    gpg --verify "$1"
}

# OS helper functions
function get_arch {
    local arch
    arch=$(arch)
    if [ "$arch" = "aarch64" ]; then
        arch="arm64"
    fi

    echo "$arch"
}

function get_os {
    local os
    os=$(uname)

    echo "$os" | tr '[:upper:]' '[:lower:]'
}
