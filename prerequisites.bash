#!/bin/bash

source "utils.bash"

if ! nc 127.0.0.1 6443 -v; then
    log_info "Port 6443 is aviable, continuing"
else
    exit 1
fi

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
sudo sysctl net.ipv4.ip_forward

# Disable swap
sudo swapoff -a

# Load swapoff as systemd service
sudo cp units/swapoff.service /etc/systemd/system/swappoff.service
sudo systemctl daemon-reload
sudo systemctl enable --now swappoff.service
