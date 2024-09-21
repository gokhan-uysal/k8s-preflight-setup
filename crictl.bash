#!/bin/bash

source "utils.bash"

ARCH=$(get_arch)
OS=$(get_os)

DOWNLOAD_DIR="/usr/local/bin"
CRICTL_VERSION="v1.30.0"
CRICTL_ARCHIVE="crictl-${CRICTL_VERSION}-${OS}-${ARCH}.tar.gz"
CRICTL_URL="https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}"

log_info ""
log_info "Downloading crictl..."
if ! curl -LO "${CRICTL_URL}/${CRICTL_ARCHIVE}"; then
    log_error "Cannot install crictl ${CRICTL_VERSION}"
    exit 1
fi

log_info ""
log_info "Extracting crictl archive..."
if ! eval sudo tar Cxzvf "${DOWNLOAD_DIR}" "${CRICTL_ARCHIVE}"; then
    log_error "Cannot extract crictl archive"
    exit 1
fi
