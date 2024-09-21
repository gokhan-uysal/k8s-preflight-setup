#!/bin/bash

source "utils.bash"

ARCH=$(get_arch)
OS=$(get_os)

CNI_VERSION="1.5.1"
CNI_ARCHIVE="cni-plugins-${OS}-${ARCH}-v${CNI_VERSION}.tgz"
CNI_ARCHIVE_SUM="${CNI_ARCHIVE}.sha256"
CNI_URL="https://github.com/containernetworking/plugins/releases/download/v${CNI_VERSION}"
CNI_EXTRACT_DIR="/opt/cni/bin"

log_info "Downloading cni plugins..."
if [ -f "${CNI_ARCHIVE}" ]; then
    log_info "CNI archive with version ${CNI_VERSION} exists, skipping download"
else
    if ! curl -LO "${CNI_URL}/${CNI_ARCHIVE}"; then
        log_error "Failed to download cni archive"
        exit 1
    fi
fi

if [ -f "${CNI_ARCHIVE_SUM}" ]; then
    log_info "CNI archive checksum with version ${CNI_VERSION} exists, skipping download"
else
    if ! curl -LO "${CNI_URL}/${CNI_ARCHIVE_SUM}"; then
        log_error "Failed to download cni archive checksum"
        exit 1
    fi
fi

log_info ""
log_info "Verifying archive..."
if ! verify_sha256_sum "${CNI_ARCHIVE_SUM}"; then
    log_error "Cannot verify cni hash"
    exit 1
fi

log_info ""
log_info "Creating extract dir: ${CNI_EXTRACT_DIR}"
if ! eval sudo mkdir -p "${CNI_EXTRACT_DIR}"; then
    log_error "Cannot create extract directory ${CNI_EXTRACT_DIR}"
    exit 1
fi

log_info ""
log_info "Extracting archive..."
if ! eval sudo tar Cxzvf "${CNI_EXTRACT_DIR}" "${CNI_ARCHIVE}"; then
    log_error "Cannot extract cni plugins archive"
    exit 1
fi

log_info ""
log_info "CNI plugins setup done!"
