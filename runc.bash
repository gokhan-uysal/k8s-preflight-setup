#!/bin/bash

source "utils.bash"

ARCH=$(get_arch)

RUNC_VERSION=v1.1.14
RUNC_BIN="runc.${ARCH}"
RUNC_BIN_SUM="${RUNC_BIN}.asc"
RUNC_URL="https://github.com/opencontainers/runc/releases/download/${RUNC_VERSION}"

log_info "Downloading runc..."
if [ -f "${RUNC_BIN}" ]; then
    log_info "Runc bin with version ${RUNC_VERSION} exists, skipping download"
else
    if ! curl -LO "${RUNC_URL}/${RUNC_BIN}"; then
        log_error "Failed to download runc bin"
        exit 1
    fi
fi

if [ -f "${RUNC_BIN_SUM}" ]; then
    log_info "Runc bin checksum with version ${RUNC_VERSION} exists, skipping download"
else
    if ! curl -LO "${RUNC_URL}/${RUNC_BIN_SUM}"; then
        log_error "Failed to download runc bin checksum"
        exit 1
    fi
fi

# log_info ""
# log_info "Verifying bin..."
# if ! verify_asc_sum "${RUNC_BIN_SUM}"; then
#     log_error "Cannot verify runc hash"
#     exit 1
# fi

log_info ""
log_info "Installing runc..."
if ! sudo install -m 755 "${RUNC_BIN}" /usr/local/sbin/runc; then
    log_error "Failed  to install runc binary"
    exit 1
fi

log_info ""
log_info "Runc setup done!"
