#!/bin/bash

source "utils.bash"

ARCH=$(get_arch)
OS=$(get_os)

CONTAINERD_VERSION=1.7.22
CONTAINERD_UNIT_FILE="units/containerd.service"
CONTAINERD_CONFIG_FILE="configs/containerd.config.toml"
CONTAINERD_ARCHIVE="containerd-${CONTAINERD_VERSION}-${OS}-${ARCH}.tar.gz"
CONTAINERD_ARCHIVE_SUM="${CONTAINERD_ARCHIVE}.sha256sum"
CONTAINERD_URL="https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}"

log_info "Downloading containerd..."
if [ -f "${CONTAINERD_ARCHIVE}" ]; then
	log_info "Containerd archive with version ${CONTAINERD_VERSION} exists, skipping download"
else
	if ! curl -LO "${CONTAINERD_URL}/${CONTAINERD_ARCHIVE}"; then
		log_error "Failed to download containerd archive"
		exit 1
	fi
fi

if [ -f "${CONTAINERD_ARCHIVE_SUM}" ]; then
	log_info "Containerd archive checksum with version ${CONTAINERD_VERSION} exists, skipping download"
else
	if ! curl -LO "${CONTAINERD_URL}/${CONTAINERD_ARCHIVE_SUM}"; then
		log_error "Failed to download containerd archive checksum"
		exit 1
	fi
fi

log_info ""
log_info "Verifying archive..."
if ! verify_sha256_sum "${CONTAINERD_ARCHIVE_SUM}"; then
	log_error "Cannot verify containerd hash"
	exit 1
fi

log_info ""
log_info "Extracting archive..."
if ! eval sudo tar Cxzvf /usr/local "${CONTAINERD_ARCHIVE}"; then
	log_error "Cannot extract containerd archive"
	exit 1
fi

log_info ""
log_info "Creating containerd config file..."
if ! sudo mkdir -p /etc/containerd; then
	log_error "Cannot create containerd config dir"
	exit 1
fi
if [ -r "${CONTAINERD_CONFIG_FILE}" ]; then
	log_info "Containerd config file exists inside ${CONTAINERD_CONFIG_FILE}"
else
	if ! containerd config default >${CONTAINERD_CONFIG_FILE}; then
		log_error "Cannot create containerd config file"
		exit 1
	fi
fi
if ! sudo cp "${CONTAINERD_CONFIG_FILE}" /etc/containerd/config.toml; then
	log_error "Cannot copy containerd config file"
	exit 1
fi

log_info ""
log_info "Creating containerd unit file..."
if [ ! -r "${CONTAINERD_UNIT_FILE}" ]; then
	log_error "containerd.service file does not exists nor have read permissions"
	exit 1
fi
if ! sudo cp "${CONTAINERD_UNIT_FILE}" /etc/systemd/system/containerd.service; then
	log_error "Cannot copy containerd.service unit file"
	exit 1
fi

log_info ""
log_info "Starting containerd with systemd..."
if ! sudo systemctl daemon-reload; then
	log_error "Cannot reload systemd"
	exit 1
fi
if ! sudo systemctl enable --now containerd; then
	log_error "Cannot start containerd.service"
	exit 1
fi

log_info ""
log_info "Containerd setup done!"
